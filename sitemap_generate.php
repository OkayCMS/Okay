<?php

//for cron!
//chdir('/home/path/example.com/www');
require_once('api/Okay.php');
$okay = new Okay();

//for cron! --- id языка в cron запросе
//$okay->languages->set_lang_id($argv[1]);
$language = $okay->languages->get_language($okay->languages->lang_id());

$l = '';
$lang_link = '';
if (!empty($language)) {
    $l = '_'.$language->label;
    $lang_link = $okay->languages->get_lang_link();
}

$sub_sitemaps = glob($okay->config->root_dir."/sitemap".$l."_*.xml");
if(is_array($sub_sitemaps)) {
    foreach ($sub_sitemaps as $sitemap) {
        @unlink($sitemap);
    }
}
if (file_exists($okay->config->root_dir."/sitemap".$l.".xml")) {
    @unlink($okay->config->root_dir."sitemap".$l.".xml");
}
$sitemap_index = 1;
$url_index = 1;
//header("Content-type: text/xml; charset=UTF-8");
file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);

// Главная страница
//for cron!
//$okay->config->root_url = 'http://example.com';
$url = $okay->config->root_url.'/'.$lang_link;

file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t<url>"."\n", FILE_APPEND);
file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<changefreq>daily</changefreq>"."\n", FILE_APPEND);
file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<priority>1.0</priority>"."\n", FILE_APPEND);
file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t</url>"."\n", FILE_APPEND);

// Страницы
foreach($okay->pages->get_pages() as $p) {
    if($p->visible && $p->menu_id == 1 && $p->url) {
        $url = $okay->config->root_url.'/'.$lang_link.esc($p->url);
        $last_modify = array();
        if ($p->url == 'blog') {
            $okay->db->query("SELECT b.last_modify FROM __blog b");
            $last_modify = $okay->db->results('last_modify');
            $last_modify[] = $okay->settings->lastModifyPosts;
        }
        $last_modify[] = $p->last_modify;
        $last_modify = max($last_modify);
        $last_modify = substr($last_modify, 0, 10);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t<url>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<changefreq>daily</changefreq>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<priority>1.0</priority>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t</url>"."\n", FILE_APPEND);
        if (++$url_index == 50000) {
            file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '</urlset>'."\n", FILE_APPEND);
            $url_index=0;
            $sitemap_index++;
            file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
            file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);
        }
    }
}

// Блог
foreach($okay->blog->get_posts(array('visible'=>1)) as $p) {
    $url = $okay->config->root_url.'/'.$lang_link.$p->type_post.'/'.esc($p->url);
    $last_modify = substr($p->last_modify, 0, 10);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t<url>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<changefreq>daily</changefreq>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<priority>1.0</priority>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t</url>"."\n", FILE_APPEND);
    if (++$url_index == 50000) {
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '</urlset>'."\n", FILE_APPEND);
        $url_index=0;
        $sitemap_index++;
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);
    }
}

// Категории
foreach($okay->categories->get_categories() as $c) {
    if($c->visible) {
        $url = $okay->config->root_url.'/'.$lang_link.'catalog/'.esc($c->url);
        $last_modify = array();
        $okay->db->query("SELECT p.last_modify
            FROM __products p
            INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)
            WHERE 1
            GROUP BY p.id", $c->children);
        $res = $okay->db->results('last_modify');
        if (!empty($res)) {
            $last_modify = $res;
        }
        $last_modify[] = $c->last_modify;
        $last_modify = substr(max($last_modify), 0, 10);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t<url>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<changefreq>daily</changefreq>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<priority>1.0</priority>"."\n", FILE_APPEND);
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t</url>"."\n", FILE_APPEND);
        if (++$url_index == 50000) {
            file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '</urlset>'."\n", FILE_APPEND);{}
            $url_index=0;
            $sitemap_index++;
            file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
            file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);
        }
    }
}

// Бренды
foreach($okay->brands->get_brands() as $b) {
    $url = $okay->config->root_url.'/'.$lang_link.'brands/'.esc($b->url);
    $last_modify = array();
    $okay->db->query("SELECT p.last_modify
        FROM __products p
        WHERE p.brand_id=?", $b->id);
    $res = $okay->db->results('last_modify');
    if (!empty($res)) {
        $last_modify = $res;
    }
    $last_modify[] = $b->last_modify;
    $last_modify = substr(max($last_modify), 0, 10);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t<url>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<changefreq>daily</changefreq>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<priority>1.0</priority>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t</url>"."\n", FILE_APPEND);
    if (++$url_index == 50000) {
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '</urlset>'."\n", FILE_APPEND);
        $url_index=0;
        $sitemap_index++;
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);
    }
}

// Товары
$okay->db->query("SELECT url, last_modify FROM __products WHERE visible=1");
foreach($okay->db->results() as $p) {
    $url = $okay->config->root_url.'/'.$lang_link.'products/'.esc($p->url);
    $last_modify = substr($p->last_modify, 0, 10);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t<url>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<changefreq>weekly</changefreq>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t\t<priority>0.5</priority>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', "\t</url>"."\n", FILE_APPEND);
    if (++$url_index == 50000) {
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '</urlset>'."\n", FILE_APPEND);
        $url_index=0;
        $sitemap_index++;
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
        file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);
    }
}

file_put_contents('sitemap'.$l.'_'.$sitemap_index.'.xml', '</urlset>'."\n", FILE_APPEND);

$last_modify = date("Y-m-d");
file_put_contents('sitemap'.$l.'.xml', '<?xml version="1.0" encoding="UTF-8"?>'."\n");
file_put_contents('sitemap'.$l.'.xml', '<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'."\n", FILE_APPEND);
for ($i = 1; $i <= $sitemap_index; $i++) {
    $url = $okay->config->root_url.'/sitemap'.$l.'_'.$i.'.xml';
    file_put_contents('sitemap'.$l.'.xml', "\t<sitemap>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'.xml', "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'.xml', "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
    file_put_contents('sitemap'.$l.'.xml', "\t</sitemap>"."\n", FILE_APPEND);
}
file_put_contents('sitemap'.$l.'.xml', '</sitemapindex>'."\n", FILE_APPEND);

function esc($s) {
    return(htmlspecialchars($s, ENT_QUOTES, 'UTF-8'));
}