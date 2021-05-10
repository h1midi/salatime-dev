// @dart=2.11

import 'dart:ui' as ui;

import 'package:salatime/main.dart' as entrypoint;

Future<void> main() async {
  await ui.webOnlyInitializePlatform();
  entrypoint.main();
}
