<?php

require_once('api/Okay.php');

class LicenseAdmin extends Okay {
    
    public function fetch() {
        if($this->request->method('POST')) {
            $license = $this->request->post('license');
            $this->config->license = trim($license);
        }
        
        $p=13; $g=3; $x=5; $r = ''; $s = $x;
        $bs = explode(' ', $this->config->license);
        foreach($bs as $bl){
            for($i=0, $m=''; $i<strlen($bl)&&isset($bl[$i+1]); $i+=2){
                $a = base_convert($bl[$i], 36, 10)-($i/2+$s)%27;
                $b = base_convert($bl[$i+1], 36, 10)-($i/2+$s)%24;
                $m .= ($b * (pow($a,$p-$x-5) )) % $p;}
            $m = base_convert($m, 10, 16); $s+=$x;
            for ($a=0; $a<strlen($m); $a+=2) $r .= @chr(hexdec($m{$a}.$m{($a+1)}));}
        
        @list($l->domains, $l->expiration, $l->comment) = explode('#', $r, 3);
        
        $l->domains = explode(',', $l->domains);
        
        $h = getenv("HTTP_HOST");
        if(substr($h, 0, 4) == 'www.') {
            $h = substr($h, 4);
        }
        $l->valid = true;
        $sv = false;$da = explode('.', $h);$it = count($da);
        for ($i=1;$i<=$it;$i++) {
            unset($da[0]);$da = array_values($da);$d = '*.'.implode('.', $da);
            if (in_array($d, $l->domains) || in_array('*.'.$h, $l->domains)) {
                $sv = true;break;
            }
        }
        if(!in_array($h, $l->domains) && !$sv) {
            $l->valid = false;
        }
        if(strtotime($l->expiration)<time() && $l->expiration!='*') {
            $l->valid = false;
        }
        
        $this->design->assign('license', $l);
        return $this->design->fetch('license.tpl');
    }
    
}
