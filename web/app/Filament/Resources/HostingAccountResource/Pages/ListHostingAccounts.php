<?php

namespace App\Filament\Resources\HostingAccountResource\Pages;

use App\Filament\Resources\HostingAccountResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListHostingAccounts extends ListRecords
{
    protected static string $resource = HostingAccountResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
