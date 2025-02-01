<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Question;


class Question extends Model {
    use HasFactory;

    protected $fillable = ['exam_id', 'question', 'options', 'answer', 'score'];

    protected $casts = [
        'options' => 'array', 
    ];

    public function exam() {
        return $this->belongsTo(Exam::class);
    }
}
