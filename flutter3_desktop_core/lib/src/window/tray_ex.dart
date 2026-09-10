import 'package:flutter/material.dart';
import 'package:flutter3_basics/flutter3_basics.dart';
import 'package:tray_manager/tray_manager.dart';

///
/// Email:angcyo@126.com
/// @author angcyo
/// @date 2025/01/13
///
/// 系统托盘扩展
TrayManager get $trayManager => TrayManager.instance;

typedef TrayListenerTypedef = TrayListener;

mixin TrayListenerStateMixin<T extends StatefulWidget>
    on State<T>, TrayListener {
  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() {
    // do something, for example pop up the menu
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    // do something
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {
    // do something
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    onTrayMenuItemKeyClick(menuItem.key);
  }

  @overridePoint
  void onTrayMenuItemKeyClick(String? key) {}
}

/// 设置系统托盘, 需要配合[TrayListenerStateMixin]使用
/// [iconAssetKey] 资产下的路径`isWindows ? 'assets/ico/app_icon.ico' : 'assets/ico/app_icon.png',`
///    - 如果图标为空, 则表示清除托盘
Future<void> setSystemTray({
  String? iconAssetKey,
  //--
  List<MenuInfo>? menus,
  Menu? menu,
  //--
  String? title /*windows 下不可用, macOS可用*/,
  String? tooltip,
}) async {
  if (iconAssetKey == null) {
    await trayManager.destroy();
  } else {
    await trayManager.setIcon(iconAssetKey);
  }
  if (title != null && !isWindows) {
    try {
      await trayManager.setTitle(title);
    } catch (e, s) {
      assert(() {
        printError(e, s);
        return true;
      }());
    }
  }
  if (tooltip != null) {
    await trayManager.setToolTip(tooltip);
  }
  /*await trayManager.setIcon(
    Platform.isWindows ? 'images/tray_icon.ico' : 'images/tray_icon.png',
  );*/
  /*Menu menu = Menu(
    items: [
      MenuItem(
        key: 'show_window',
        label: 'Show Window',
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit_app',
        label: 'Exit App',
      ),
    ],
  );*/
  menu ??= Menu(items: [...?menus?.map((e) => e._buildMenuBaseItem())]);
  await trayManager.setContextMenu(menu);
}

/// 菜单信息
class MenuInfo {
  final MenuInfoType? menuType;

  //--
  /// 用来进行事件判断
  final String? key;

  /// 显示的名称
  final String? label;

  final String? icon;

  /// ?
  final String? sublabel;
  final String? toolTip;

  ///
  ///
  final bool? checked;
  final bool disabled;

  /// 子菜单
  final List<MenuInfo>? children;

  //--

  /// 点击事件
  VoidAction? onClick;

  MenuInfo({
    this.menuType,
    this.key,
    this.label,
    this.icon,
    this.sublabel,
    this.toolTip,
    this.children,
    this.checked,
    this.disabled = false,
    this.onClick,
  });

  //region --menu_base

  MenuItem _buildMenuBaseItem() {
    if (menuType == MenuInfoType.separator) {
      return MenuItem.separator();
    }
    if (menuType == MenuInfoType.checkbox) {
      return MenuItem.checkbox(
        key: key,
        label: label,
        sublabel: sublabel,
        toolTip: toolTip,
        checked: checked,
        disabled: disabled,
        onClick: onClick == null ? null : (menu) => onClick?.call(),
      );
    }
    return MenuItem(
      key: key,
      label: label,
      sublabel: sublabel,
      toolTip: toolTip,
      icon: icon,
      checked: checked,
      disabled: disabled,
      onClick: onClick == null ? null : (menu) => onClick?.call(),
      submenu: children == null ? null : _buildMenuBase(),
    );
  }

  Menu _buildMenuBase() {
    return Menu(items: [...?children?.map((e) => e._buildMenuBaseItem())]);
  }

  //endregion --menu_base
}

/// 菜单类型
enum MenuInfoType {
  /// 分割线
  separator,

  /// 勾选框
  checkbox,
}
