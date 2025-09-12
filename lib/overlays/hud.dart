import 'package:brick_breaker/providers/level_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hud extends StatelessWidget {
  const Hud({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentLevel = context.watch<LevelProvider>().level;
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Level: $currentLevel",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none, // avoids underlines
            ),
          ),
        ],
      ),
    );
  }
}
