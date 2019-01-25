<?php

    if(!$okay->managers->access('orders')) {
        exit();
    }

    use PHPMailer\PHPMailer\SMTP;
    
    $host     = $okay->settings->smtp_server = $okay->request->post('server');
    $port     = $okay->settings->smtp_port   = $okay->request->post('port');
    $username = $okay->settings->smtp_user   = $okay->request->post('user');
    $password = $okay->settings->smtp_pass   = $okay->request->post('pass');
    $result   = array(
        'status'  => false,
        'message' => '',
        'trace'   => ''
    );
    if ($port == 465) {
        // Добавляем протокол, если не указали
        $host = (strpos($host, "ssl://") === false) ? "ssl://".$host : $host;
    }
    
    ob_start();
    //Create a new SMTP instance
    $smtp = new SMTP;
    //Enable connection-level debug output
    $smtp->do_debug = SMTP::DEBUG_CONNECTION;
    //Connect to an SMTP server
    if (!$smtp->connect($host, $port)) {
        $result['message'] = 'Connect failed';
    }
    //Say hello
    if (!$smtp->hello(gethostname())) {
        $result['message'] = 'EHLO failed: ' . $smtp->getError()['error'];
    }
    //Get the list of ESMTP services the server offers
    $e = $smtp->getServerExtList();
    //If server can do TLS encryption, use it
    if (is_array($e) && array_key_exists('STARTTLS', $e)) {
        $tlsok = $smtp->startTLS();
        if (!$tlsok) {
            $result['message'] = 'Failed to start encryption: ' . $smtp->getError()['error'];
        }
        //Repeat EHLO after STARTTLS
        if (!$smtp->hello(gethostname())) {
            $result['message'] = 'EHLO (2) failed: ' . $smtp->getError()['error'];
        }
        //Get new capabilities list, which will usually now include AUTH if it didn't before
        $e = $smtp->getServerExtList();
    }
    //If server supports authentication, do it (even if no encryption)
    if (is_array($e) && array_key_exists('AUTH', $e)) {
        if ($smtp->authenticate($username, $password)) {
            $result['message'] = 'Connected ok!';
            $result['status']  = true;
        } else {
            $result['message'] = 'Authentication failed: ' . $smtp->getError()['error'];
        }
    }
    
    //Whatever happened, close the connection.
    $smtp->quit(true);

    $result['trace'] = nl2br(ob_get_contents());
    ob_end_clean();

    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($result);
    