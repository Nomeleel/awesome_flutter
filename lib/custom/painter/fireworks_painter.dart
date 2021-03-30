/*
The implementation reference https://codepen.io/whqet/pen/Auzch.
Converted from js to flutter.
*/

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../util/math_util.dart';

class FireworksPainter extends CustomPainter {
  FireworksPainter(this.repaint) : super(repaint: repaint);

  final AnimationController repaint;

  List<Fireworks> fireworksList = <Fireworks>[];

  Size canvasSize;
  Offset get sourcePosition => Offset(canvasSize.width / 2, canvasSize.height);

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize ??= size;

    addSomeFireworks();

    // ignore: avoid_function_literals_in_foreach_calls
    fireworksList.forEach((Fireworks fireworks) {
      fireworksUpdate(canvas, fireworks.trajectory, fireworks.particles);
    });

    removeCooledFireworks();
  }

  void fireworksUpdate(Canvas canvas, Trajectory trajectory, List<Particle> particles) {
    if (!trajectory.endCheck()) {
      canvas.drawLine(
        trajectory.lastPosition,
        trajectory.currentPosition,
        Paint()
          ..strokeWidth = trajectory.brightness
          ..color = trajectory.color,
      );

      trajectory.update();
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      particles.forEach((Particle particle) {
        canvas.drawLine(
          particle.lastPosition,
          particle.currentPosition,
          Paint()
            ..strokeWidth = particle.brightness
            ..color = particle.color.withOpacity(particle.alpha),
        );

        particle.update();
      });

      particles.removeWhere((Particle e) => e.endCheck());
    }
  }

  void removeCooledFireworks() {
    fireworksList.removeWhere((Fireworks fireworks) => fireworks.removeCheck());
  }

  void addSomeFireworks() {
    if (fireworksList.length < 5) {
      fireworksList.addAll(List<Fireworks>.generate(randomInt(2, 7), (_) => addFireworks()));
    }
  }

  void quicklyAddSomeFireworks() {
    Future<void>.delayed(Duration(milliseconds: randomInt(100, 200)), () {
      fireworksList.addAll(List<Fireworks>.generate(randomInt(1, 2), (_) => addFireworks()));
    });
  }

  Fireworks addFireworks() {
    final Offset targetPosition = Offset(random(0, canvasSize.width), random(0, canvasSize.height / 2));
    return Fireworks(
      Trajectory(sourcePosition, targetPosition),
      List<Particle>.generate(100, (_) => Particle(targetPosition)),
    );
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(FireworksPainter oldDelegate) => false;
}

class Fireworks {
  const Fireworks(this.trajectory, this.particles);
  final Trajectory trajectory;
  final List<Particle> particles;

  bool removeCheck() => trajectory.endCheck() && particles.isEmpty;
}

abstract class Continual {
  Continual(this.sourcePosition)
      : currentPosition = sourcePosition,
        lastPosition = sourcePosition;

  final Offset sourcePosition;

  Offset currentPosition;
  Offset lastPosition;

  void update();

  void updatePosition(Offset offset) {
    lastPosition = currentPosition;
    currentPosition += offset;
  }

  bool endCheck();
}

class Trajectory extends Continual {
  Trajectory(Offset sourcePosition, this.targetPosition)
      : angle = math.atan2(targetPosition.dy - sourcePosition.dy, targetPosition.dx - sourcePosition.dx),
        super(sourcePosition);

  final Offset targetPosition;
  final double angle;

  double speed = random(5, 12);
  double acceleration = 1.05;

  Color color = Color(randomInt(0x00000000, 0xFFFFFFFF));
  double brightness = random(0, 3);

  @override
  void update() {
    speed *= acceleration;
    updatePosition(Offset(math.cos(angle) * speed, math.sin(angle) * speed));
  }

  @override
  bool endCheck() => (currentPosition - sourcePosition).distance >= (targetPosition - sourcePosition).distance;
}

class Particle extends Continual {
  Particle(Offset sourcePosition) : super(sourcePosition);

  double angle = random(0, math.pi * 2);
  double speed = random(1, 12);
  double friction = 0.95;
  double gravity = 1;

  Color color = Color(randomInt(0x00000000, 0xFFFFFFFF));
  double brightness = random(0, 3);

  double alpha = 1;
  double decay = random(0.015, 0.03);

  @override
  void update() {
    speed *= friction;
    updatePosition(Offset(math.cos(angle) * speed, math.sin(angle) * speed + gravity));
    alpha -= decay;
  }

  @override
  bool endCheck() => alpha <= 0;
}
