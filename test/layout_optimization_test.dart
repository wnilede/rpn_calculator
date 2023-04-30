import 'test_functions.dart';

void main() {
  testLayoutOptimizer('2 children perfectly in column', 100, 200, [
    TestableWidget(preferredWidth: 100, preferredHeight: 100, expectedWidth: 100, expectedHeight: 100),
    TestableWidget(preferredWidth: 100, preferredHeight: 100, expectedWidth: 100, expectedHeight: 100)
  ]);
}
