// lib/screens/main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:techagogics_open_core/provider/quiz_game_provider.dart';
import 'package:techagogics_open_core/screens/canvas/canvas_screen.dart';
import '../widgets/game_card.dart';
import 'quiz_game_screen.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<GameCard> gameCards = [
    GameCard(
        gameTitle: 'Fake/Real-Game',
        gameDescription: 'Become a Deepfake Detective!',
        gameScreen: Consumer<QuizGameProvider>(
          builder: (context, gameProvider, child) {
            if (gameProvider.images.isEmpty) {
              // Beim ersten Laden oder wenn keine Bilder vorhanden sind
              gameProvider.loadNewImages(); // Lädt neue Bilder
              return const Center(child: CircularProgressIndicator());
            }
            return QuizGameScreen(images: gameProvider.images);
          },
        )),
    const GameCard(
      gameTitle: 'Canvas-Game',
      gameDescription: 'Draw together!',
      gameScreen: CanvasScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            SvgPicture.asset('images/logo/techagogics_logo-bildmarke.svg'),
            const Text('Hauptmenü')
          ],
        ),
      )),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio:
              MediaQuery.of(context).size.width > 600 ? (3 / 2) : (1 / 2),
        ),
        itemCount: gameCards.length, // Anzahl der Spiele
        itemBuilder: (context, index) => gameCards[index],
      ),
    );
  }
}
