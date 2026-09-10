// import 'dart:developer';
// import 'dart:ui';
//
// import 'package:flutter/material.dart' show StatefulWidget;
// import 'package:flutter/widgets.dart' show State;
// import 'package:flutter3_basics/flutter3_basics.dart';
// import 'package:nativeapi/nativeapi.dart';
//
// ///
// /// @author <a href="mailto:angcyo@126.com">angcyo</a>
// /// @date 2026/09/10
// ///
// /// https://pub.dev/packages/nativeapi
//
// /// 初始化原生窗口
// @initialize
// void initNativeWindow({Size? size}) {
//   final cw = $nativeCurrentWindow;
//   if (cw == null) {
//     return;
//   }
//   debugger();
//   if (size != null) {
//     cw.setSize(size, false);
//   }
// }
//
// /// 原生窗口管理
// /// [WindowManager]
// ///   - [WindowManager.addListener] 窗口事件监听
// ///   - [WindowManager.removeListener]
// WindowManager get $wm => WindowManager.instance;
//
// /// 显示器管理
// DisplayManager get $dm => DisplayManager.instance;
//
// /// 当前鼠标的位置
// Offset get $nativeCursorPosition => $dm.getCursorPosition();
//
// /// 获取当前的窗口
// /// - [Window.focus]
// /// - [Window.blur]
// /// - [Window.show]
// /// - [Window.hide]
// /// - [Window.maximize]
// /// - [Window.unmaximize]
// /// - [Window.minimize]
// /// - [Window.restore]
// /// - [Window.center]
// Window? get $nativeCurrentWindow {
//   try {
//     return $wm.getCurrent();
//   } catch (e) {
//     assert(() {
//       l.w(e);
//       return true;
//     }());
//     return null;
//   }
// }
//
// /// 获取所有窗口
// List<Window> get $nativeWindows {
//   try {
//     return WindowManager.instance.getAll();
//   } catch (e) {
//     assert(() {
//       l.w(e);
//       return true;
//     }());
//     return [];
//   }
// }
//
// /// 获取主屏幕
// Display? get $nativePrimaryDisplay =>
//     $nativeDisplays.firstWhereOrNull((element) => element.isPrimary);
//
// /// 获取所有显示器
// List<Display> get $nativeDisplays {
//   try {
//     return DisplayManager.instance.getAll();
//   } catch (e) {
//     assert(() {
//       l.w(e);
//       return true;
//     }());
//     return [];
//   }
// }
//
// //MARK: - WindowEvent
//
// /// 窗口事件[WindowEvent]混入
// mixin NativeWindowEventStateMixin<T extends StatefulWidget> on State<T> {
//   ListenerId? _windowEventListenerId;
//
//   @override
//   void initState() {
//     _windowEventListenerId = $wm.addListener(onWindowEventMixin);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (_windowEventListenerId != null) {
//       $wm.removeListener(_windowEventListenerId!);
//     }
//     super.dispose();
//   }
//
//   /// 窗口事件监听
//   /// - [WindowMovedEvent] 窗口移动事件
//   /// - [WindowFocusedEvent] 窗口聚焦事件
//   /// - [WindowBlurredEvent] 窗口失焦事件
//   /// - [WindowMaximizedEvent]
//   /// - [WindowMinimizedEvent]
//   /// - [WindowResizedEvent]
//   /// - [WindowRestoredEvent]
//   @overridePoint
//   void onWindowEventMixin(Object event) {
//     assert(() {
//       l.d('[${classHash()}]WindowEvent: $event');
//       return true;
//     }());
//   }
// }
//
// extension WindowEventObjectEx on Object {
//   bool get isWindowMovedEvent => this is WindowMovedEvent;
//
//   bool get isWindowFocusedEvent => this is WindowFocusedEvent;
//
//   bool get isWindowBlurredEvent => this is WindowBlurredEvent;
//
//   bool get isWindowMaximizedEvent => this is WindowMaximizedEvent;
//
//   bool get isWindowMinimizedEvent => this is WindowMinimizedEvent;
//
//   bool get isWindowRestoredEvent => this is WindowRestoredEvent;
//
//   bool get isWindowResizedEvent => this is WindowResizedEvent;
// }
//
// //MARK: - Tray 托盘
//
// typedef TrayIconTypedef = TrayIcon;
//
// /// 托盘图标混入
// mixin TrayIconStateMixin<T extends StatefulWidget> on State<T> {
//   final List<TrayIconTypedef> _trayIcons = [];
//
//   @override
//   void dispose() {
//     removeAllTrayMixin();
//     super.dispose();
//   }
//
//   /// 创建托盘图标
//   @api
//   TrayIconTypedef? createTrayMixin({
//     String? title,
//     String? tooltip,
//     String? iconAssetKey,
//     //--
//     bool visible = true,
//     //--
//     MenuTypedef? menu,
//     ContextMenuTrigger? trigger,
//   }) {
//     final trayIcon = $createTray(
//       title: title,
//       tooltip: tooltip,
//       iconAssetKey: iconAssetKey,
//       visible: visible,
//       menu: menu,
//       trigger: trigger,
//     );
//     if (trayIcon == null) {
//       return null;
//     }
//     _trayIcons.add(trayIcon);
//     return trayIcon;
//   }
//
//   /// 移除托盘图标
//   @api
//   void removeAllTrayMixin() {
//     for (final trayIcon in _trayIcons) {
//       trayIcon.dispose();
//     }
//     _trayIcons.clear();
//   }
// }
//
// @api
// Image? $buildNativeImage({String? iconAssetKey, String? iconBase64Data}) {
//   if (iconAssetKey != null) {
//     final icon = ImageAsset.fromAsset(iconAssetKey);
//     if (icon != null) {
//       return icon;
//     }
//   }
//   if (iconBase64Data != null) {
//     final icon = Image.fromBase64(iconBase64Data);
//     if (icon != null) {
//       return icon;
//     }
//   }
//   return null;
// }
//
// /// 创建托盘图标
// /// - [iconAssetKey] 图标资源键
// ///
// /// - [TrayIcon.dispose] 释放托盘图标
// @api
// TrayIconTypedef? $createTray({
//   String? title,
//   String? tooltip,
//   String? iconAssetKey,
//   String? iconBase64Data,
//   //--
//   bool visible = true,
//   //--
//   MenuTypedef? menu,
//   ContextMenuTrigger? trigger,
// }) {
//   final trayIcon = TrayIcon.create();
//   if (trayIcon == null) {
//     return null;
//   }
//   //--base
//   trayIcon.setTitle(title);
//   trayIcon.setTooltip(tooltip);
//   final icon = $buildNativeImage(
//     iconAssetKey: iconAssetKey,
//     iconBase64Data: iconBase64Data,
//   );
//   if (icon != null) {
//     trayIcon.icon = icon;
//   }
//
//   //TrayIconData();
//   //--menu
//   if (menu != null) {
//     trayIcon.setContextMenu(menu);
//     trayIcon.setContextMenuTrigger(trigger ?? .clicked);
//   }
//
//   //final trayEventListenerId = trayIcon.addListener((event) {});
//   trayIcon.setVisible(visible);
//   return trayIcon;
// }
//
// extension TrayIconTypeEx on TrayIconTypedef {
//   /// 显示托盘图标
//   void show(bool visible) => setVisible(visible);
//
//   /// 释放托盘图标
//   void remove() => dispose();
//
//   /// 根据监听器ID移除监听器
//   bool removeListenerById(int listenerId) => removeListener(listenerId);
// }
//
// /// [TrayIconClickedEvent]
// /// [TrayIconRightClickedEvent]
// /// [TrayIconDoubleClickedEvent]
// extension TrayIconEventObjectEx on Object {
//   bool get isTrayIconClickedEvent => this is TrayIconClickedEvent;
//
//   bool get isTrayIconRightClickedEvent => this is TrayIconRightClickedEvent;
//
//   bool get isTrayIconDoubleClickedEvent => this is TrayIconDoubleClickedEvent;
// }
//
// //MARK: - NativeMenu
//
// typedef MenuTypedef = Menu;
// typedef MenuItemTypedef = MenuItem;
//
// extension MenuTypedefEx on MenuTypedef {
//   /// 显示菜单
//   void show({Offset? point, Placement? placement}) => open(
//     point == null
//         ? PositioningStrategy.cursorPosition()!
//         : PositioningStrategy.absolute(point)!,
//     placement ?? Placement.bottom,
//   );
//
//   /// 释放菜单
//   void remove() => close();
//
//   /// 根据监听器ID移除监听器
//   bool removeListenerById(int listenerId) => removeListener(listenerId);
// }
//
// /// 创建原生菜单
// /// - [$buildNativeMenu]
// /// - [$buildNativeMenuItem]
// MenuTypedef? $buildNativeMenu({List<MenuItemTypedef>? submenu}) {
//   final menu = Menu.create();
//   if (menu == null) {
//     return null;
//   }
//   if (submenu != null) {
//     for (final item in submenu) {
//       menu.addItem(item);
//     }
//   }
//   return menu;
// }
//
// /// 创建原生菜单项
// MenuItemTypedef? $buildNativeMenuItem(
//   String label, {
//   String? tooltip,
//   String? iconAssetKey,
//   String? iconBase64Data,
//   bool enabled = true,
//   /*bool visible = true,
//   bool checked = false,
//   MenuItemTypedef? parent,*/
//   //--
//   bool? isSeparator /*是否是分割线样式*/,
//   bool? isChecked /*是否勾选框样式*/,
//   MenuTypedef? submenu,
//   //--
//   void Function(Object event)? onMenuEvent,
// }) {
//   final menuItem = MenuItem.createWithLabelAndType(
//     label,
//     isSeparator == true
//         ? .separator
//         : isChecked != null
//         ? .checkbox
//         : submenu != null
//         ? .submenu
//         : .normal,
//   );
//   if (menuItem == null) {
//     return null;
//   }
//   final icon = $buildNativeImage(
//     iconAssetKey: iconAssetKey,
//     iconBase64Data: iconBase64Data,
//   );
//   if (icon != null) {
//     menuItem.icon = icon;
//   }
//   menuItem.tooltip = tooltip;
//   menuItem.isEnabled = enabled;
//   //menuItem.radioGroup = 0;
//   if (isChecked != null) {
//     menuItem.state = isChecked ? .checked : .unchecked;
//   }
//   if (submenu != null) {
//     menuItem.submenu = submenu;
//   }
//   if (onMenuEvent != null) {
//     final listenerId = menuItem.addListener((event) {
//       onMenuEvent(event);
//     });
//     //menuItem.removeListener(listenerId);
//   }
//   return menuItem;
// }
//
// /// [MenuEvent]
// ///   - [MenuOpenedEvent]
// ///   - [MenuClosedEvent]
// ///   - [MenuItemClickedEvent]
// ///   - [MenuItemSubmenuOpenedEvent]
// ///   - [MenuItemSubmenuClosedEvent]
// extension MenuEventObjectEx on Object {
//   bool get isMenuOpenedEvent => this is MenuOpenedEvent;
//
//   bool get isMenuClosedEvent => this is MenuClosedEvent;
//
//   bool get isMenuItemClickedEvent => this is MenuItemClickedEvent;
//
//   bool get isMenuItemSubmenuOpenedEvent => this is MenuItemSubmenuOpenedEvent;
//
//   bool get isMenuItemSubmenuClosedEvent => this is MenuItemSubmenuClosedEvent;
// }
