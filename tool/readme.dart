import 'dart:io';

import 'package:path/path.dart' as path;

final assetsGroup = <String, List<String>>{};
const indexAnchor = r'<!-- INDEX -->';
const detailAnchor = r'<!-- DETAIL -->';

void main(List<String> args) {
  if (args.isEmpty) return;

  final assDir = Directory(args.first);
  if (!assDir.existsSync()) return;

  final dirAssets = assDir.listSync();
  dirAssets.forEach((asset) {
    if (FileSystemEntity.isFileSync(asset.path)) addAsset(asset.path);
  });

  if (assetsGroup.isEmpty) return;

  print(assetsGroup);

  final indexBuffer = StringBuffer();
  final detailBuffer = StringBuffer();

  assetsGroup.forEach((key, value) {
    final item = MarkdownItem(name: key, assetList: value);
    indexBuffer.write(item.index);
    detailBuffer.write(item.detail);
  });

  indexBuffer.write(indexAnchor);
  detailBuffer.write(detailAnchor);

  final readme = File(path.join(Directory.current.path, 'README.md'));
  final newContent = readme
      .readAsStringSync()
      .replaceAll(indexAnchor, indexBuffer.toString())
      .replaceAll(detailAnchor, detailBuffer.toString());

  readme.writeAsStringSync(newContent);
}

addAsset(String name) {
  final assetSplit = name.split('.').first.split('_');
  if (int.tryParse(assetSplit.last) != null) assetSplit.removeLast();
  final key = assetSplit.join('_');
  assetsGroup[key] ??= [];
  assetsGroup[key]!.add(name);
}

String toUpperCaseOnlyFirstLetter(String str) => str[0].toUpperCase() + str.substring(1).toLowerCase();

class MarkdownItem {
  MarkdownItem({required this.name, required this.assetList})
      : title = Set<String>.from(name.split('_')).toList().map(toUpperCaseOnlyFirstLetter).join(' ');

  final String name;
  final String title;
  final List<String> assetList;

  String get titleId => title.replaceAll(' ', '');

  String get index => '[$title](#${titleId.toLowerCase()}) | ';

  String get imageListStr => assetList
      .map((e) =>
          '<img src="https://raw.githubusercontent.com/Nomeleel/Assets/master/awesome_flutter/markdown/$e" width="30%"/>')
      .join('');

  String get detail => '''## $titleId

<!-- Description -->

[Web demo for $title](https://nomeleel.github.io/awesome_flutter/#/$name)

<div align="center">
    $imageListStr
</div>

''';
}
