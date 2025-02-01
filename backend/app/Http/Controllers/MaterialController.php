<?php
namespace App\Http\Controllers;

use App\Models\Material;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Response;

class MaterialController extends Controller
{
    
    public function index()
    {
        return Material::all();
    }


    public function store(Request $request)
    {
        $request->validate([
            'judul' => 'required|string',
            'deskripsi' => 'required|string',
            'file' => 'nullable|file|mimes:pdf,doc,docx,pptx|max:2048',
        ]);

        $fileUrl = null;
        if ($request->hasFile('file')) {
            $file = $request->file('file');
            $fileName = time() . '_' . $file->getClientOriginalName();
            $filePath = $file->storeAs('materials', $fileName, 'public'); 
            $fileUrl = Storage::url($filePath); 
        }

        $material = Material::create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'file_url' => $fileUrl,
        ]);

        return response()->json($material, 201);
    }


    public function show(Material $material)
    {
        return $material;
    }

    public function update(Request $request, Material $material)
    {
        \Log::info('Update Material Request:', $request->all());
        
    if (!$material) {
        return response()->json(['error' => 'Material not found'], 404);
    }
        $request->validate([
            'judul' => 'required|string',
            'deskripsi' => 'required|string',
            'file' => 'nullable|file|mimes:pdf,doc,docx,pptx|max:2048', // File upload (opsional)
        ]);

   
        if ($request->hasFile('file')) {
            if ($material->file_url) {
                $oldFilePath = str_replace('/storage', 'public', $material->file_url);
                Storage::delete($oldFilePath);
            }

            $file = $request->file('file');
            $fileName = time() . '_' . $file->getClientOriginalName();
            $filePath = $file->storeAs('materials', $fileName, 'public');
            $fileUrl = Storage::url($filePath);
        } else {
            $fileUrl = $material->file_url;
        }

        $material->update([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'file_url' => $fileUrl,
        ]);

        return response()->json($material, 200);
    }


    public function destroy(Material $material)
    {
        if ($material->file_url) {
            $filePath = str_replace('/storage', 'public', $material->file_url);
            Storage::delete($filePath);
        }

        $material->delete();

        return response()->json(null, 204);
    }



    public function download($id)
    {
        $material = Material::findOrFail($id);

        if (!$material->file_url) {
            return response()->json(['error' => 'File not found'], 404);
        }
        $filePath = storage_path('app/public/' . str_replace('storage/', '', $material->file_url));

        if (file_exists($filePath)) {
            $headers = [
                'Content-Type' => mime_content_type($filePath),
                'Content-Disposition' => 'attachment; filename="' . basename($filePath) . '"',
            ];

            return Response::download($filePath, basename($filePath), $headers);
        }

        return response()->json(['error' => 'File not found on server'], 404);

        }
}