import 'dart:math' as math;

double random(num min, num max) {
  return math.Random().nextDouble() * (max - min) + min;
}

int randomInt(int min, int max) {
  return math.Random().nextInt(max - min) + min;
}