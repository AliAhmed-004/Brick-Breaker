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
    // get the position where tap was detected
    final tapPosition = event.localPosition;

    // check if it was on left half of the screen
    if (tapPosition.x < size.x / 2) {
      paddle.moveLeft(size.x);
    } else {
      paddle.moveRight(size.x);
    }
  }

  // KEYBOARD LISTENER -> for desktop
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      paddle.moveLeft(size.x);
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      paddle.moveRight(size.x);
    }
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
