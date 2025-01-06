part of '../../flutter3_desktop_core.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/06
///
/// [DropRegion]
mixin DropStateMixin<T extends StatefulWidget> on State<T> {
  /// 当前的拖拽状态
  final dropStateInfoSignal = $signal<DropStateInfo>();

  /// 是否需要一直触发拖拽悬停信号, 关闭后节省性能
  bool needDropOverSignal = false;

  @callPoint
  Widget buildDropRegion(
    BuildContext context,
    Widget? child, {
    HitTestBehavior hitTestBehavior = HitTestBehavior.translucent,
    List<DataFormat> formats = Formats.standardFormats,
  }) {
    return DropRegion(
      formats: formats,
      hitTestBehavior: hitTestBehavior,
      onDropEnter: (event) {
        dropStateInfoSignal.value = DropStateInfo(DropStateEnum.entered);
      },
      onDropLeave: (event) {
        if (dropStateInfoSignal.value?.state != DropStateEnum.done) {
          dropStateInfoSignal.value = DropStateInfo(DropStateEnum.exited);
        }
      },
      onDropOver: (event) {
        if (dropStateInfoSignal.value?.state != DropStateEnum.entered ||
            dropStateInfoSignal.value?.state != DropStateEnum.over) {
          dropStateInfoSignal.value = DropStateInfo(DropStateEnum.entered);
        }
        if (needDropOverSignal) {
          dropStateInfoSignal.value = DropStateInfo(DropStateEnum.over);
        }
        if (event.session.allowedOperations.contains(DropOperation.copy)) {
          return DropOperation.copy;
        } else {
          return DropOperation.none;
        }
      },
      onPerformDrop: (event) async {
        await onHandleDropDone(event);
      },
      child: child,
    );
    //--
    /*return DropTarget(
      onDragEntered: (details) {
        print("onDragEntered");
      },
      onDragExited: (details) {
        print("onDragExited");
      },
      onDragDone: (details) {
        print("onDragDone->$details");
      },
      onDragUpdated: (details) {
        print("onDragUpdated");
      },
      child: Container(
        height: 200,
        width: 200,
        child: const Center(child: Text("Drop here")),
      ),
    );*/
  }

  /// 重写此方法, 处理拖拽完成事件
  @overridePoint
  FutureOr onHandleDropDone(PerformDropEvent event) async {
    dropStateInfoSignal.value = DropStateInfo(
      DropStateEnum.done,
      dropTextList: await event.session.texts,
      dropUriList: await event.session.uris,
    );
  }
}

/*
/// `desktop_drop`
extension DropItemEx on DropItem {
  String toLogString() {
    return "$runtimeType{mimeType: $mimeType, name: $name, path: $path}";
  }
}
*/

/// 拖拽状态信息
class DropStateInfo {
  final DropStateEnum state;

  /// 拖拽文本列表
  final List<String>? dropTextList;

  /// 拖拽文件列表
  final List<Uri>? dropUriList;

  const DropStateInfo(
    this.state, {
    this.dropTextList,
    this.dropUriList,
  });

  @override
  String toString() {
    return "$runtimeType{state: $state, dropTextList: $dropTextList, dropUriList: $dropUriList}";
  }
}

enum DropStateEnum {
  /// 拖拽进入
  entered,

  /// 拖拽离开
  exited,

  /// 拖拽悬停
  over,

  /// 拖拽完成
  done,
  ;

  /// 正处于拖拽悬停
  bool get isDropOver =>
      this == DropStateEnum.entered || this == DropStateEnum.over;
}

/// `super_drag_and_drop`
extension DropSessionEx on DropSession {
  /// 获取所有文本路径
  Future<List<String>> get texts =>
      getValueList(Formats.plainText, Formats.plainText);

  /// 获取所有文件路径
  Future<List<Uri>> get uris => getValueList(Formats.fileUri, Formats.fileUri);

  /// 获取所有文件路径
  Future<List<T>> getValueList<T extends Object>(
      DataFormat dataFormat, ValueFormat<T> valueFormat) async {
    List<T> result = [];
    await items.asyncForEach((item, completer) {
      final reader = item.dataReader;
      if (reader != null && reader.canProvide(dataFormat)) {
        reader.getValue<T>(valueFormat, (value) {
          if (value != null) {
            result.add(value);
          }
          completer.complete();
        }, onError: (error) {
          completer.complete();
          assert(() {
            printError(error);
            return true;
          }());
        });
      } else {
        completer.complete();
      }
    });
    return result;
  }

  String toLogString() {
    return "$runtimeType{items(${items.size()}): ${items.join("\n")}, allowedOperations: $allowedOperations}";
  }
}
