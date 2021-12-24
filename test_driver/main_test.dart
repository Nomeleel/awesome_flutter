import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter Driver Test', () {
    final addCountBtn = find.byValueKey('add_count_btn');
    final minusCountBtn = find.byValueKey('minus_count_btn');
    final listCountText = find.byValueKey('list_count_text');

    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('test list count add and minus', () async {
      expect(await driver.getText(listCountText), "List Count: 0");

      await driver.tap(addCountBtn);

      expect(await driver.getText(listCountText), "List Count: 1");

      await driver.tap(minusCountBtn);

      expect(await driver.getText(listCountText), "List Count: 0");
    });

    test('test minus button disable', () async {
      expect(await driver.getText(listCountText), "List Count: 0");

      await driver.tap(minusCountBtn);

      expect(await driver.getText(listCountText), "List Count: 0");

      await driver.tap(minusCountBtn);

      expect(await driver.getText(listCountText), "List Count: 0");
    });
  });
}
