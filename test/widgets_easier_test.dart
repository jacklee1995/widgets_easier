import 'package:flutter_test/flutter_test.dart';
import 'package:widgets_easier/widgets_easier.dart';
import 'package:widgets_easier/widgets_easier_platform_interface.dart';
import 'package:widgets_easier/widgets_easier_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWidgetsEasierPlatform
    with MockPlatformInterfaceMixin
    implements WidgetsEasierPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WidgetsEasierPlatform initialPlatform = WidgetsEasierPlatform.instance;

  test('$MethodChannelWidgetsEasier is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWidgetsEasier>());
  });

  test('getPlatformVersion', () async {
    WidgetsEasier widgetsEasierPlugin = WidgetsEasier();
    MockWidgetsEasierPlatform fakePlatform = MockWidgetsEasierPlatform();
    WidgetsEasierPlatform.instance = fakePlatform;

    expect(await widgetsEasierPlugin.getPlatformVersion(), '42');
  });
}
