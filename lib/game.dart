import 'dart:async';
import 'dart:math';

import 'package:brick_breaker/constants.dart';
import 'package:brick_breaker/providers/level_provider.dart';
import 'package:brick_breaker/sprites/background.dart';
import 'package:brick_breaker/sprites/ball.dart';
import 'package:brick_breaker/sprites/paddle_sprite.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'sprites/brick/brick.dart';

class BrickBreaker extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, HasCollisionDetection {
  int startLevel;

  bool isGameOver = false;
  bool isLevelFinished = false;

  BrickBreaker(this.startLevel);

  // SPRITES
  late PaddleSprite paddle;
  late Background background;
  late Ball ball;

  // Paddle controls
  bool paddleMoveLeft = false;
  bool paddleMoveRight = false;

  //Level providers
  @override
  FutureOr<void> onLoad() {
    // get current level from provider

    paddle = PaddleSprite(
      position: Vector2(size.x / 2, size.y - 100),
      size: Vector2(paddleWidth, paddleHeight),
    );
    add(paddle);

    ball = Ball(
      position: Vector2(size.x / 2, size.y / 2),
      initialVelocity: Vector2(ballVelocityX, ballVelocityY),
    );
    add(ball);

    spawnBricks(startLevel);
  }

  // PADDLE CONTROLS
  // TAP LISTENER -> for mobile
  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;

    if (tapPosition.x < size.x / 2) {
      paddleMoveLeft = true;
    } else {
      paddleMoveRight = true;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    paddleMoveLeft = false;
    paddleMoveRight = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    paddleMoveLeft = false;
    paddleMoveRight = false;
  }

  // UPDATE -> every second
  @override
  void update(double dt) {
    super.update(dt);

    if (paddleMoveLeft) {
      paddle.moveLeft(dt);
    }
    if (paddleMoveRight) {
      paddle.moveRight(size.x, dt);
    }

    if (children.whereType<Brick>().isEmpty) {
      finishLevel(); // next level
    }
  }

  // KEYBOARD LISTENER -> for desktop
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    paddleMoveLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    paddleMoveRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    return super.onKeyEvent(event, keysPressed);
  }

  // FINISH LEVEL
  void finishLevel() {
    if (isLevelFinished) return;

    pauseEngine();
    isLevelFinished = true;

    // increment provider’s level
    Provider.of<LevelProvider>(buildContext!, listen: false).incrementLevel();

    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: const Text("Level Finished!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartGame();
            },
            child: const Text("Next Level"),
          ),
        ],
      ),
    );
  }

  // GAME OVER
  void gameOver() {
    if (isGameOver) return;

    isLevelFinished = false;

    pauseEngine();

    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text("Game Over"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(buildContext!).pop(); // close dialog
                restartGame();
              },
              child: Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }

  // RESTART GAME
  void restartGame() {
    isGameOver = false;
    isLevelFinished = false;
    resumeEngine();

    ball.position = Vector2(size.x / 2, size.y / 2);
    ball.velocity = Vector2(ballVelocityX, ballVelocityY);

    paddle.position = Vector2(size.x / 2, size.y - 100);

    children.whereType<Brick>().forEach((brick) => brick.removeFromParent());

    final currentLevel = Provider.of<LevelProvider>(
      buildContext!,
      listen: false,
    ).level;
    spawnBricks(currentLevel); // spawn with new level
  }

  // Procedural brick grid generator
  List<List<int>> generateLevelGrid(int level, int rows, int cols) {
    final rand = Random(level); // seed ensures repeatability

    // As levels go up, add more density
    double baseChance = 0.4 + (level * 0.05);
    if (baseChance > 0.9) baseChance = 0.9; // cap at 90%

    return List.generate(rows, (r) {
      return List.generate(cols, (c) {
        return rand.nextDouble() < baseChance ? 1 : 0; // 1 = brick, 0 = empty
      });
    });
  }

  // ADD BRICKS
  void spawnBricks(int level) {
    const rows = 3;
    const cols = 10; // fixed number, same on all devices
    const padding = 5.0;

    // Calculate brick size dynamically
    final totalPaddingX = (cols - 1) * padding;
    final brickWidthDynamic = (size.x - totalPaddingX) / cols;
    final brickHeightDynamic = 30.0; // or scale by size.y if you want

    final brickSize = Vector2(brickWidthDynamic, brickHeightDynamic);

    // Center horizontally
    final totalWidth = cols * brickWidthDynamic + totalPaddingX;
    final startX = (size.x - totalWidth) / 2;

    final grid = generateLevelGrid(level, rows, cols);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col] == 1) {
          final x = startX + col * (brickWidthDynamic + padding);
          final y = row * (brickHeightDynamic + padding);

          final brick = Brick(
            position: Vector2(x, y + 50),
            size: brickSize,
            color:
                Colors.primaries[(level + row + col) % Colors.primaries.length],
          );
          add(brick);
        }
      }
    }
  }

  // Spawn test bricks
  void spawnTestBricks() {
    final testBrick = Brick(
      position: Vector2(0, size.y - 200),
      size: Vector2(60, 40),
      color: Colors.red,
    );

    add(testBrick);
  }
}
