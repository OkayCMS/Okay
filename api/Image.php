<?php

require_once('Okay.php');

class Image extends Okay {
    
    private $allowed_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
    private $gregwar_image;
    
    public function __construct() {
        parent::__construct();
        $this->gregwar_image = new Gregwar\Image\Image();
    }
    
    /**
     * Создание превью изображения
     * @param $filename файл с изображением (без пути к файлу)
     * @param max_w максимальная ширина
     * @param max_h максимальная высота
     * @return $string имя файла превью
     */
    public function resize($filename, $original_images_dir = null, $resized_images_dir = null) {
        list($source_file, $width , $height, $set_watermark, $crop_params) = $this->get_resize_params($filename);

        $size = $width.'x'.$height.($set_watermark === true ? 'w' : '');
        if ($resized_images_dir === null || $resized_images_dir == $this->config->resized_images_dir) {
            $image_sizes = explode('|', $this->settings->products_image_sizes);
        } else {
            $image_sizes = explode('|', $this->settings->image_sizes);
        }
        if (!in_array($size, $image_sizes)){
            header("http/1.1 404 not found");
            exit();
        }
        
        // Если вайл удаленный (http://), зальем его себе
        if (preg_match("~^https?://~", $source_file)) {
            // Имя оригинального файла
            if(!$original_file = $this->download_image($source_file)) {
                return false;
            }
        } else {
            $original_file = $source_file;
        }
        
        $resized_file = $this->add_resize_params($original_file, $width, $height, $set_watermark, $crop_params);
        
        // Пути к папкам с картинками
        if ($original_images_dir && !$resized_images_dir) {
            $resized_images_dir = $original_images_dir;
        } else {
            if (!$original_images_dir) {
                $original_images_dir = $this->config->original_images_dir;
            }
            if (!$resized_images_dir) {
                $resized_images_dir = $this->config->resized_images_dir;
            }
        }
        $originals_dir = $this->config->root_dir.$original_images_dir;
        $preview_dir = $this->config->root_dir.$resized_images_dir;

        if (!file_exists($originals_dir.$original_file)) {
            return false;
        }

        $watermark_offet_x = $this->settings->watermark_offset_x;
        $watermark_offet_y = $this->settings->watermark_offset_y;
        
        if($set_watermark && is_file($this->config->root_dir.$this->config->watermark_file)) {
            $watermark = $this->config->root_dir.$this->config->watermark_file;
        } else {
            $watermark = null;
        }

        if ($this->config->resize_library == 'gregwar_image') {
            $this->image_gregwar_image($originals_dir.$original_file, $preview_dir.$resized_file, $width, $height, $watermark, $watermark_offet_x, $watermark_offet_y, $crop_params);
        } elseif ($this->config->resize_library == 'imagick' && class_exists('Imagick')) {
            $this->image_constrain_imagick($originals_dir.$original_file, $preview_dir.$resized_file, $width, $height, $watermark, $watermark_offet_x, $watermark_offet_y);
        } else {
            $this->image_constrain_gd($originals_dir.$original_file, $preview_dir.$resized_file, $width, $height, $watermark, $watermark_offet_x, $watermark_offet_y);
        }
        
        return $preview_dir.$resized_file;
    }

    /*Добавление параметров ресайза для изображения*/
    public function add_resize_params($filename, $width=0, $height=0, $set_watermark=false, $crop_params = array()) {
        if('.' != ($dirname = pathinfo($filename,  PATHINFO_DIRNAME))) {
            $file = $dirname.'/'.pathinfo($filename, PATHINFO_FILENAME);
        } else {
            $file = pathinfo($filename, PATHINFO_FILENAME);
        }
        $ext = pathinfo($filename, PATHINFO_EXTENSION);
        
        if($width>0 || $height>0) {
            $resized_filename = $file.'.'.($width>0?$width:'').'x'.($height>0?$height:'').($set_watermark?'w':'');
        } else {
            $resized_filename = $file.($set_watermark?'.w':'').$ext;
        }

        if ($crop_params['x_pos'] && $crop_params['y_pos']) {
            $resized_filename .= '.'.$crop_params['x_pos'].'.'.$crop_params['y_pos'];
        }

        return $resized_filename.'.'.$ext;
    }

