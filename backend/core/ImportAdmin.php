<?php

require_once('api/Import.php');

class ImportAdmin extends Import {

    /*Импорт товаров*/
    public function fetch() {
        $this->design->assign('import_files_dir', $this->import_files_dir);
        if(!is_writable($this->import_files_dir)) {
            $this->design->assign('message_error', 'no_permission');
        }

        // Проверяем локаль
        $old_locale = setlocale(LC_ALL, 0);
        setlocale(LC_ALL, $this->locale);
        if(setlocale(LC_ALL, 0) != $this->locale) {
            $this->design->assign('message_error', 'locale_error');
            $this->design->assign('locale', $this->locale);
        }
        setlocale(LC_ALL, $old_locale);

        if($this->request->method('post')) {
            if ($this->request->files("file") && $this->request->files("file")['error'] == UPLOAD_ERR_OK) {
                $uploaded_name = $this->request->files("file", "tmp_name");
                $temp = tempnam($this->import_files_dir, 'temp_');
                if (!move_uploaded_file($uploaded_name, $temp)) {
                    $this->design->assign('message_error', 'upload_error');
                }

                if (!$this->convert_file($temp, $this->import_files_dir . $this->import_file)) {
                    $this->design->assign('message_error', 'convert_error');
                } else {
                    $this->init_columns();
                    $lc_columns = array_map("mb_strtolower", $this->columns);
                    $duplicated_columns = array_diff_assoc($lc_columns, array_unique($lc_columns));
                    $duplicated_columns = array_unique($duplicated_columns);
                    $duplicated_columns_pairs = array();
                    foreach ($this->columns_names as $columns) {
                        $cnt = 0;
                        foreach ($columns as $column) {
                            if (in_array(mb_strtolower($column), $lc_columns) && ++$cnt > 1) {
                                $duplicated_columns_pairs[] = $columns;
                            }
                        }
                    }
                    if (!empty($duplicated_columns)) {
                        $this->design->assign('message_error', 'duplicated_columns');
                        $this->design->assign('duplicated_columns', $duplicated_columns);
                    } elseif (!empty($duplicated_columns_pairs)) {
                        $this->design->assign('message_error', 'duplicated_columns_pairs');
                        $this->design->assign('duplicated_columns_pairs', $duplicated_columns_pairs);
                    } else {
                        $this->design->assign('filename', $this->request->files("file", "name"));
                        $this->assign_columns_info();
                    }
                }
                unlink($temp);
            } elseif ($this->request->post('import')) {
                unset($_SESSION['csv_fields']);
                $fields = $this->request->post('csv_fields');
                if (empty($fields) || !in_array('sku', $fields) && !in_array('name', $fields)) {
                    $this->design->assign('message_error', 'required_fields');
                    $this->design->assign('filename', 1);
                    $this->init_columns();
                    $this->assign_columns_info($fields);
                } else {
                    $_SESSION['csv_fields'] = $fields;
                    $this->design->assign('import', 1);
                }
            }
        }
        $file = new stdClass();
        if (file_exists($this->import_files_dir . $this->import_file)) {
            $file->name = $this->import_file;
            $file->date = date("d.m.Y H:i:s", filemtime($this->import_files_dir . $this->import_file));
            $file->size = filesize($this->import_files_dir . $this->import_file);
        }
        $this->design->assign('file', $file);
        
        return $this->design->fetch('import.tpl');
    }
    
    private function convert_file($source, $dest) {
        // Узнаем какая кодировка у файла
        $teststring = file_get_contents($source, null, null, null, 1000000);
        
        // Кодировка - UTF8 
        if (preg_match('//u', $teststring)) {
            // Просто копируем файл
            return copy($source, $dest);
        } else {
            // Конвертируем в UFT8
            if(!$src = fopen($source, "r")) {
                return false;
            }
            
            if(!$dst = fopen($dest, "w")) {
                return false;
            }
            
            while (($line = fgets($src, 4096)) !== false) {
                $line = $this->win_to_utf($line);
                fwrite($dst, $line);
            }
            fclose($src);
            fclose($dst);
            return true;
        }
    }
    
    private function win_to_utf($text) {
        if(function_exists('iconv')) {
            return @iconv('windows-1251', 'UTF-8', $text);
        } else {
            $t = '';
            for($i=0, $m=strlen($text); $i<$m; $i++) {
                $c=ord($text[$i]);
                if ($c<=127) {$t.=chr($c); continue; }
                if ($c>=192 && $c<=207)    {$t.=chr(208).chr($c-48); continue; }
                if ($c>=208 && $c<=239) {$t.=chr(208).chr($c-48); continue; }
                if ($c>=240 && $c<=255) {$t.=chr(209).chr($c-112); continue; }
                //				if ($c==184) { $t.=chr(209).chr(209); continue; };
                //				if ($c==168) { $t.=chr(208).chr(129);  continue; };
                if ($c==184) { $t.=chr(209).chr(145); continue; }; #ё
                if ($c==168) { $t.=chr(208).chr(129); continue; }; #Ё
                if ($c==179) { $t.=chr(209).chr(150); continue; }; #і
                if ($c==178) { $t.=chr(208).chr(134); continue; }; #І
                if ($c==191) { $t.=chr(209).chr(151); continue; }; #ї
                if ($c==175) { $t.=chr(208).chr(135); continue; }; #ї
                if ($c==186) { $t.=chr(209).chr(148); continue; }; #є
                if ($c==170) { $t.=chr(208).chr(132); continue; }; #Є
                if ($c==180) { $t.=chr(210).chr(145); continue; }; #ґ
                if ($c==165) { $t.=chr(210).chr(144); continue; }; #Ґ
                if ($c==184) { $t.=chr(209).chr(145); continue; }; #Ґ
            }
            return $t;
        }
    }

    private function assign_columns_info($fields = array()) {
        $source_columns = $this->columns;
        $this->design->assign('columns_names', array_keys($this->columns_names));

        $this->db->query('SELECT f.name FROM __features f ORDER BY f.position');
        $features = $this->db->results('name');
        $this->design->assign('features', $features);

        $this->init_internal_columns();
        $internal_columns = array_keys($this->internal_columns_names);

        if (empty($fields)) {
            $selected = array();
            foreach ($features as $f) {
                $selected[$f] = $f;
            }
            $selected = array_merge($selected, $this->internal_columns_names);
        } else {
            $selected = $fields;
        }

        foreach ($source_columns as &$column) {
            $c = new stdClass();
            $c->name = $column;
            $c->value = $selected[$c->name];
            $c->is_feature = in_array($c->name, $features);
            $c->is_exist = in_array($c->name, $internal_columns) || $c->is_feature;
            $c->is_nf_selected = !$c->is_exist && $c->value==$c->name;
            $column = $c;
        }
        $this->design->assign('source_columns', $source_columns);
    }
    
}
