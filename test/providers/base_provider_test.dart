import 'package:flutter_test/flutter_test.dart';
import 'package:onstagram/providers/base_provider.dart';

void main() {
  test('every setter changes its flag and tells the listeners', () {
    final baseProvider = BaseProvider();
    var calls = 0;
    baseProvider.addListener(() => calls++);

    baseProvider.setBusy(true);
    baseProvider.setBusyMore(true);
    baseProvider.setFailed(true);
    baseProvider.setPaginating(true);

    expect(baseProvider.busy, isTrue);
    expect(baseProvider.busyMore, isTrue);
    expect(baseProvider.failed, isTrue);
    expect(baseProvider.paginating, isTrue);
    expect(calls, 4);
  });
}
