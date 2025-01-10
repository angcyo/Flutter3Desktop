library;

import 'dart:async';

// import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter3_core/flutter3_core.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:window_manager/window_manager.dart';

export 'package:flutter3_basics/flutter3_basics.dart';
export 'package:flutter3_core/flutter3_core.dart';
export 'package:flutter3_widgets/flutter3_widgets.dart';
export 'package:super_clipboard/super_clipboard.dart';
export 'package:super_drag_and_drop/super_drag_and_drop.dart';
export 'package:window_manager/window_manager.dart';

part 'src/core/drop_ex.dart';
part 'src/window/window_ex.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2024-12-25
///
@initialize
@CallFrom("initDesktopApp")
Future initDesktopCore() async {
  //2025-1-10
}
