part of '../../flutter3_desktop_core.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2024/12/25
///

/// 初始化窗口
/// 请在[runApp]之前调用
///
/// 默认的尺寸和位置在 `main.cpp`
/// ```
/// FlutterWindow window(project);
/// Win32Window::Point origin(10, 10);
/// Win32Window::Size size(1280, 720);
/// ```
///
/// [skipTaskbar] 窗口是否在任务栏中隐藏
///
/// [DragToMoveArea]
/// [DragToResizeArea]
/// [WindowCaption]
///  - [WindowCaptionButton.minimize]
///  - [WindowCaptionButton.maximize]
///  - [WindowCaptionButton.unmaximize]
///  - [WindowCaptionButton.close]
///
/// [WindowListener]
///
@initialize
Future initWindow({
  Size? size /*Size(800, 600) Size(1280, 720)*/,
  bool? center = true,
  Size? minimumSize,
  Size? maximumSize,
  bool? alwaysOnTop,
  bool? fullScreen,
  Color? backgroundColor = Colors.transparent,
  bool? skipTaskbar = false,
  String? title,
  TitleBarStyle? titleBarStyle = TitleBarStyle.normal,
  bool? windowButtonVisibility,
}) async {
  ensureInitialized();
  // 必须加上这一行。
  await $wm.ensureInitialized();

  final windowOptions = WindowOptions(
    size: size,
    center: center,
    minimumSize: minimumSize,
    maximumSize: maximumSize,
    alwaysOnTop: alwaysOnTop,
    fullScreen: fullScreen,
    backgroundColor: backgroundColor,
    skipTaskbar: skipTaskbar,
    title: title,
    titleBarStyle: titleBarStyle,
    windowButtonVisibility: windowButtonVisibility,
  );
  $wm.waitUntilReadyToShow(windowOptions, () async {
    await $wm.show();
    await $wm.focus();
  });
}

/// [windowManager]
/// [WindowManager.instance;]
WindowManager get $wm => WindowManager.instance;
