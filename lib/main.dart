import 'package:brick_breaker/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/level_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LevelProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<LevelProvider>(
        builder: (context, levelProvider, _) {
          return GameWidget(game: BrickBreaker(levelProvider.level));
        },
      ),
    );
  }
}
