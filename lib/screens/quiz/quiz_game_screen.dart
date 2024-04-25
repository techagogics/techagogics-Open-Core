import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techagogics_open_core/screens/quiz/quiz_object.dart';
import 'package:techagogics_open_core/services/supabase/supabase_constants.dart';
import 'package:techagogics_open_core/services/supabase/supabase_manager.dart';
// import 'package:techagogics_open_core/services/supabase/supabase_service.dart';
import 'package:techagogics_open_core/utilities/media_queries.dart';
import 'package:uuid/uuid.dart';
import '../../provider/game_provider.dart';
import '../../widgets/image_tile.dart';
import '../../models/image_model.dart';

class QuizGameScreen extends StatefulWidget {
  final List<ImageModel> images;

  const QuizGameScreen({super.key, required this.images});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  /// Holds the cursor information of other users
  final Map<String, UserScore> _userScores = {};

  /// Holds the list of objects drawn on the canvas
  final Map<String, GameObject> _gameObjects = {};

  /// Supabase realtime channel to communicate to other clients
  late final RealtimeChannel _quizChannel;

  /// Randomly generated UUID for the user
  late final String _myId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Generate a random UUID for the user.
    // We could replace this with Supabase auth user ID.
    _myId = const Uuid().v4();

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

              if (payload['game'] != null) {
                final game = GameObject.fromJson(payload['game']);
                _gameObjects[game.id] = game;
                // _loadGame(game);
              }

              if (mounted) {
                setState(() {});
              }
            })
        .onPresenceJoin((payload) {
      final joinedId = payload.newPresences.first.payload['id'] as String;
      if (_myId == joinedId) return;
      if (!_userScores.containsKey(joinedId)) {
        if (_userScores[joinedId] != null) {
          if (mounted) {
            setState(() {
              // TODO: Not sure if score should be 0 here.
              _userScores[joinedId] = UserScore(id: joinedId, score: 0);
            });
          }
        }
      }
    }).onPresenceLeave((payload) {
      final leftId = payload.leftPresences.first.payload['id'];
      if (mounted) {
        setState(() {
          _userScores.remove(leftId);
        });
      }
    }).subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        _quizChannel.track({
          'id': _myId,
        });
      }
    });
  }

  /// Syncs the user's cursor position and the currently drawing object with
  /// other users.
  Future<void> _syncScore([int? userScore]) {
    final myScore = UserScore(
      score: userScore,
      id: _myId,
    );
    return _quizChannel.sendBroadcastMessage(
      event: BroadcastEvent.quiz.name,
      payload: {
        'score': myScore.toJson(),
        // if (_selectedObjectId != null)
        //   'object': _canvasObjects[_selectedObjectId]?.toJson(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    if (mounted) {
      setState(() {
        _syncScore(gameProvider.score);
      });
    }

    return Scaffold(
        appBar: AppBar(
            leadingWidth: 360,
            backgroundColor: Colors.grey[900],
            leading: Row(
              children: [
                // const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 0)),
                        shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder(),
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'images/logo/techagogics_logo-bildmarke.svg',
                    ),
                  ),
                ),
                const Text('Guess the Fake',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 20),
                Text('Score: ${gameProvider.score}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
            // Displays the list of users currently drawing on the canvas
            actions: [
              ...[..._userScores.values.map((e) => e.id), _myId]
                  .map(
                    (id) => Row(
                      children: [
                        Align(
                          widthFactor: 0.8,
                          child: CircleAvatar(
                            backgroundColor: RandomColor.getRandomFromId(id),
                            child: Text(_userScores[id]?.score.toString() ??
                                '${gameProvider.score}'),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
              const SizedBox(width: 20),
            ]),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQueryUtil.getCrossAxisCount(context),
          ),
          itemCount: gameProvider.images.length,
          itemBuilder: (BuildContext context, int index) {
            final image = gameProvider.images[index];
            return ImageTile(
              image: image,
              onTap: () => gameProvider.selectImage(image),
              isSelected: gameProvider.isSelectedImage(image),
              isCorrectChoice: gameProvider.isCorrectChoice,
            );
          },
        ));
  }
}
