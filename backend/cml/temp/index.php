<?php
	session_start();
	require_once('../../../api/Okay.php');
	$okay = new Okay();
	$manager = $okay->managers->get_manager();
	if ($manager) {
		$file = $okay->request->get('file', 'string');
		$file = preg_replace("/[^A-Za-z0-9_]+/", "", $file);
		if ($file) {
			header("Content-Type: text/xml");
			require_once($file.'.xml');
		}
	}