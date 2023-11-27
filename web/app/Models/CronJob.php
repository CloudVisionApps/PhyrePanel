<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Sushi\Sushi;

class CronJob extends Model
{
    use Sushi;

    public function getRows()
    {

        $user = shell_exec('whoami');
        $cronList = shell_exec('/usr/local/phyre/bin/list-cron-jobs.sh ' . $user);

        $rows = [];
        if (!empty($cronList)) {
            $cronList = json_decode($cronList, true);
            if (!empty($cronList)) {
                foreach ($cronList as $cron) {
                    if (isset($cron['schedule'])) {
                        $rows[] = [
                            'schedule' => $cron['schedule'],
                            'command' => $cron['command'],
                            'user' => $user,
                        ];
                    }
                }
            }
        }

        return $rows;
    }
}
