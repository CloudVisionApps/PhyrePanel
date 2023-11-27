<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Sushi\Sushi;

class Website extends Model
{
    use Sushi;

    protected $fillable = [
        'file',
        'server_name',
        'root'
    ];

    protected $schema = [
        'file' => 'string',
        'server_name' => 'string',
        'root' => 'string'
    ];

    public static function boot()
    {
        parent::boot();

        static::creating(function ($model) {

            $args =  escapeshellarg($model->server_name) . ' ' . escapeshellarg('bobi');
            $args = str_replace(PHP_EOL, '', $args);
            $command = '/usr/local/phyre/bin/website-create.sh ' . $args;
            $createWebsite = shell_exec($command);
            if (empty($createWebsite)) {
                return false;
            }

            dd($createWebsite);

        });

        static::deleting(function ($model) {

            $args =  escapeshellarg($model->server_name);
            $args = str_replace(PHP_EOL, '', $args);
            $command = '/usr/local/phyre/bin/website-delete.sh ' . $args;
            $deleteWebsite = shell_exec($command);
            if (empty($deleteWebsite)) {
                return false;
            }

        });
    }

    protected function sushiShouldCache()
    {
        return true;
    }

    public function getRows()
    {
        $websitesList = shell_exec('/usr/local/phyre/bin/websites-list.sh');
        $rows = [];
        if (!empty($websitesList)) {
            $websitesList = json_decode($websitesList, true);
            if (!empty($websitesList)) {
                foreach ($websitesList as $website) {
                    if (isset($website['file'])) {
                        $rows[] = [
                            'file' => $website['file'],
                            'server_name' => $website['server_name'],
                            'root' => $website['root']
                        ];
                    }
                }
            }
        }

        return $rows;
    }
}
