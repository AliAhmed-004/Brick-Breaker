import 'package:brick_breaker/game.dart';
import 'package:brick_breaker/providers/level_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialOverlay extends StatelessWidget {
  final BrickBreaker game;
  const InitialOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final currentLevel = context.read<LevelProvider>().level;

    return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Header
            Text(
              "Brick Breaker",
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),

            // Button to start game
            ElevatedButton.icon(
              onPressed: () {
                game.startGame();
              },
              icon: const Icon(Icons.play_arrow),
              label: Text("Start Level $currentLevel"),
            ),
          ],
        ),
      ),
    );
  }
}
