import 'package:brick_breaker/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';

class PaddleSprite extends RectangleComponent {
  PaddleSprite({
    required Vector2 position,
    required Vector2 size,
    Color color = Colors.lightBlue,
  }) : super(position: position, size: size, paint: Paint()..color = color);

  // MOVEMENT METHODS
  // move left
  void moveLeft(double gameWidth) {
    // prevent going off screen
    if (position.x >= 0) position.x -= paddleMovementSpeed;
  }

  void moveRight(double gameWidth) {
    if (position.x + size.x <= gameWidth) position.x += paddleMovementSpeed;
  }
}
