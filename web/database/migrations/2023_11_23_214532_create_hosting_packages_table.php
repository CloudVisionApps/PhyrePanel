<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('hosting_packages', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('disk_space');
            $table->string('bandwidth');
            $table->string('addon_domains');
            $table->string('parked_domains');
            $table->string('sub_domains');
            $table->string('ftp_accounts');
            $table->string('mysql_databases');
            $table->string('email_accounts');
            $table->string('email_lists');
            $table->string('max_quota_per_email');
            $table->string('max_email_per_hour');
            $table->string('max_defer_fail_percentage');
            $table->string('max_email_per_day');
            $table->string('max_recipients_per_message');
            $table->string('max_email_per_minute');
            $table->string('max_attachments_per_message');
            $table->string('max_parked_domains');
            $table->string('max_addon_domains');
            $table->string('max_sub_domains');
            $table->string('max_ftp_accounts');
            $table->string('max_mysql_databases');
            $table->string('max_email_accounts');
            $table->string('max_email_lists');
            $table->string('max_email_quota');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('hosting_packages');
    }
};
