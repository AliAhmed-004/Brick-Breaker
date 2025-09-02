import 'dart:async';
import 'dart:math';

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
  void moveLeft(double dt) {
    // prevent going off screen
    if (position.x >= 0) position.x -= paddleMovementSpeed * dt;
  }

  void moveRight(double gameWidth, double dt) {
    if (position.x + size.x <= gameWidth) {
      position.x += paddleMovementSpeed * dt;
    }
  }

  // COLLISION DETECTION
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // collision with Ball
    if (other is Ball) {
      // Bounce vertically
      other.velocity.y = -other.velocity.y;

      // How far from paddle center (-1 = left edge, 0 = center, +1 = right edge)
      final relativeHit = (other.center.x - center.x) / (size.x / 2);

      // Max angle away from vertical, e.g. 60°
      const maxBounceAngle = 1.0472; // in radians (~60deg)

      // Convert hit into angle
      final angle = relativeHit * maxBounceAngle;

      // Keep speed constant (magnitude of velocity)
      final speed = other.velocity.length;

      // New velocity based on angle
      other.velocity
        ..x = speed * sin(angle)
        ..y = -speed * cos(angle); // minus because up is negative Y
    }
  }
}
