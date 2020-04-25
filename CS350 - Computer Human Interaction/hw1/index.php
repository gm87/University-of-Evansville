<!DOCTYPE html>

<!--
    File: index.php
    Class: CS-350                       Instructor: Dr. Deborah Hwang
    Assignment: HTML5/PHP Prototype     Date assigned: Feb 4, 2020
    Programmer: Graham Matthews         Date completed:
-->

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
            <form action="submit-msg.php" method="post">
                <div>
                <table>
                    <tr>
                        <th>Name</th>
                    </tr>
                    <tr>
                        <td><input type="text" name="name" maxlength="64" placeholder="Enter your name..." required /></td>
                    </tr>
                    <tr>
                        <th>Message</th>
                    </tr>
                    <tr>
                        <td><input type="textarea" rows="4" cols="50" name="message" maxlength="255" placeholder="Enter your message..." required /></td>
                    </tr>
                </table>
                <input id="submitBtn" type="submit" />
                <hr />
                <?php
                    $files = scandir('messages', 1);
                    foreach ($files as $file) {
                        if($file == '.' || $file == '..') continue;
                        $arr = explode("\n", file_get_contents('messages/' . $file));
                        $dateStr = $file;
                        $date = substr($dateStr, 0, 8);
                        echo "<p class=\"message\">";
                        echo 'on ' . $date . ' ' . $arr[0] . ' said:' . '<br><br>';
                        echo $arr[1] . '<br>';
                        echo '<hr>';
                        echo "</p>";
                    }
                ?>
                </div>
            </form>
        </div>
    </body>
</html>