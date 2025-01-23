part of '../flutter3_desktop_app.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/11
///

extension OpenStringEx on String {
  /// 使用本机能力, 打开文件夹
  /// ```
  /// Process.run('explorer', [path]); // Windows
  /// # 对于 macOS 使用以下命令
  /// # Process.run('open', [path]);
  /// # 对于 Linux 使用以下命令
  /// # Process.run('xdg-open', [path]);
  /// ```
  /// [GlobalConfig.openFileFn]
  /// [openFilePath]
  Future<bool?> openFolderByNative() async {
    assert(() {
      l.d("使用本机打开文件夹->$this");
      return true;
    }());
    /*final result = await Process.run(isWindows ? "explorer" : "open", [this]);
    return result.exitCode == 0;*/
    return OpenDir().openNativeDir(path: this);
  }

  /// 使用本机能力, 打开文件
  Future<bool?> openFileByNative() async {
    //Process.run('explorer', [this]);
    //Process.run('open', [this]);
    final extension = exName(false); //import 'package:path/path.dart' as path;
    final type = defaultExtensionMap[extension];
    final result = await OpenFile.open(this, type: type);
    assert(() {
      l.d("使用本机打开文件[$extension -> $type]->$this [${result.type}/${result.message}]");
      return true;
    }());
    return result.type == ResultType.done;
  }
}
