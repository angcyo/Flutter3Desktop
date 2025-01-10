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
/// https://github.com/leanflutter/window_manager/blob/main/README-ZH.md#%E7%94%A8%E6%B3%95
///
/// https://github.com/leanflutter/window_manager
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

/// 扩展
extension WindowManagerEx on WindowManager {
  /// 获取主要屏幕信息
  Future<Map<String, dynamic>> get primaryDisplay async =>
      (await screenRetriever.getPrimaryDisplay()).toJson();

  /// 获取所有屏幕信息
  Future<List<Map<String, dynamic>>> get allDisplay async =>
      (await screenRetriever.getAllDisplays()).map((e) => e.toJson()).toList();

  /// 获取当前鼠标的位置
  Future<Offset> get cursorScreenPoint async =>
      screenRetriever.getCursorScreenPoint();

  void _test() {
    //screenRetriever.getCursorScreenPoint();
  }
}

/// [windowManager]
/// [WindowManager.instance;]
/// https://pub.dev/packages/window_manager
WindowManager get $wm => WindowManager.instance;

///https://pub.dev/packages/flutter_acrylic
//Window get $window => Window;

class ScreenListenerImpl with ScreenListener {
  /// 监听屏幕事件, 转手一
  final void Function(String eventName)? onScreenEventAction;

  ScreenListenerImpl({this.onScreenEventAction});

  @override
  void onScreenEvent(String eventName) {
    onScreenEventAction?.call(eventName);
  }
}

/// [WindowListener] 窗口事件混入
/// https://github.com/leanflutter/window_manager/blob/main/README-ZH.md#%E7%9B%91%E5%90%AC%E4%BA%8B%E4%BB%B6
///
/// # 关闭时退出
/// 如果你需要使用 hide 方法，你需要禁用 QuitOnClose。
///
/// `with WindowListener, WindowListenerMixin`
///
mixin WindowListenerMixin<T extends StatefulWidget>
    on State<T>, WindowListener {
  /// 是否需要关闭前确认
  bool get enableConfirmClose => false;

  late final ScreenListenerImpl _screenListener =
      ScreenListenerImpl(onScreenEventAction: onScreenEvent);

  @override
  void initState() {
    super.initState();
    $wm.addListener(this);
    screenRetriever.addListener(_screenListener);

    if (enableConfirmClose) {
      () async {
        await $wm.setPreventClose(true);
        //updateState(); //需要?
      }();
    }

    // 添加此行以覆盖默认关闭处理程序
    //await $wm.setPreventClose(true);
    //bool _isPreventClose = await $wm.isPreventClose();
    //await windowManager.destroy();

    //获取窗口信息
    getWindowInfo();
  }

  @override
  void dispose() {
    $wm.removeListener(this);
    screenRetriever.removeListener(_screenListener);
    super.dispose();
  }

  //--

  /// [onWindowEvent]
  /// [onScreenEvent]
  @overridePoint
  void onScreenEvent(String eventName) {
    assert(() {
      () async {
        l.v("onScreenEvent->$eventName");
      }();
      return true;
    }());
  }

  //--

  Size? windowSizeMixin;
  Offset? windowPositionMixin;

  /// 获取窗口信息
  void getWindowInfo() async {
    _getWindowSize();
    _getWindowPosition();
  }

  void _getWindowSize() async {
    final oldSize = windowSizeMixin;
    windowSizeMixin = await $wm.getSize();
    if (oldSize != windowSizeMixin) {
      onSelfWindowSizeChanged();
    }
  }

  void _getWindowPosition() async {
    final oldPosition = windowPositionMixin;
    windowPositionMixin = await $wm.getPosition();

    if (oldPosition != windowPositionMixin) {
      onSelfWindowPositionChanged();
    }
  }

  /// 当窗口大小改变时触发
  /// [onWindowMaximize]
  @overridePoint
  void onSelfWindowSizeChanged() {}

  /// 当窗口位置改变时触发
  /// [onWindowMove]
  /// [onWindowMoved]
  @overridePoint
  void onSelfWindowPositionChanged() {}

  //--

  /// close
  @override
  void onWindowClose() async {
    assert(() {
      l.v("onWindowClose");
      return true;
    }());
    if (enableConfirmClose) {
      bool isPreventClose = await windowManager.isPreventClose();
      if (isPreventClose) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Are you sure you want to close this window?'),
              actions: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    buildContext?.pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    buildContext?.pop();
                    windowManager.destroy();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  /// [onWindowEvent]:focus
  /// 此回调只能在窗口接收到焦点时触发, 丢失焦点不会触发. 而且还会触发2次.
  @override
  void onWindowFocus() {
    assert(() {
      () async {
        l.v("onWindowFocus:${await $wm.isFocused()} isVisible:${await $wm.isVisible()}");
      }();
      return true;
    }());
  }

  /// [onWindowEvent]:blur
  /// 窗口丢失焦点时, 会触发. 而且还会触发2次.
  @override
  void onWindowBlur() {
    assert(() {
      () async {
        l.v("onWindowBlur-> Focus:${await $wm.isFocused()} isVisible:${await $wm.isVisible()}");
      }();
      return true;
    }());
  }

  /// maximize
  @override
  void onWindowMaximize() {
    assert(() {
      l.v("onWindowMaximize");
      return true;
    }());
    _getWindowSize();
  }

  /// unmaximize
  @override
  void onWindowUnmaximize() {
    assert(() {
      l.v("onWindowUnmaximize");
      return true;
    }());
    _getWindowSize();
  }

  /// minimize
  @override
  void onWindowMinimize() {
    assert(() {
      l.v("onWindowMinimize");
      return true;
    }());
  }

  /// 从最小化中恢复
  @override
  void onWindowRestore() {
    assert(() {
      l.v("onWindowRestore");
      return true;
    }());
  }

  /// resize
  @override
  void onWindowResize() {
    assert(() {
      l.v("onWindowResize");
      return true;
    }());
    _getWindowSize();
  }

  /// resized
  @override
  void onWindowResized() {
    assert(() {
      l.v("onWindowResized");
      return true;
    }());
  }

  /// [onWindowEvent]:move
  @override
  void onWindowMove() {
    _getWindowPosition();
  }

  /// [onWindowEvent]:moved
  @override
  void onWindowMoved() {
    _getWindowPosition();
  }

  /// [onWindowEvent]:enter-full-screen
  @override
  void onWindowEnterFullScreen() {
    _getWindowSize();
  }

  /// [onWindowEvent]:leave-full-screen
  @override
  void onWindowLeaveFullScreen() {
    _getWindowSize();
  }

  @override
  void onWindowDocked() {
    assert(() {
      l.v("onWindowDocked");
      return true;
    }());
  }

  @override
  void onWindowUndocked() {
    assert(() {
      l.v("onWindowUndocked");
      return true;
    }());
  }

  /// [onWindowEvent]
  /// [onScreenEvent]
  @override
  void onWindowEvent(String eventName) {
    if (eventName != "move") {
      assert(() {
        () async {
          l.v("onWindowEvent[${await $wm.getTitle()}]->$eventName");
        }();
        return true;
      }());
    }
  }
}