    /*Выборка параметров изображения для ресайза*/
    public function get_resize_params($filename) {
        // Определаяем параметры ресайза
        if(!preg_match('/(.+)\.([0-9]*)x([0-9]*)(w)?(\.(left|center|right)\.(top|center|bottom))?\.([^\.]+)$/', $filename, $matches)) {
            return false;
        }

        $file = $matches[1];                 // имя запрашиваемого файла
        $width = $matches[2];                // ширина будущего изображения
        $height = $matches[3];               // высота будущего изображения
        $set_watermark = $matches[4] == 'w'; // ставить ли водяной знак
        $ext = $matches[8];                  // расширение файла

        // crop params
        if (!empty($matches[5])) {
            $crop_params['x_pos'] = $matches[6];
            $crop_params['y_pos'] = $matches[7];
        }

        return array($file.'.'.$ext, $width, $height, $set_watermark, $crop_params);
    }

    /*Загрузка изображения*/
    public function download_image($filename) {
        $encoded_filename = rawurlencode($filename);
        // Заливаем только есть такой файл есть в базе
        $this->db->query('SELECT 1 FROM __images WHERE filename=? LIMIT 1', $encoded_filename);
        if(!$this->db->result()) {
            return false;
        }

        // Имя оригинального файла
        $basename = preg_replace('~(.+)\.([0-9]*)x([0-9]*)(w)?\.([^\.\?]+)(\?.*)?$~', '${1}.${5}', $filename);
        $basename = explode('&', pathinfo($basename, PATHINFO_BASENAME));
        $uploaded_file = array_shift($basename);
        $base = urldecode(pathinfo($uploaded_file, PATHINFO_FILENAME));
        $ext = pathinfo($uploaded_file, PATHINFO_EXTENSION);
        
        // Если такой файл существует, нужно придумать другое название
        $new_name = urldecode($uploaded_file);
        
        while(file_exists($this->config->root_dir.$this->config->original_images_dir.$new_name)) {
            $new_base = pathinfo($new_name, PATHINFO_FILENAME);
            if(preg_match('/_([0-9]+)$/', $new_base, $parts)) {
                $new_name = $base.'_'.($parts[1]+1).'.'.$ext;
            } else {
                $new_name = $base.'_1.'.$ext;
            }
        }
        
        $local_file = $this->config->root_dir.$this->config->original_images_dir.$new_name;
        // Перед долгим копированием займем это имя
        fclose(fopen($local_file, 'w'));
        if (copy($filename, $local_file) && filesize($local_file) > 0) {
            $this->db->query('UPDATE __images SET filename=? WHERE filename=?', $new_name, $encoded_filename);
            return $new_name;
        }
        // Если по https не получилось сохранить изображение, попробуем на тот же урл постучаться на http
        elseif (preg_match("~^https://~", $filename)) {
            $filename_http = preg_replace("~^https://~", "http://", $filename);
            $headers = @get_headers($filename_http);
            if (!empty($headers[0])) {
                preg_match('/\d{3}/', $headers[0], $matches);
                // Если урл по http отдает 200, забираем изображение
                if ($matches[0] == '200' && copy($filename_http, $local_file) && filesize($local_file) > 0) {
                    $this->db->query('UPDATE __images SET filename=? WHERE filename=?', $new_name, $encoded_filename);
                    return $new_name;
                } else {
                    @unlink($local_file);
                    return false;
                }
            }
        } else {
            @unlink($local_file);
            return false;
        }
    }

    /*Загрузка изображения*/
    public function upload_image($filename, $name, $original_dir = null) {
        // Имя оригинального файла
        $name = preg_replace('~(.+)\.([0-9]*)x([0-9]*)(w)?\.([^\.\?]+)$~', '${1}.${5}', $name);
        $name = $this->correct_filename($name);
        $uploaded_file = $new_name = pathinfo($name, PATHINFO_BASENAME);
        $base = pathinfo($uploaded_file, PATHINFO_FILENAME);
        $ext = pathinfo($uploaded_file, PATHINFO_EXTENSION);

        if (!$original_dir) {
            $original_dir = $this->config->original_images_dir;
        }
        if(in_array(strtolower($ext), $this->allowed_extentions)) {
            while(file_exists($this->config->root_dir.$original_dir.$new_name)) {
                $new_base = pathinfo($new_name, PATHINFO_FILENAME);
                if(preg_match('/_([0-9]+)$/', $new_base, $parts)) {
                    $new_name = $base.'_'.($parts[1]+1).'.'.$ext;
                } else {
                    $new_name = $base.'_1.'.$ext;
                }
            }
            if(move_uploaded_file($filename, $this->config->root_dir.$original_dir.$new_name)) {
                return $new_name;
            }
        }
        return false;
    }

