import 'package:brick_breaker/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game.dart';
import '../providers/level_provider.dart';

class LevelCompleteOverlay extends StatelessWidget {
  final BrickBreaker game;
  const LevelCompleteOverlay({super.key, required this.game});

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
                Provider.of<LevelProvider>(
                  context,
                  listen: false,
                ).incrementLevel();

                game.overlays.remove(levelFinishOverlay);
                game.overlays.remove(initialOverlay);
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
