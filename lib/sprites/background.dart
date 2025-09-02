import 'dart:async';

import 'package:flame/components.dart';

class Background extends SpriteComponent {
  Background() : super();

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('brick_breaker_background.png');
  }
}
