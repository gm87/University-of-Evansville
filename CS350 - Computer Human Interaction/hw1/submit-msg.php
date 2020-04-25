<?php
    $name = htmlspecialchars($_POST['name']);
    $message = nl2br(htmlspecialchars($_POST['message']));
    if ($name == ""){
        echo("Your name is empty");
    }
    if ($message == ""){
        echo("Your message is empty");
    }
    $outfile = fopen("messages/" . date("m-d-y-his"), w);
    
    fwrite($outfile, "$name\n$message");
?>

<html lang="en">
    <head>
        <title>HTML5/PHP Prototype</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style><?php include 'styles.css'; ?></style>
    </head>

    <body>
        <div id="wrapper">
            <h1>CHAT ROOM</h1>
            <h3>close the door when you leave</h3>
            <p style="text-align: center">message received, thank you</p>
            <a style="text-align: center" href="index.php">return home</a>
        </div>
    </body>
</html>