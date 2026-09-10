library;

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

// import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter3_core/flutter3_core.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_context_menu/super_context_menu.dart' as sc;
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

export 'package:flutter3_basics/flutter3_basics.dart';
export 'package:flutter3_core/flutter3_core.dart';
export 'package:flutter3_widgets/flutter3_widgets.dart';
export 'package:super_clipboard/super_clipboard.dart';
export 'package:super_drag_and_drop/super_drag_and_drop.dart';

export 'src/core/native_api_ex.dart';
export 'src/widgets/window_caption.dart';
export 'src/window//tray_ex.dart';
export 'src/window/window_ex.dart';

part 'src/core/clipboard_ex.dart';
part 'src/core/context_menu_ex.dart';
part 'src/core/drop_ex.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2024-12-25
///
@initialize
@CallFrom("initDesktopApp")
Future initDesktopCore() async {
  //2025-1-10
}
