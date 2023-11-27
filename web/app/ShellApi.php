<?php

namespace App;

class ShellApi
{
    public static function exec($command, $argsArray = [])
    {
        $args = '';
        if (!empty($argsArray)) {
            foreach ($argsArray as $arg) {
                $args .= escapeshellarg($arg) . ' ';
            }
        }

        $fullCommand = escapeshellarg('/usr/local/phyre/bin/' . $command . '.sh') . ' ' . $args;
        $commandAsSudo = '/usr/bin/sudo ' . $fullCommand;

        $execOutput = shell_exec($commandAsSudo);

        return $execOutput;
    }
}
