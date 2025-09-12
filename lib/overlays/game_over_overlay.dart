import 'package:brick_breaker/game.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class GameOverOverlay extends StatelessWidget {
  final BrickBreaker game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Game Over",
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),

            ElevatedButton.icon(
              onPressed: () {
                game.overlays.remove(gameOverOverlay);
                game.restartGame();
              },
              icon: Icon(Icons.restart_alt_rounded),
              label: Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}
