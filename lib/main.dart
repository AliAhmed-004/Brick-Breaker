import 'package:brick_breaker/game.dart';
import 'package:brick_breaker/overlays/hud.dart';
import 'package:brick_breaker/overlays/initial_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'overlays/game_over_overlay.dart';
import 'overlays/level_finish_overlay.dart';
import 'providers/level_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LevelProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BrickBreaker _game;

  @override
  void initState() {
    super.initState();
    final initialLevel = Provider.of<LevelProvider>(
      context,
      listen: false,
    ).level;
    _game = BrickBreaker(initialLevel)..pauseEngine();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: GameWidget(
          game: _game,
          overlayBuilderMap: {
            initialOverlay: (context, game) =>
                InitialOverlay(game: game as BrickBreaker),
            gameOverOverlay: (context, game) =>
                GameOverOverlay(game: game as BrickBreaker),
            hudOverlay: (context, game) => Hud(),
            levelFinishOverlay: (context, game) =>
                LevelFinishOverlay(game: game as BrickBreaker),
          },
          initialActiveOverlays: [initialOverlay],
        ),
      ),
    );
  }
}
