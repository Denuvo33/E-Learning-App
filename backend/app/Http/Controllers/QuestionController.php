<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Question;
use App\Models\Exam;

class QuestionController extends Controller {
    public function index($examId) {
        $exam = Exam::findOrFail($examId);
        return response()->json($exam->questions);
    }

    public function store(Request $request, $examId) {
        $request->validate([
            'question' => 'required|string',
            'options' => 'required|array|min:2',
            'answer' => 'required|string',
            'score' => 'required|integer',
        ]);

        $question = Question::create([
            'exam_id' => $examId,
            'question' => $request->question,
            'options' => $request->options,
            'answer' => $request->answer,
            'score' => $request->score,
        ]);

        return response()->json($question, 201);
    }

    public function show($examId, $questionId) {
        $question = Question::where('exam_id', $examId)->findOrFail($questionId);
        return response()->json($question);
    }

    public function update(Request $request, $examId, $questionId) {
        $question = Question::where('exam_id', $examId)->findOrFail($questionId);

        $request->validate([
            'question' => 'sometimes|string',
            'options' => 'sometimes|array|min:2',
            'answer' => 'sometimes|string',
            'score' => 'sometimes|integer',
        ]);

        $question->update($request->all());
        return response()->json($question);
    }

    public function destroy($examId, $questionId) {
        $question = Question::where('exam_id', $examId)->findOrFail($questionId);
        $question->delete();

        return response()->json(['message' => 'Question deleted successfully']);
    }
}
