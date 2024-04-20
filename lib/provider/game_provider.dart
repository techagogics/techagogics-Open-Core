import 'dart:math';
import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';
import '../models/image_model.dart';

class GameProvider with ChangeNotifier {
  // Game_01_50/50-Game
  List<ImageModel> _images = [];
  Set<int> _lastImageIds = {};
  List<ImageModel> get images => _images;
  bool _isCorrectChoice = false;
  bool get isCorrectChoice => _isCorrectChoice;
  ImageModel? _selectedImage;
  int _score = 0;
  int get score => _score;

  GameProvider();

  void selectImage(ImageModel image) {
    _selectedImage = image;

    // Logik, um zu bestimmen, ob die Auswahl richtig oder falsch ist
    _isCorrectChoice = image.isFake;
    if (_isCorrectChoice) {
      _score++;
    }
    notifyListeners();

    // Verzögere das Zurücksetzen der Auswahl und das Laden neuer Bilder
    Future.delayed(const Duration(seconds: 2), () {
      loadNewImages();
    });
  }

  bool isSelectedImage(ImageModel image) {
    return _selectedImage == image;
  }

  void resetSelectionAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      _isCorrectChoice = false;
      loadNewImages();
    });
  }

  void loadNewImages() async {
    final newImages = await fetchImagesAsModels();
    final randomImages = getRandomImages(newImages);

    Set<int> newImageIds = randomImages.map((e) => e.id).toSet();

    if (_lastImageIds.isNotEmpty &&
        _lastImageIds.intersection(newImageIds).isNotEmpty) {
      loadNewImages();
      return;
    }

    _lastImageIds = newImageIds;
    _images = randomImages;

    // Verzögern Sie den Aufruf von notifyListeners
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  List<ImageModel> getRandomImages(List<ImageModel> images) {
    final random = Random();
    final fakeImages = images.where((img) => img.isFake).toList();
    final realImages = images.where((img) => !img.isFake).toList();
    final ImageModel fakeImage = fakeImages[random.nextInt(fakeImages.length)];
    final ImageModel realImage = realImages[random.nextInt(realImages.length)];
    return (random.nextBool())
        ? [fakeImage, realImage]
        : [realImage, fakeImage];
  }
}
