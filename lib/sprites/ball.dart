import 'package:brick_breaker/sprites/brick/brick.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../game.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({required Vector2 position, Vector2? initialVelocity})
    : initialVelocity =
          initialVelocity ?? Vector2(ballVelocityX, ballVelocityY),
      super(
        position: position,
        radius: ballRadius,
        paint: Paint()..color = ballColor,
      );

  final Vector2 initialVelocity;
  late Vector2 velocity;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add hitbox
    add(CircleHitbox());
    velocity = initialVelocity; // signed vector (x = left/right, y = up/down)
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 1) move
    position += velocity * dt;

    // 2) side walls bounce (flip X)
    if (position.x - radius <= 0 && velocity.x < 0) {
      position.x = radius;
      velocity.x = -velocity.x;
    }
    if (position.x + radius >= game.size.x && velocity.x > 0) {
      position.x = game.size.x - radius;
      velocity.x = -velocity.x;
    }

    // 3) top wall bounce (flip Y).
    if (position.y - radius <= 0 && velocity.y < 0) {
      position.y = radius;
      velocity.y = -velocity.y;
    }

    // 4) floor (game over)
    if (position.y - radius > game.size.y) {
      game.gameOver();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Brick) {
      // Get ball and brick centers
      final ballCenter = center;
      final brickCenter = other.center;

      // Compare the difference
      final dx = (ballCenter.x - brickCenter.x).abs();
      final dy = (ballCenter.y - brickCenter.y).abs();

      if (dx > dy) {
        // Hit was more on the left/right → flip X
        velocity.x = -velocity.x;
      } else {
        // Hit was more on top/bottom → flip Y
        velocity.y = -velocity.y;
      }

      other.removeFromParent(); // remove brick

      // re-add bricks if all bricks are removed
      if (children.whereType<Brick>().isEmpty) {
        game.spawnBricks(); // next level
      }
    }
  }
}
