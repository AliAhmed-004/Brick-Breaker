import 'dart:async';

import 'package:brick_breaker/constants.dart';
import 'package:brick_breaker/sprites/paddle_sprite.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrickBreaker extends FlameGame with HasKeyboardHandlerComponents {
  late PaddleSprite paddle;

  @override
  FutureOr<void> onLoad() {
    // LOAD ALL THE SPRITES
    paddle = PaddleSprite(
      position: Vector2(size.x / 2, size.y - 100), //position
      size: Vector2(paddleWidth, paddleHeight), //size
    );

    add(paddle);
  }

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
}
