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
        'domain',
        'root'
    ];

    protected $schema = [
        'file' => 'string',
        'domain' => 'string',
        'root' => 'string'
    ];

    public static function boot()
    {
        parent::boot();

        static::creating(function ($model) {

            $createWebsite = ShellApi::callBin('website-create', [
               $model->domain,
               'bobkata'
            ]);

            if (empty($createWebsite)) {
                return false;
            }

        });

        static::deleting(function ($model) {
            $deleteWebsite = ShellApi::callBin('website-delete', [
                $model->domain
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
        $websitesList = ShellApi::callBin('websites-list');

        $rows = [];
        if (!empty($websitesList)) {
            $websitesList = json_decode($websitesList, true);
            if (!empty($websitesList)) {
                foreach ($websitesList as $website) {
                    if (isset($website['file'])) {
                        $rows[] = [
                            'file' => $website['file'],
                            'domain' => $website['server_name'],
                            'root' => $website['root']
                        ];
                    }
                }
            }
        }

        return $rows;
    }
}
