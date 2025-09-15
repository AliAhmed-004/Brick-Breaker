import 'package:brick_breaker/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game.dart';
import '../providers/level_provider.dart';

class LevelFinishOverlay extends StatelessWidget {
  final BrickBreaker game;
  const LevelFinishOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Level Finished!",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<LevelProvider>(
                  context,
                  listen: false,
                );
                provider.incrementLevel();

                game.startLevel = provider.level; // update level in *same* game
                game.overlays.remove(levelFinishOverlay);
                game.restartGame();
              },
              child: const Text("Next Level"),
            ),
          ],
        ),
      ),
    );
  }
}
