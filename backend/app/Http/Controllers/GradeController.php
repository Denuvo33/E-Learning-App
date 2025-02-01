<?php
namespace App\Http\Controllers;

use App\Models\Grade;
use Illuminate\Http\Request;

class GradeController extends Controller
{
    public function storeGrade(Request $request) {
        $request->validate([
            'email' => 'required|email',
            'score' => 'required|integer',
            'exam_id' => 'required|integer',
        ]);

        $grade = Grade::create([
            'email' => $request->email,
            'score' => $request->score,
            'exam_id' => $request->exam_id,
        ]);

        return response()->json($grade, 201);
    }

    public function showGrades($email) {
        $grades = Grade::where('email', $email)->get();
        return response()->json($grades);
    }

    public function getAllGrades() {
        $grades = Grade::all();
        return response()->json($grades);
    }


}
