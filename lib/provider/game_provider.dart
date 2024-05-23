import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../screens/quiz/quiz_object.dart';
import '../services/supabase/supabase_constants.dart';
import '../services/supabase/supabase_manager.dart';
import '../services/supabase/supabase_service.dart';
import '../models/image_model.dart';

class GameProvider with ChangeNotifier {
  // Quiz Game
  List<ImageModel> _allImages = [];
  List<ImageModel> _images = [];
  Set<int> _lastImageIds = {};
  List<ImageModel> get images => _images;
  bool _isCorrectChoice = false;
  bool get isCorrectChoice => _isCorrectChoice;
  ImageModel? _selectedImage;
  int _score = 0;
  int get score => _score;
  bool _isEvaluating = false;
  bool get isEvaluating => _isEvaluating;
  bool _quizInitialized = false;
  bool get quizInitialized => _quizInitialized;

  /// Holds the cursor information of other users
  final Map<String, UserScore> _userScores = {};
  Map<String, UserScore> get userScores => _userScores;

/*   /// Holds the list of game objects
  final Map<String, GameObject> _gameObjects = {}; */

  /// Supabase realtime channel to communicate to other clients
  late final RealtimeChannel _quizChannel;
  RealtimeChannel get quizChannel => _quizChannel;

  /// Randomly generated UUID for the user
  late final String _myId = const Uuid().v4();
  String get myId => _myId;

  GameProvider() {}

  Future<void> initializeQuiz() async {
    // Start listening to broadcast messages to display other users' scores.
    _quizChannel = SupabaseManager.client
      .channel(Channel.quiz.name)
      .onBroadcast(
        event: BroadcastEvent.quiz.name,
        callback: (payload) {
          if (payload['score'] != null) {
            final score = UserScore.fromJson(payload['score']);
            _userScores[score.id] = score;
          }

          /* if (payload['game'] != null) {
            final game = GameObject.fromJson(payload['game']);
            _gameObjects[game.id] = game;
            // _loadGame(game);
          } */

          notifyListeners();
        },
      )
      .onPresenceJoin((payload) {
        final joinedId = payload.newPresences.first.payload['id'] as String;
        _addUserToUsersList(joinedId);
        sendScore(_score);
      })
      .onPresenceLeave((payload) {
        final leftId = payload.leftPresences.first.payload['id'];
        _userScores.remove(leftId);
        notifyListeners();
      })
      .subscribe((status, error) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          _quizChannel.track({
            'id': myId,
          });
          notifyListeners();
        }
      });

      // Needs to send score at beginning to register presence
      sendScore(_score);
      _quizInitialized = true;
  }

  void _addUserToUsersList(String newId) {
    if (myId == newId) return;
    if (!_userScores.containsKey(newId)) {
      if (_userScores[newId] != null) {
        _userScores[newId] = UserScore(id: newId, score: 0);
        notifyListeners();
      }
    }
  }

  Future<void> sendScore([int? userScore]) {
    final myScore = UserScore(
      score: userScore,
      id: _myId,
    );
    return _quizChannel.sendBroadcastMessage(
      event: BroadcastEvent.quiz.name,
      payload: {
        'score': myScore.toJson(),
      },
    );
  }

  void selectImage(ImageModel image) {
    _selectedImage = image;
    _isEvaluating = true;

    // Check if correct or wrong
    _isCorrectChoice = image.isFake;
    if (_isCorrectChoice) {
      _score++;
      sendScore(_score);
    }
    notifyListeners();

    // Delay resetting the selection and loading new images
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
  
  void getAllImages() async {
    _allImages = await fetchImagesAsModels();
    loadNewImages();
  }

  void loadNewImages() {
    final randomImages = getRandomImages(_allImages);

    // Prevent getting same pictures
    Set<int> newImageIds = randomImages.map((e) => e.id).toSet();
    if (_lastImageIds.isNotEmpty &&
        _lastImageIds.intersection(newImageIds).isNotEmpty) {
      loadNewImages();
      return;
    }
    _lastImageIds = newImageIds;

    _images = randomImages;
    _isEvaluating = false;

    notifyListeners();
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
