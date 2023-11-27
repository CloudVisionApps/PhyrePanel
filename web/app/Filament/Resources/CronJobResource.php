<?php

namespace App\Filament\Resources;

use App\Filament\Resources\CronJobResource\Pages;
use App\Filament\Resources\CronJobResource\RelationManagers;
use App\Models\CronJob;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class CronJobResource extends Resource
{
    protected static ?string $model = CronJob::class;

    protected static ?string $navigationIcon = 'heroicon-o-clock';

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
            'index' => Pages\ListCronJobs::route('/'),
            'create' => Pages\CreateCronJob::route('/create'),
            'edit' => Pages\EditCronJob::route('/{record}/edit'),
        ];
    }
}
