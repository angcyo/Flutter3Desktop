library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter3_desktop_core/flutter3_desktop_core.dart';
import 'package:open_dir/open_dir.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:super_context_menu/super_context_menu.dart';

export 'package:flutter3_app/flutter3_app.dart';
export 'package:flutter3_desktop_core/flutter3_desktop_core.dart';
export 'package:super_context_menu/super_context_menu.dart';

part 'src/context_menu_ex.dart';
part 'src/open_ex.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @since 2024-12-25
///
///
@initialize
Future initDesktopApp() async {
  GlobalConfig.def.openFileFn = (context, filePath, meta) {
    if (isNil(filePath)) {
      return Future.value(false);
    }
    if (filePath!.isDirectorySync()) {
      filePath.openFolderByNative();
    } else {
      filePath.openFileByNative();
    }
    return Future.value(true);
  };
  //2025-1-10
  await initDesktopCore();
}
