<?php

chdir(__DIR__);
require_once('api/Okay.php');
$okay = new Okay();
define("MAX_URLS", 50000);

/*
 * параметры с крона в виде key=val
 * доступные пары:
 * lang_label=ru
 * root_url=http://domain.com
 *
 * чтобы сгенерировать файлы с браузера нужно в браузере перейти по ссылке
 * http://domain.com/sitemap.php?output=file
 */
$params = array();
if (!empty($argv)) {
    $params['output'] = 'file';
    for ($i = 1; $i < count($argv); $i++) {
        $arg = explode("=", $argv[$i]);
        $params[$arg[0]] = $arg[1];
    }
    $params['root_url'] = trim($params['root_url']);
    $params['root_url'] = preg_replace("~^(https?://[^/]+)/.*$~", "$1", $params['root_url']);
    $_GET['lang_label'] = $params['lang_label'];
} else {
    if (isset($_GET['output']) && $_GET['output']=='file') {
        $params['output'] = 'file';
    } else {
        $params['output'] = 'browser';
    }
    $params['root_url'] = $okay->config->root_url;
}

$language = $okay->languages->get_language($okay->languages->lang_id());
$params['l'] = '';
$lang_link = '';
if (!empty($language)) {
    $params['l'] = '_'.$language->label;
    $lang_link = $okay->languages->get_lang_link();
}
$main_url = $params['root_url'].'/'.$lang_link;

if ($params['output'] == 'file') {
    $sub_sitemaps = glob($okay->config->root_dir . "/sitemap" . $params['l'] . "_*.xml");
    if (is_array($sub_sitemaps)) {
        foreach ($sub_sitemaps as $sitemap) {
            @unlink($sitemap);
        }
    }
    if (file_exists($okay->config->root_dir . "/sitemap" . $params['l'] . ".xml")) {
        @unlink($okay->config->root_dir . "sitemap" . $params['l'] . ".xml");
    }
} else {
    header("Content-type: text/xml; charset=UTF-8");
}

$sitemap_index = 1;
$url_index = 0;
write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
write("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");
$s = "\t<url>\n";
$s .= "\t\t<loc>$main_url</loc>\n";
$s .= "\t\t<changefreq>daily</changefreq>\n";
$s .= "\t\t<priority>1.0</priority>\n";
$s .= "\t</url>\n";
write($s, true);

// Страницы
foreach($okay->pages->get_pages() as $p) {
    if($p->visible && $p->url && $p->url != '404') {
        $url = $main_url.esc($p->url);
        $last_modify = array();
        if ($p->url == 'blog') {
            $okay->db->query("SELECT b.last_modify FROM __blog b");
            $last_modify = $okay->db->results('last_modify');
            $last_modify[] = $okay->settings->lastModifyPosts;
        }
        $last_modify[] = $p->last_modify;
        $last_modify = max($last_modify);
        $last_modify = substr($last_modify, 0, 10);
        $s = "\t<url>\n";
        $s .= "\t\t<loc>$url</loc>\n";
        $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
        $s .= "\t\t<changefreq>daily</changefreq>\n";
        $s .= "\t\t<priority>1.0</priority>\n";
        $s .= "\t</url>\n";
        write($s, true);
    }
}

// Блог
$posts_count = $okay->blog->count_posts(array('visible'=>1));
foreach($okay->blog->get_posts(array('visible'=>1, 'limit'=>$posts_count)) as $p) {
    $url = $main_url.$p->type_post.'/'.esc($p->url);
    $last_modify = substr($p->last_modify, 0, 10);
    $s = "\t<url>\n";
    $s .= "\t\t<loc>$url</loc>\n";
    $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
    $s .= "\t\t<changefreq>daily</changefreq>\n";
    $s .= "\t\t<priority>1.0</priority>\n";
    $s .= "\t</url>\n";
    write($s, true);
}

// Категории
foreach($okay->categories->get_categories() as $c) {
    if($c->visible) {
        $url = $main_url.'catalog/'.esc($c->url);
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
        $s = "\t<url>\n";
        $s .= "\t\t<loc>$url</loc>\n";
        $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
        $s .= "\t\t<changefreq>daily</changefreq>\n";
        $s .= "\t\t<priority>1.0</priority>\n";
        $s .= "\t</url>\n";
        write($s, true);
    }
}

// Бренды
$brands_count = $okay->brands->count_brands(array('visible_brand'=>1));
foreach($okay->brands->get_brands(array('visible_brand'=>1, 'limit'=>$brands_count)) as $b) {
    $url = $main_url.'brands/'.esc($b->url);
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
    $s = "\t<url>\n";
    $s .= "\t\t<loc>$url</loc>\n";
    $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
    $s .= "\t\t<changefreq>daily</changefreq>\n";
    $s .= "\t\t<priority>1.0</priority>\n";
    $s .= "\t</url>\n";
    write($s, true);
}

// Товары
$okay->db->query("SELECT url, last_modify FROM __products WHERE visible=1");
foreach($okay->db->results() as $p) {
    $url = $main_url.'products/'.esc($p->url);
    $last_modify = substr($p->last_modify, 0, 10);
    $s = "\t<url>\n";
    $s .= "\t\t<loc>$url</loc>\n";
    $s .= "\t\t<lastmod>$last_modify</lastmod>\n";
    $s .= "\t\t<changefreq>weekly</changefreq>\n";
    $s .= "\t\t<priority>0.5</priority>\n";
    $s .= "\t</url>\n";
    write($s, true);
}

write("</urlset>\n");

if ($params['output'] == 'file') {
    $last_modify = date("Y-m-d");
    $file = 'sitemap'.$params['l'].'.xml';
    file_put_contents($file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    file_put_contents($file, "<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n", FILE_APPEND);
    for ($i = 1; $i <= $sitemap_index; $i++) {
        $url = $params['root_url'].'/sitemap'.$params['l'].'_'.$i.'.xml';
        file_put_contents($file, "\t<sitemap>"."\n", FILE_APPEND);
        file_put_contents($file, "\t\t<loc>$url</loc>"."\n", FILE_APPEND);
        file_put_contents($file, "\t\t<lastmod>$last_modify</lastmod>"."\n", FILE_APPEND);
        file_put_contents($file, "\t</sitemap>"."\n", FILE_APPEND);
    }
    file_put_contents($file, '</sitemapindex>'."\n", FILE_APPEND);
}

function esc($s) {
    return(htmlspecialchars($s, ENT_QUOTES, 'UTF-8'));
}

function write ($str, $count_url = false) {
    global $params, $sitemap_index, $url_index;
    if ($params['output'] == 'file') {
        $file = 'sitemap'.$params['l'].'_'.$sitemap_index.'.xml';
        file_put_contents($file, $str, FILE_APPEND);
        if ($count_url && ++$url_index == MAX_URLS) {
            file_put_contents($file, '</urlset>'."\n", FILE_APPEND);
            $url_index=0;
            $sitemap_index++;
            $file = 'sitemap'.$params['l'].'_'.$sitemap_index.'.xml';
            file_put_contents($file, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            file_put_contents($file, "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n", FILE_APPEND);
        }
    } else {
        print $str;
    }
}
