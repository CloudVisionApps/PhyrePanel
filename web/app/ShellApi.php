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

        $fullCommand = escapeshellarg($command) . $args;
        $execOutput = shell_exec($fullCommand);
        $execOutput = str_replace(PHP_EOL, '', $execOutput);

        return $execOutput;
    }

    public static function callBin($command, $argsArray = [])
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
