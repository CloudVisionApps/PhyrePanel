<?php

namespace App\Filament\Resources\HostingDatabaseResource\Pages;

use App\Filament\Resources\HostingDatabaseResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditHostingDatabase extends EditRecord
{
    protected static string $resource = HostingDatabaseResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
