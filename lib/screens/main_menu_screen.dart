// lib/screens/main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:techagogics_open_core/provider/game_provider.dart';
import '../widgets/game_card.dart';
import '../screens/game_screen.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            SvgPicture.asset('images/logo/techagogics_logo-bildmarke.svg'),
            Text('Hauptmenü')
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
        itemCount: 4, // Anzahl der Spiele
        itemBuilder: (context, index) => GameCard(
          gameTitle: 'Fake/Real-Spiel',
          gameDescription: 'Finde das gefälschte Bild!',
          gameScreen: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (gameProvider.images.isEmpty) {
                // Beim ersten Laden oder wenn keine Bilder vorhanden sind
                gameProvider.loadNewImages(); // Lädt neue Bilder
                return const Center(child: CircularProgressIndicator());
              }
              return GameScreen(images: gameProvider.images);
            },
          ),
        ),
      ),
    );
  }
}
