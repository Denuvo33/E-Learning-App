<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Exam;
use App\Models\Question;

class ExamController extends Controller {
    public function index() {
        return response()->json(Exam::with('questions')->get());
    }

  
public function store(Request $request) {

    $request->validate([
        'title' => 'required|string',
        'description' => 'required|string',
        'start_date' => 'required|date',
        'duration' => 'required|integer',
        'questions' => 'required|array|min:1', 
        'questions.*.question' => 'required|string', 
        'questions.*.options' => 'required|array|min:2', 
        'questions.*.answer' => 'required|string', 
        'questions.*.score' => 'required|integer', 
    ]);

 
    $exam = Exam::create($request->all());

  
    foreach ($request->questions as $questionData) {
        $exam->questions()->create($questionData); 
    }

    return response()->json($exam, 201);
}


    public function show($id) {
        $exam = Exam::with('questions')->findOrFail($id);
        return response()->json($exam);
    }

    public function update(Request $request, $id)
{
   
    $exam = Exam::find($id);

    
    if (!$exam) {
        return response()->json(['message' => 'Exam not found'], 404);
    }

    
    $request->validate([
        'title' => 'sometimes|string',
        'description' => 'sometimes|string',
        'start_date' => 'sometimes|date',
        'duration' => 'sometimes|integer',
        'questions' => 'sometimes|array',
        'questions.*.id' => 'sometimes|integer', 
        'questions.*.question' => 'sometimes|string',
        'questions.*.options' => 'sometimes|array|min:2',
        'questions.*.answer' => 'sometimes|string',
        'questions.*.score' => 'sometimes|integer',
        'questions.*._delete' => 'sometimes|boolean', 
    ]);

 
    $exam->update($request->only(['title', 'description', 'start_date', 'duration']));

 
    if ($request->has('questions')) {
        foreach ($request->questions as $questionData) {
            if (isset($questionData['id'])) {
                $question = Question::where('exam_id', $exam->id)
                    ->find($questionData['id']);

                if ($question) {
                    if (isset($questionData['_delete']) && $questionData['_delete'] === true) {
                        $question->delete();
                    } else {
                        $question->update($questionData);
                    }
                } else {
                    return response()->json(['message' => 'Question not found or does not belong to this exam'], 404);
                }
            } else {
                $exam->questions()->create($questionData);
            }
        }
    }


    $exam->load('questions');

    return response()->json([
        'message' => 'Exam updated successfully',
        'exam' => $exam,
    ]);
}
    

    public function destroy($id) {
        $exam = Exam::find($id);
    
        if (!$exam) {
            return response()->json(['message' => 'Exam not found'], 404);
        }
    
        $exam->delete();
    
        return response()->json(['message' => 'Exam deleted successfully']);
    }
}