    private function image_gregwar_image($src_file, $dst_file, $max_w, $max_h, $watermark=null, $watermark_offet_x=0, $watermark_offet_y=0, $crop_params) {

        $image = $this->gregwar_image->open($src_file);

        // размеры исходного изображения
        $src_w = $image->width();
        $src_h = $image->height();

        list($dst_w, $dst_h) = $this->calc_contrain_size($src_w, $src_h, $max_w, $max_h);
        if (!empty($crop_params)) {
            $x_pos = $crop_params['x_pos'];
            $y_pos = $crop_params['y_pos'];

            $dst_w = min($src_w, $max_w);
            $dst_h = min($src_h, $max_h);

            $image->zoomCrop($dst_w, $dst_h, 'transparent', $x_pos, $y_pos);
        } else {
            $image->cropResize($dst_w, $dst_h);
        }

        if ($watermark && is_readable($watermark)) {
            $watermark_image = $this->gregwar_image->open($watermark);

            // размеры водяного знака
            $watermark_width  = $watermark_image->width();
            $watermark_height = $watermark_image->height();

            $watermark_x = min(($dst_w-$watermark_width)*$watermark_offet_x/100, $dst_w);
            $watermark_y = min(($dst_h-$watermark_height)*$watermark_offet_y/100, $dst_h);

            $image->merge($watermark_image, $watermark_x, $watermark_y, $watermark_width, $watermark_height);
        }

        $src_ext = $image->guessType();
        if ($src_ext == 'gif') {
            $src_ext = 'png';
        }
        $image->save($dst_file, $src_ext, $this->settings->image_quality ? $this->settings->image_quality : 80);
    }

    /**
     * Создание превью средствами gd
     * @param $src_file исходный файл
     * @param $dst_file файл с результатом
     * @param max_w максимальная ширина
     * @param max_h максимальная высота
     * @return bool
     */
    private function image_constrain_gd($src_file, $dst_file, $max_w, $max_h, $watermark=null, $watermark_offet_x=0, $watermark_offet_y=0) {
        $quality = 100;
        
        // Параметры исходного изображения
        @list($src_w, $src_h, $src_type) = array_values(getimagesize($src_file));
        $src_type = image_type_to_mime_type($src_type);
        
        if(empty($src_w) || empty($src_h) || empty($src_type)) {
            return false;
        }
        
        // Нужно ли обрезать?
        if (!$watermark && ($src_w <= $max_w) && ($src_h <= $max_h)) {
            // Нет - просто скопируем файл
            if (!copy($src_file, $dst_file)) {
                return false;
            }
            return true;
        }
        
        // Размеры превью при пропорциональном уменьшении
        @list($dst_w, $dst_h) = $this->calc_contrain_size($src_w, $src_h, $max_w, $max_h);
        
        // Читаем изображение
        switch ($src_type) {
            case 'image/jpeg':
                $src_img = imageCreateFromJpeg($src_file);
                break;
            case 'image/gif':
                $src_img = imageCreateFromGif($src_file);
                break;
            case 'image/png':
                $src_img = imageCreateFromPng($src_file);
                imagealphablending($src_img, true);
                break;
            default:
                return false;
        }
        
        if(empty($src_img)) {
            return false;
        }
        
        $src_colors = imagecolorstotal($src_img);
        
        // create destination image (indexed, if possible)
        if ($src_colors > 0 && $src_colors <= 256) {
            $dst_img = imagecreate($dst_w, $dst_h);
        } else {
            $dst_img = imagecreatetruecolor($dst_w, $dst_h);
        }
        
        if (empty($dst_img)) {
            return false;
        }
        
        $transparent_index = imagecolortransparent($src_img);
        if ($transparent_index >= 0 && $transparent_index <= 128) {
            $t_c = imagecolorsforindex($src_img, $transparent_index);
            $transparent_index = imagecolorallocate($dst_img, $t_c['red'], $t_c['green'], $t_c['blue']);
            if ($transparent_index === false) {
                return false;
            }
            if (!imagefill($dst_img, 0, 0, $transparent_index)) {
                return false;
            }
            imagecolortransparent($dst_img, $transparent_index);
        }
        // or preserve alpha transparency for png
        elseif ($src_type === 'image/png') {
            if (!imagealphablending($dst_img, false)) {
                return false;
            }
            $transparency = imagecolorallocatealpha($dst_img, 0, 0, 0, 127);
            if (false === $transparency) {
                return false;
            }
            if (!imagefill($dst_img, 0, 0, $transparency)) {
                return false;
            }
            if (!imagesavealpha($dst_img, true)) {
                return false;
            }
        }
        
        // resample the image with new sizes
        if (!imagecopyresampled($dst_img, $src_img, 0, 0, 0, 0, $dst_w, $dst_h, $src_w, $src_h)) {
            return false;
        }
        
        // Watermark
        if(!empty($watermark) && is_readable($watermark)) {
            $overlay = imagecreatefrompng($watermark);
            
            // Get the size of overlay
            $owidth = imagesx($overlay);
            $oheight = imagesy($overlay);
            
            $watermark_x = min(($dst_w-$owidth)*$watermark_offet_x/100, $dst_w);
            $watermark_y = min(($dst_h-$oheight)*$watermark_offet_y/100, $dst_h);
            
            imagecopy($dst_img, $overlay, $watermark_x, $watermark_y, 0, 0, $owidth, $oheight);
        }
        
        // recalculate quality value for png image
        if ('image/png' === $src_type) {
            $quality = round(($quality / 100) * 10);
            if ($quality < 1) {
                $quality = 1;
            } elseif ($quality > 10) {
                $quality = 10;
            }
            $quality = 10 - $quality;
        }
        
        // Сохраняем изображение
        switch ($src_type) {
            case 'image/jpeg':
                return imageJpeg($dst_img, $dst_file, $quality);
            case 'image/gif':
                return imageGif($dst_img, $dst_file, $quality);
            case 'image/png':
                imagesavealpha($dst_img, true);
                return imagePng($dst_img, $dst_file, $quality);
            default:
                return false;
        }
    }
    
