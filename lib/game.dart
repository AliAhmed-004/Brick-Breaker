import 'dart:async';

import 'package:brick_breaker/constants.dart';
import 'package:brick_breaker/sprites/background.dart';
import 'package:brick_breaker/sprites/ball.dart';
import 'package:brick_breaker/sprites/paddle_sprite.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrickBreaker extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, HasCollisionDetection {
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
    ball = Ball(Vector2(size.x / 2, 50), direction: BallDirection.DOWN);
    add(ball);
  }

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

  @override
  @override
  void update(double dt) {
    super.update(dt);

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

  // CHANGE BALL DIRECTION
  void changeBallDirection() {
    if (ball.direction == BallDirection.DOWN) {
      ball.direction = BallDirection.UP;
    } else {
      ball.direction = BallDirection.DOWN;
    }
  }
}
