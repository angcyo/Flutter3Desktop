part of '../flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/11
///

extension OpenStringEx on String {
  /// 使用本机能力, 打开文件夹
  /// ```
  /// Process.run('explorer', [path]); // Windows
  /// // 对于 macOS 使用以下命令
  /// // Process.run('open', [path]);
  /// // 对于 Linux 使用以下命令
  /// // Process.run('xdg-open', [path]);
  /// ```
  Future<bool?> openFolderByNative() async {
    assert(() {
      l.v("使用本机打开文件夹->$this");
      return true;
    }());
    /*final result = await Process.run(isWindows ? "explorer" : "open", [this]);
    return result.exitCode == 0;*/
    return OpenDir().openNativeDir(path: this);
  }

  /// 使用本机能力, 打开文件
  Future<bool?> openFileByNative() async {
    //Process.run('explorer', [this]);
    final extension = exName(false); //import 'package:path/path.dart' as path;
    final type = defaultExtensionMap[extension];
    assert(() {
      l.v("使用本机打开文件[$extension -> $type]->$this");
      return true;
    }());
    final result = await OpenFile.open(this, type: type);
    return result.type == ResultType.done;
  }
}
