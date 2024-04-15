import '../models/image_model.dart';
import 'supabase_manager.dart';

Future<List<Map<String, dynamic>>> fetchImages() async {
  try {
    final response = await SupabaseManager.client.from('images').select();

    if (response.isEmpty) {
      throw Exception('No images found');
    }

    return List<Map<String, dynamic>>.from(response);
  } catch (error) {
    throw Exception('Error fetching images: $error');
  }
}

Future<List<ImageModel>> fetchImagesAsModels() async {
  try {
    final List<Map<String, dynamic>> imageData = await fetchImages();
    // Konvertieren Sie die Rohdaten in ImageModel-Objekte
    return imageData.map((imageMap) => ImageModel.fromJson(imageMap)).toList();
  } catch (e) {
    throw Exception('Failed to load images: $e');
  }
}
