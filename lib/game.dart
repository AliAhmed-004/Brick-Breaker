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

    spawnBricks();
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
    if (!isLevelFinished && children.whereType<Brick>().isEmpty) {
      finishLevel();
    }
    if (paddleMoveLeft) {
      paddle.moveLeft(dt);
    }
    if (paddleMoveRight) {
      paddle.moveRight(size.x, dt);
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

    isLevelFinished = true;
    pauseEngine();

    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: const Text("Level Finished!"),
        actions: [
          TextButton(
            onPressed: () {
              // increment level here instead
              Provider.of<LevelProvider>(
                buildContext!,
                listen: false,
              ).incrementLevel();

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

    overlays.add("gameOverOverlay");
  }

  // RESTART GAME
  void restartGame() {
    isGameOver = false;
    isLevelFinished = false;

    ball.position = Vector2(size.x / 2, size.y / 2);
    ball.velocity = Vector2(ballVelocityX, ballVelocityY);

    paddle.position = Vector2(size.x / 2, size.y - 100);

    children.whereType<Brick>().forEach((brick) => brick.removeFromParent());

    spawnBricks(); // spawn with new level

    resumeEngine();
  }

  // Procedural brick grid generator
  List<List<int>> generatePuzzleLevel(int level, int rows, int cols) {
    final rand = Random(level);

    final grid = List.generate(rows, (_) => List.filled(cols, 0));

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols ~/ 2; col++) {
        // baseline chance that decreases per row (more dense at top)
        double chance = 0.8 - (row * 0.1);
        if (chance < 0.2) chance = 0.2;

        bool brick = rand.nextDouble() < chance;

        // clustering effect (avoid lonely bricks)
        if (col > 0 && grid[row][col - 1] == 1 && rand.nextBool()) {
          brick = true;
        }

        grid[row][col] = brick ? 1 : 0;

        // symmetry → mirror across center
        grid[row][cols - col - 1] = grid[row][col];
      }
    }

    return grid;
  }

  // ADD BRICKS
  void spawnBricks() {
    final level = startLevel;

    const rows = 5;
    const cols = 10;
    const padding = 5.0;

    final totalPaddingX = (cols - 1) * padding;
    final brickWidth = (size.x - totalPaddingX) / cols;
    final brickHeight = 30.0;
    final brickSize = Vector2(brickWidth, brickHeight);

    final totalWidth = cols * brickWidth + totalPaddingX;
    final startX = (size.x - totalWidth) / 2;

    // choose generator
    final grid = generatePuzzleLevel(level, rows, cols);

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col] == 1) {
          final x = startX + col * (brickWidth + padding);
          final y = row * (brickHeight + padding);

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
