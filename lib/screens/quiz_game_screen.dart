import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:techagogics_open_core/services/supabase_service.dart';
import 'package:techagogics_open_core/utilities/media_queries.dart';
import '../provider/game_provider.dart';
import '../widgets/image_tile.dart';
import '../models/image_model.dart';

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
    sendBroadcastMessage('Joined the Quiz Game');
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
        ),
        // Displays the list of users currently drawing on the canvas
        // actions: [
        //   // ...[..._userCursors.values.map((e) => e.id), _myId]
        //   //     .map(
        //   //       (id) => Align(
        //   //         widthFactor: 0.8,
        //   //         child: CircleAvatar(
        //   //           backgroundColor: RandomColor.getRandomFromId(id),
        //   //           child: Text(id.substring(0, 2)),
        //   //         ),
        //   //       ),
        //   //     )
        //   //     .toList(),
        //   const SizedBox(width: 20),
        // ]),
        // appBar: AppBar(
        //     title: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       // SvgPicture.asset('images/logo/techagogics_logo-bildmarke.svg'),
        //       const Text('Guess the Fake',
        //           style: TextStyle(fontWeight: FontWeight.bold)),
        //       Text('Score: ${gameProvider.score}'),
        //     ],
        //   ),
        // )),
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
