<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Sushi\Sushi;

class CronJob extends Model
{
    use Sushi;

    protected $fillable = [
        'schedule',
        'command',
        'user',
    ];

    protected $schema = [
        'schedule' => 'string',
        'command' => 'string',
        'user' => 'string',
    ];

    public static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            $args = escapeshellarg($model->user) .' '. escapeshellarg($model->schedule) . ' ' . escapeshellarg($model->command);
            $addCron = shell_exec('/usr/local/phyre/bin/cron-job-add.sh ' . $args);
            if (empty($addCron)) {
                return false;
            }
        });

        static::deleting(function ($model) {

            $args = escapeshellarg($model->user) .' '. escapeshellarg($model->schedule) . ' ' . escapeshellarg($model->command);
            $args = str_replace(PHP_EOL, '', $args);
            $command = '/usr/local/phyre/bin/cron-job-delete.sh ' . $args;
            $deleteCron = shell_exec($command);
            if (empty($deleteCron)) {
                return false;
            }

        });
    }

//    protected function sushiShouldCache()
//    {
//        return true;
//    }

    public function getRows()
    {
        $user = shell_exec('whoami');
        $cronList = shell_exec('/usr/local/phyre/bin/cron-jobs-list.sh ' . $user);

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
                            'time'=> time(),
                        ];
                    }
                }
            }
        }

        return $rows;
    }
}
