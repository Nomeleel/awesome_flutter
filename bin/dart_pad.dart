// ignore_for_file: avoid_print

void main(List<String> args) {
  softMap();
}

/// 先按照Key字符串排序，在对值以true在前排序
void softMap() {
  final map = {
    'D': true,
    'A': false,
    'F': true,
    'E': false,
    'C': true,
    'G': true,
    'B': false,
  };

  final sortedKeys = map.keys.toList(growable: false)
    ..sort()
    ..sort((a, b) => map[a]! || !map[b]! ? -1 : 1);
  Map sortedMap = {for (final k in sortedKeys) k: map[k]};

  print(sortedMap);
}
