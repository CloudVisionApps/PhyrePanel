<?php

namespace App\Filament\Resources;

use App\Filament\Resources\HostingDatabaseResource\Pages;
use App\Filament\Resources\HostingDatabaseResource\RelationManagers;
use App\Models\HostingDatabase;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class HostingDatabaseResource extends Resource
{
    protected static ?string $model = HostingDatabase::class;

    protected static ?string $navigationIcon = 'heroicon-o-circle-stack';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                //
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                //
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListHostingDatabases::route('/'),
            'create' => Pages\CreateHostingDatabase::route('/create'),
            'edit' => Pages\EditHostingDatabase::route('/{record}/edit'),
        ];
    }
}
