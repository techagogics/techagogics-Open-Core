import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:techagogics_open_core/utilities/media_queries.dart';
import '../provider/game_provider.dart';
import '../widgets/image_tile.dart';
import '../models/image_model.dart';

class GameScreen extends StatelessWidget {
  final List<ImageModel> images;

  const GameScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
        appBar: AppBar(
            title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              SvgPicture.asset('images/logo/techagogics_logo-bildmarke.svg'),
              Text(
                  'Guess the Fake - Score: ${Provider.of<GameProvider>(context).score}')
            ],
          ),
        )),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: gameProvider.gameStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error.toString()}'));
            }
            // if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //   return const Center(child: Text('No images found'));
            // }

            // List<ImageModel> images =
            //     snapshot.data!.map((e) => ImageModel.fromJson(e)).toList();

            return GridView.builder(
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
            );
          },
        ));
  }
}
