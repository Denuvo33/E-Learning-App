<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::table('materials', function (Blueprint $table) {
            // Ubah kolom `file_url` agar bisa nullable
            $table->string('file_url')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::table('materials', function (Blueprint $table) {
            // Kembalikan kolom `file_url` ke NOT NULL
            $table->string('file_url')->nullable(false)->change();
        });
    }
};
