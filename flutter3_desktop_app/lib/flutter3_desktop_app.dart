library;

import 'package:flutter3_desktop_core/flutter3_desktop_core.dart';

export 'package:flutter3_app/flutter3_app.dart';
export 'package:flutter3_desktop_core/flutter3_desktop_core.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2024-12-25
///
///
@initialize
Future initDesktopApp() async {
  //2025-1-10
  await initDesktopCore();
}
