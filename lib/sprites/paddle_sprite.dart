import 'dart:async';

import 'package:brick_breaker/constants.dart';
import 'package:brick_breaker/sprites/ball.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game.dart';

class PaddleSprite extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  PaddleSprite({required Vector2 position, required Vector2 size})
    : super(
        position: position,
        size: size,
        paint: Paint()..color = paddleColor,
      );

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
  }

  // MOVEMENT METHODS
  // move left
  void moveLeft(double gameWidth) {
    // prevent going off screen
    if (position.x >= 0) position.x -= paddleMovementSpeed;
  }

  void moveRight(double gameWidth) {
    if (position.x + size.x <= gameWidth) position.x += paddleMovementSpeed;
  }

  // COLLISION DETECTION
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ball) {
      print("Ball collided with Paddle");
      game.changeBallDirection();
    }
  }
}
