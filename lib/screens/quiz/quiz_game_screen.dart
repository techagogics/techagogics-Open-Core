import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
// import 'package:techagogics_open_core/services/supabase/supabase_service.dart';
import 'package:techagogics_open_core/utilities/media_queries.dart';
import '../../provider/game_provider.dart';
import '../../widgets/image_tile.dart';
import '../../models/image_model.dart';
import '../../widgets/game_avatar.dart';
import '../../utilities/realtime.dart';

class QuizGameScreen extends StatefulWidget {
  final List<ImageModel> images;

  const QuizGameScreen({super.key, required this.images});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      if (!gameProvider.quizInitialized) gameProvider.initializeQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

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
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 0)),
                    shape: WidgetStateProperty.all<CircleBorder>(
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
            ...[...gameProvider.userScores.values.map((e) => e.id), gameProvider.myId]
              .map(
                (id) => Row(
                  children: [
                    Align(
                      widthFactor: 0.8,
                      child: GameAvatar(
                            backgroundColor: RandomColor.getRandomFromId(id),
                            score: gameProvider.userScores[id]?.score.toString() ??
                              '${gameProvider.score}',
                          )
                ),],
                ),
              )
              .toList(),
            const SizedBox(width: 20),
          ]),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: gameProvider.images.length,
          itemBuilder: (BuildContext context, int index) {
            final image = gameProvider.images[index];
            return ImageTile(
              image: image,
              onTap: gameProvider.isEvaluating ? null : () => gameProvider.selectImage(image),
              isSelected: gameProvider.isSelectedImage(image),
              isCorrectChoice: gameProvider.isCorrectChoice,
            );
          },
        ));
  }
}
