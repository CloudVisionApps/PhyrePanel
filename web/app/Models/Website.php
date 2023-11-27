<?php

namespace App\Models;

use App\ShellApi;
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

            $createWebsite = ShellApi::exec('website-create', [
               $model->server_name,
               'bobkata'
            ]);

            if (empty($createWebsite)) {
                return false;
            }

        });

        static::deleting(function ($model) {
            $deleteWebsite = ShellApi::exec('website-delete', [
                $model->server_name
            ]);
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
        $websitesList = ShellApi::exec('websites-list');

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
