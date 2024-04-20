import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String gameTitle;
  final String gameDescription;
  final Widget gameScreen;

  const GameCard({
    Key? key,
    required this.gameTitle,
    required this.gameDescription,
    required this.gameScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // subscribeToBroadcast();
        // subscribeToChannelPresence();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => gameScreen));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
                flex: 2,
                child: Icon(Icons.image, size: 100, color: Colors.blue)),
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(gameTitle),
                subtitle: Text(gameDescription),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
