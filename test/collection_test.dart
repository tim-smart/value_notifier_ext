import 'package:flutter_test/flutter_test.dart';
import 'package:value_notifier_ext/value_notifier_ext.dart';

void main() {
  group('hashCode', () {
    test('are identical for same input lists', () {
      const input = [1, 2, 3];

      final one = ValueNotifierCollection.seed(input);
      final two = ValueNotifierCollection.seed(input);

      expect(one == two, true);
      expect(one.hashCode == two.hashCode, true);
    });
  });
}
