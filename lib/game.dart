import 'dart:async';

import 'package:brick_breaker/constants.dart';
import 'package:brick_breaker/sprites/background.dart';
import 'package:brick_breaker/sprites/ball.dart';
import 'package:brick_breaker/sprites/paddle_sprite.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sprites/brick/brick.dart';

class BrickBreaker extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, HasCollisionDetection {
  bool isGameOver = false;

  BrickBreaker();

  // SPRITES
  late PaddleSprite paddle;
  late Background background;
  late Ball ball;

  // Paddle controls
  bool paddleMoveLeft = false;
  bool paddleMoveRight = false;

  @override
  FutureOr<void> onLoad() {
    // LOAD ALL THE SPRITES
    // background sprite
    // background = Background();
    // add(background);

    // paddle sprite
    paddle = PaddleSprite(
      position: Vector2(size.x / 2, size.y - 100), //position
      size: Vector2(paddleWidth, paddleHeight), //size
    );
    add(paddle);

    // ball sprite
    ball = Ball(
      position: Vector2(size.x / 2, size.y / 2),
      // tweak to taste; nonzero X gives immediate diagonal motion
      initialVelocity: Vector2(ballVelocityX, ballVelocityY),
    );
    add(ball);

    // brick sprites
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
    showDialog(
      context: buildContext!,
      builder: (buildContext) => AlertDialog(
        title: Text("Level Finished!"),
        actions: [
          TextButton(onPressed: restartGame, child: Text("Play Again")),
        ],
      ),
    );
  }

  // GAME OVER
  void gameOver() {
    if (isGameOver) return;

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
    resumeEngine();

    // reset ball
    ball.position = Vector2(size.x / 2, size.y / 2);
    ball.velocity = Vector2(ballVelocityX, ballVelocityY);

    // reset paddle
    paddle.position = Vector2(size.x / 2, size.y - 100);

    // re-add bricks
    children.whereType<Brick>().forEach((brick) => brick.removeFromParent());
    spawnBricks();
  }

  // ADD BRICKS
  void spawnBricks() {
    final brickSize = Vector2(brickWidth, brickHeight);
    const padding = 5.0;
    const rows = 3;

    final cols = ((size.x + padding) ~/ (brickSize.x + padding));
    final totalWidth = cols * (brickSize.x + padding) - padding;
    final startX = (size.x - totalWidth) / 2; // center all bricks

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = startX + col * (brickSize.x + padding);
        final y = row * (brickSize.y + padding);

        final brick = Brick(
          position: Vector2(x, y + 50), // push down from top a bit
          size: brickSize,
          color: Colors.blueAccent,
        );

        add(brick);
      }
    }
  }
}
