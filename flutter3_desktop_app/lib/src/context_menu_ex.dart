part of '../flutter3_desktop_app.dart';

///
/// Email:angcyo@126.com
/// @author angcyo
/// @date 2025/01/13
///
extension ContextMenuEx on Widget {
  /// 原生上下文菜单, 右键触发显示菜单
  /// [ContextMenuWidget]
  ///
  /// [MenuImage]
  /// [IconMenuImage]
  /// [ImageProviderMenuImage]
  /// [SystemMenuImage]
  ///
  /// [Menu] 菜单容器
  /// [MenuSeparator] 分割线
  /// [MenuAction] 菜单项
  ///
  Widget contextMenu({
    List<MenuElement> actions = const [],
    //--
    MenuProvider? menuProvider,
  }) {
    return ContextMenuWidget(
      // force to use dark brightness
      // mobileMenuWidgetBuilder: DefaultMobileMenuWidgetBuilder(brightness: Brightness.dark),
      menuProvider: menuProvider ??
          (request) {
            return Menu(children: actions);
          },
      child: this,
    );
  }
}
