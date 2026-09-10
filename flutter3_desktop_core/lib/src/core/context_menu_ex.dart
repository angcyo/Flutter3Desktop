part of '../../flutter3_desktop_core.dart';

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
  /// [sc.Menu] 菜单容器
  /// [sc.MenuSeparator] 分割线
  /// [sc.MenuAction] 菜单项
  ///
  Widget contextMenu({
    List<sc.MenuElement> actions = const [],
    //--
    sc.MenuProvider? menuProvider,
  }) {
    return sc.ContextMenuWidget(
      // force to use dark brightness
      // mobileMenuWidgetBuilder: DefaultMobileMenuWidgetBuilder(brightness: Brightness.dark),
      menuProvider:
          menuProvider ??
          (request) {
            return sc.Menu(children: actions);
          },
      child: this,
    );
  }
}

typedef MenuTypedef = sc.Menu;
typedef MenuImageTypedef = sc.MenuImage;
typedef MenuActionTypedef = sc.MenuAction;
typedef MenuActionStateTypedef = sc.MenuActionState;
typedef MenuActionAttributesTypedef = sc.MenuActionAttributes;
