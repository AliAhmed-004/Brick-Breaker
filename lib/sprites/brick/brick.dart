import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Brick extends RectangleComponent {
  Brick({
    required Vector2 position,
    required Vector2 size,
    required Color color,
  }) : super(position: position, size: size, paint: Paint()..color = color);

  // ONLOAD
  @override
  FutureOr<void> onLoad() {
    // add hitbox
    add(RectangleHitbox());
  }
}
