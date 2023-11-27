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

        exec('/usr/local/phyre/bin/crontab-list.sh', $output);

        dd($output);

        return [
            ['id' => 1, 'label' => 'admin'],
            ['id' => 2, 'label' => 'manager'],
            ['id' => 3, 'label' => 'user'],
        ];
    }
}