    /**
     * Создание превью средствами imagick
     * @param $src_file исходный файл
     * @param $dst_file файл с результатом
     * @param max_w максимальная ширина
     * @param max_h максимальная высота
     * @return bool
     */
    private function image_constrain_imagick($src_file, $dst_file, $max_w, $max_h, $watermark=null, $watermark_offet_x=0, $watermark_offet_y=0) {
        $thumb = new Imagick();

        $sharpen = 0.2;
        
        // Читаем изображение
        if(!$thumb->readImage($src_file)) {
            return false;
        }
        
        // Размеры исходного изображения
        $src_w = $thumb->getImageWidth();
        $src_h = $thumb->getImageHeight();
        
        // Нужно ли обрезать?
        if (!$watermark && ($src_w <= $max_w) && ($src_h <= $max_h)) {
            // Нет - просто скопируем файл
            if (!copy($src_file, $dst_file)) {
                return false;
            }
            return true;
        }
        
        // Размеры превью при пропорциональном уменьшении
        list($dst_w, $dst_h) = $this->calc_contrain_size($src_w, $src_h, $max_w, $max_h);
        
        // Уменьшаем
        $thumb->thumbnailImage($dst_w, $dst_h);
        
        // Устанавливаем водяной знак
        if($watermark && is_readable($watermark)) {
            $overlay = new Imagick($watermark);
            
            // Get the size of overlay
            $owidth = $overlay->getImageWidth();
            $oheight = $overlay->getImageHeight();
            
            $watermark_x = min(($dst_w-$owidth)*$watermark_offet_x/100, $dst_w);
            $watermark_y = min(($dst_h-$oheight)*$watermark_offet_y/100, $dst_h);
        }
        
        // Анимированные gif требуют прохода по фреймам
        foreach($thumb as $frame) {
            // Уменьшаем
            $frame->thumbnailImage($dst_w, $dst_h);
            
            /* Set the virtual canvas to correct size */
            $frame->setImagePage($dst_w, $dst_h, 0, 0);
            
            // Наводим резкость
            $thumb->adaptiveSharpenImage($sharpen, $sharpen);
            
            if(isset($overlay) && is_object($overlay)) {
                $frame->compositeImage($overlay, imagick::COMPOSITE_OVER, $watermark_x, $watermark_y, imagick::COLOR_ALPHA);
            }
        }
        
        // Убираем комменты и т.п. из картинки
        $thumb->stripImage();
        $thumb->setImageCompressionQuality($this->settings->image_quality ? $this->settings->image_quality : 80 );
        $thumb->setImageCompression($this->settings->image_quality ? $this->settings->image_quality : 80);
        
        // Записываем картинку
        if(!$thumb->writeImages($dst_file, true)) {
            return false;
        }
        
        // Уборка
        $thumb->destroy();
        if(isset($overlay) && is_object($overlay)) {
            $overlay->destroy();
        }
        return true;
    }
    
