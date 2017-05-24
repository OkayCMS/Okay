<?php

require_once('Okay.php');

class Translations extends Okay {
    
    private $vars = array();

    public function __construct() {
        parent::__construct();
    }

    /*Запись переводов*/
    private function write_translations($lang_label, $translations) {
        if (empty($lang_label)) {
            return;
        }
        $dir = __DIR__.'/../design/'.$this->settings->theme.'/lang/';
        if (file_exists($dir)) {
            $content = "<?php\n\n";
            $content .= "\$lang = array();\n";
            foreach($translations as $label=>$value) {
                $content .= "\$lang['".$label."'] = \"".addcslashes($value, "\n\r\\\"")."\";\n";
            }
            $file = fopen($dir.$lang_label.'.php', 'w');
            fwrite($file, $content);
            fclose($file);
        }
    }

    /*Инициализация перевода*/
    private function init_one($label = "") {
        if (empty($label)) {
            return false;
        }
        if (!isset($this->vars[$label])) {
            $file = __DIR__.'/../design/'.$this->settings->theme.'/lang/'.$label.'.php';
            if (file_exists($file)) {
                $lang = array();
                require_once $file;
                $this->vars[$label] = $lang;
            } else {
                $this->vars[$label] = array();
            }
        }
        return $this->vars[$label];
    }
    
    private function init_translations() {
        foreach ($this->languages->get_languages() as $l) {
            $this->init_one($l->label);
        }
        return $this->vars;
    }

    /*Выборка перевода*/
    public function get_translation($id) {
        $translation = array();
        foreach ($this->languages->get_languages() as $l) {
            $result = $this->init_one($l->label);
            if (isset($result[$id])) {
                $translation['lang_' . $l->label] = $result[$id];
            }
        }
        if (count($translation) > 0) {
            $translation['id'] = $id;
            $translation['label'] = $id;
            return (object)$translation;
        }
        return false;
    }

    /*Выборка всех переводов*/
    public function get_translations($filter = array()) {
        if (!empty($filter['lang'])) {
            $result = $this->init_one($filter['lang']);
        } else {
            $result = array();
            die('get_translations empty(filter["lang"])');
        }
        if (!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'label':
                    ksort($result);
                    break;
                case 'label_desc':
                    krsort($result);
                    break;
                case 'date_desc':
                    $result = array_reverse($result);
                    break;
                case 'translation':
                    asort($result);
                    break;
                case 'translation_desc':
                    arsort($result);
                    break;
            }
        }
        return (object)$result;
    }

    /*Обновление перевода*/
    /* id - предыдущий(или обновляемый) label, $data['label'] - новый */
    public function update_translation($id, $data) {
        $data = (array)$data;
        $this->init_translations();
        foreach ($this->vars as $lang_label=>&$translations) {
            if ($id != $data['label']) {
                unset($translations[$id]);
            }
            $translations[$data['label']] = $data['lang_'.$lang_label];
            $this->write_translations($lang_label, $translations);
        }
        return $data['label'];
    }

    /*удаление перевода*/
    /* id - удаляемый label */
    public function delete_translation($id) {
        if(!empty($id)) {
            $this->init_translations();
            foreach ($this->vars as $lang_label=>&$translations) {
                unset($translations[$id]);
                $this->write_translations($lang_label, $translations);
            }
        }
    }

    /*Дублирование переводов*/
    public function copy_translations($label_src, $label_dest) {
        if (empty($label_src) || empty($label_dest) || $label_src == $label_dest) {
            return;
        }
        $themes_dir = __DIR__.'/../design/';
        foreach (glob($themes_dir.'*', GLOB_ONLYDIR) as $theme) {
            if (file_exists($theme.'/lang/')) {
                $src = $theme.'/lang/'.$label_src.'.php';
                $dest = $theme.'/lang/'.$label_dest.'.php';
                if (file_exists($src) && !file_exists($dest)) {
                    copy($src, $dest);
                    @chmod($dest, 0664);
                }
            }
        }
    }

}
