// ignore_for_file: constant_identifier_names

import 'package:brick_breaker/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum BallDirection { UP, DOWN }

class Ball extends CircleComponent with CollisionCallbacks {
  Ball(Vector2 position, {required this.direction})
    : super(
        radius: ballRadius,
        paint: Paint()..color = ballColor,
        position: position,
      );

  Vector2 velocity = Vector2(0, ballVelocity);
  BallDirection direction = BallDirection.DOWN;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add hitbox
    add(CircleHitbox());
  }

  // UPDATE -> every second
  @override
  void update(double dt) {
    if (direction == BallDirection.DOWN) {
      position += velocity * dt;
    } else {
      // Prevent ball from moving offscreen vertically (up for now)
      if (position.y + radius < 0) {
        // reset position vertically
        // position.y = 0;

        // change direction
        direction = BallDirection.DOWN;
      }
      position -= velocity * dt;
    }
  }
}
