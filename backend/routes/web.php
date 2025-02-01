<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MaterialController;
use App\Http\Controllers\ExamController;
use App\Http\Controllers\QuestionController;
use App\Http\Controllers\GradeController;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/grades/{email}', [GradeController::class, 'showGrades']);
    Route::get('/materials/download/{id}', [MaterialController::class, 'download']);



    // Routes untuk siswa
    Route::get('/materials', [MaterialController::class, 'index']);
    Route::get('/exams/student', [ExamController::class, 'index']);
    Route::post('/grades', [GradeController::class, 'storeGrade']);
    Route::get('/exams/{id}', [ExamController::class, 'show']);

    // Routes untuk admin
    Route::middleware('role:admin')->group(function () {
        Route::apiResource('materials', MaterialController::class)->except(['index']);
        Route::apiResource('exams', ExamController::class);
        Route::get('/grades', [GradeController::class, 'getAllGrades']);

        Route::prefix('exams/{exam}/questions')->group(function () {
            Route::apiResource('/', QuestionController::class);
            Route::put('/{question}', [QuestionController::class, 'update']);
        });
    });
});