    /**
     * Вычисляет размеры изображения, до которых нужно его пропорционально уменьшить, чтобы вписать в квадрат $max_w x $max_h
     * @param src_w ширина исходного изображения
     * @param src_h высота исходного изображения
     * @param max_w максимальная ширина
     * @param max_h максимальная высота
     * @return array(w, h)
     */
    public function calc_contrain_size($src_w, $src_h, $max_w = 0, $max_h = 0) {
        if($src_w == 0 || $src_h == 0) {
            return false;
        }
        
        $dst_w = $src_w;
        $dst_h = $src_h;
        
        if($src_w > $max_w && $max_w>0) {
            $dst_h = $src_h * ($max_w/$src_w);
            $dst_w = $max_w;
        }
        if($dst_h > $max_h && $max_h>0) {
            $dst_w = $dst_w * ($max_h/$dst_h);
            $dst_h = $max_h;
        }
        return array($dst_w, $dst_h);
    }
    
    private function files_identical($fn1, $fn2) {
        $buffer_len = 1024;
        if(!$fp1 = fopen(dirname(dirname(__FILE__)).'/'.$fn1, 'rb')) {
            return FALSE;
        }
        
        if(!$fp2 = fopen($fn2, 'rb')) {
            fclose($fp1);
            return FALSE;
        }
        
        $same = TRUE;
        while (!feof($fp1) and !feof($fp2)) {
            if(fread($fp1, $buffer_len) !== fread($fp2, $buffer_len)) {
                $same = FALSE;
                break;
            }
        }
        
        if(feof($fp1) !== feof($fp2)) {
            $same = FALSE;
        }
        
        fclose($fp1);
        fclose($fp2);
        return $same;
    }

    /*Транслит названия изображения*/
    public function correct_filename($filename) {
        $ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я");
        $en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");
        
        $res = str_replace($ru, $en, $filename);
        $res = preg_replace("/[\s]+/ui", '-', $res);
        $res = preg_replace("/[^a-zA-Z0-9\.\-\_]+/ui", '', $res);
        $res = strtolower($res);
        return $res;
    }

    /**
     * Удаления изображения и его ресайзов
     * id - id сущности
     * field - поле в таблице
     * table - имя таблицы без префиксов like "blog"(not "__blog" or "s_blog")
    */
    public function delete_image($id, $field = null, $table = null, $original_dir = null, $resized_dir = null, $lang_id = 0, $lang_field = '') {
        if (!$field || !$table || !$original_dir) {
            return false;
        }
        if (!$lang_id) {
            $query = $this->db->placehold("SELECT $field FROM __$table WHERE id=?", $id);
            $this->db->query($query);
            $filename = $this->db->result($field);
    
            if (!empty($filename)) {
                $query = $this->db->placehold("UPDATE __$table SET $field='' WHERE id=?", $id);
                $this->db->query($query);
    
                $query = $this->db->placehold("SELECT count(*) as count FROM __$table WHERE $field=? LIMIT 1", $filename);
                $this->db->query($query);
                $count = $this->db->result('count');
                if($count == 0) {
                    $file = pathinfo($filename, PATHINFO_FILENAME);
                    $ext = pathinfo($filename, PATHINFO_EXTENSION);
    
                    // Удалить все ресайзы
                    if (!empty($resized_dir)) {
                        $rezised_images = glob($this->config->root_dir.$resized_dir.$file.".*x*.".$ext);
                        if(is_array($rezised_images)) {
                            foreach ($rezised_images as $f) {
                                @unlink($f);
                            }
                        }
                    }
    
                    @unlink($this->config->root_dir.$original_dir.$filename);
                }
            }
        } else {
            $query = $this->db->placehold("SELECT $field FROM __lang_$table WHERE $lang_field=? and lang_id=?", $id, $lang_id);
            $this->db->query($query);
            $filename = $this->db->result($field);
    
            if (!empty($filename)) {
                $query = $this->db->placehold("UPDATE __lang_$table SET $field='' WHERE $lang_field=? and lang_id=?", $id, $lang_id);
                $this->db->query($query);
    
                $query = $this->db->placehold("SELECT count(*) as count FROM __lang_$table WHERE $field=? LIMIT 1", $filename);
                $this->db->query($query);
                $count = $this->db->result('count');
                if($count == 0) {
                    $file = pathinfo($filename, PATHINFO_FILENAME);
                    $ext = pathinfo($filename, PATHINFO_EXTENSION);
    
                    // Удалить все ресайзы
                    if (!empty($resized_dir)) {
                        $rezised_images = glob($this->config->root_dir.$resized_dir.$file.".*x*.".$ext);
                        if(is_array($rezised_images)) {
                            foreach ($rezised_images as $f) {
                                @unlink($f);
                            }
                        }
                    }
    
                    @unlink($this->config->root_dir.$original_dir.$filename);
                }
            }
        }
    }
}
