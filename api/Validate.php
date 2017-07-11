<?php

class Validate {

    private $denied = array(
        "<script", "</script",
        "<iframe", "</iframe",

    );

    /**
     * @param string $email
     * @param bool $is_required
     * if $email is empty AND !$is_required return true
     * @return bool
     */
    public function is_email($email = "", $is_required = false) {
        // general
        if (!$this->is_safe($email)) {
            return false;
        }
        if (empty($email)) {
            return !$is_required ? true : false;
        }
        // for email
        if (!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$/ui", $email)) {
            return false;
        }
        return true;
    }

    /**
     * @param string $phone
     * @param bool $is_required
     * if $phone is empty AND !$is_required return true
     * @return bool
     */
    public function is_phone($phone = "", $is_required = false) {
        // general
        if (!$this->is_safe($phone)) {
            return false;
        }
        if (empty($phone)) {
            return !$is_required ? true : false;
        }
        // for phone
        if (preg_match("~([^0-9 _\+\-\(\)]+)~", $phone)) {
            return false;
        }
        if (strlen(preg_replace("~[^\d]~", "", $phone)) < 7) {
            return false;
        }
        return true;
    }

    /**
     * @param string $name
     * @param bool $is_required
     * if $name is empty AND !$is_required return true
     * @return bool
     */
    public function is_name($name = "", $is_required = false) {
        // general
        if (!$this->is_safe($name)) {
            return false;
        }
        if (empty($name)) {
            return !$is_required ? true : false;
        }
        // for name
        // ...
        return true;
    }

    public function is_address($address = "", $is_required = false) {
        // general
        return $this->is_safe($address, $is_required);
        // ...
        //return true;
    }

    public function is_comment($comment = "", $is_required = false) {
        // general
        return $this->is_safe($comment, $is_required);
        // ...
        //return true;
    }

    /**
     * @param string $src
     * @param bool $is_required
     * if $src is empty AND $is_required return false
     * @return bool
     */
    public function is_safe($src = "", $is_required = false) {
        if (!empty($src)) {
            foreach ($this->denied as $item) {
                if (strpos($src, $item) !== false) {
                    return false;
                }
            }
        } elseif ($is_required) {
            return false;
        }
        return true;
    }

}