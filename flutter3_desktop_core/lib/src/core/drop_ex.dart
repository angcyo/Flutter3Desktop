part of '../../flutter3_desktop_core.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/06
///
/// 1. 使用[buildDropRegion]创建拖拽区域
/// 2. 重写[onSelfHandleDropDone]方法实现拖拽完成事件
///
/// # super_drag_and_drop: ^0.9.1
/// https://pub.dev/packages/super_drag_and_drop
///
/// [DropRegion]
mixin DropStateMixin<T extends StatefulWidget> on State<T> {
  /// 当前的拖拽状态
  @observeFlag
  final dropStateInfoSignal = $signal<DropStateInfo>();

  /// 是否需要一直触发拖拽悬停信号, 关闭后节省性能
  @configProperty
  bool needDropOverSignal = false;

  /// 当前是否处于拖拽悬停状态
  bool get isDropOverMixin =>
      dropStateInfoSignal.value?.state.isDropOver == true;

  /// 调用此方法, 创建可拖动的区域, 并构建对应的拖拽效果
  /// - [formats] 支持的格式
  ///
  /// - [DropStateInfo]当前的拖拽状态
  ///
  /// 通过覆盖[onSelfHandleDropDone]方法, 处理拖拽完成事件
  @callPoint
  Widget buildDropRegion(
    BuildContext context,
    Widget? child, {
    HitTestBehavior hitTestBehavior = HitTestBehavior.translucent,
    List<DataFormat> formats = Formats.standardFormats,
  }) {
    return DropRegion(
      key: ValueKey("DropRegion"),
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
        try {
          await onSelfHandleDropDone(context, event);
        } catch (e) {
          printError(e);
        }
      },
      child: child,
    );
    //--other library
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
  /// 通过[PerformDropEvent.session.texts]拿到文本信息, 自行处理
  /// 通过[PerformDropEvent.session.uris]拿到文件Uri信息, 自行处理
  @overridePoint
  FutureOr<DropStateInfo> onSelfHandleDropDone(
    BuildContext context,
    PerformDropEvent event,
  ) async {
    //event.session.fileBytes;
    final uris = await event.session.uris;
    final texts = await event.session.texts;
    //final imageBytes = await event.session.imageBytes;
    final images = await event.session.images;
    final dropStateInfo = DropStateInfo(
      DropStateEnum.done,
      dropTextList: texts,
      dropUriList: uris,
      /*dropImageBytesList:  imageBytes,*/
      dropImageList: images,
    );
    assert(() {
      l.t("[${classHash()}]拖拽数据->uris:$uris texts:$texts images:$images");
      return true;
    }());
    /*assert(() {
      debugger();
      return true;
    }());*/
    dropStateInfoSignal.value = dropStateInfo;
    return dropStateInfo;
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

  /// 拖拽图片字节数据列表
  final List<Uint8List>? dropImageBytesList;

  /// 拖拽图片列表
  final List<UiImage>? dropImageList;

  const DropStateInfo(
    this.state, {
    this.dropTextList,
    this.dropUriList,
    this.dropImageBytesList,
    this.dropImageList,
  });

  @override
  String toString() {
    return "$runtimeType{state: $state, dropTextList: $dropTextList, dropUriList: $dropUriList, dropImageList: $dropImageList}";
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
  done;

  /// 正处于拖拽悬停
  bool get isDropOver =>
      this == DropStateEnum.entered || this == DropStateEnum.over;
}

/// - [DropSession]扩展
/// - [DropSession.items]拖拽的数据
/// `super_drag_and_drop`
extension DropSessionEx on DropSession {
  /// 获取所有文本路径
  Future<List<String>> get texts =>
      getValueList(Formats.plainText, Formats.plainText);

  /// 获取所有文件路径
  Future<List<Uri>> get uris => getValueList(Formats.fileUri, Formats.fileUri);

  /// 获取所有文件数据, 在macOS上没有权限访问的路径时, 需要直接使用文件数据
  Future<List<(String, Uint8List)>> get fileBytes async {
    List<(String, Uint8List)> result = [];
    await eachReadSessionValue((format, value) {
      debugger();
    });
    return result;
  }

  /// 获取所有图片字节数据
  Future<List<Uint8List>> get imageBytes async {
    List<SimpleFileFormat> formats = imageFormats;
    return [
      for (final format in formats) ...(await getFileValueList(format, format)),
    ];
  }

  /// 获取所有图片对象
  Future<List<UiImage>> get images async {
    List<SimpleFileFormat> formats = imageFormats;
    List<UiImage> images = [];
    for (final format in formats) {
      final list = await getFileValueList(format, format);
      for (final bytes in list) {
        images.add(await bytes.toImage());
      }
    }
    return images;
  }

  @allPlatformFlag
  Future eachReadSessionValue(
    FutureOr Function(DataFormat format, dynamic value) callback,
  ) async {
    await items.asyncForEach((item, completer) async {
      debugger();
      for (final format in Formats.standardFormats) {
        final reader = item.dataReader;
        if (item.canProvide(format)) {
          if (format is ValueFormat) {
            reader?.getValue(format, (value) async {
              await callback(format, value);
            });
          } else if (format is FileFormat) {
            String? fileName;
            Uint8List? bytes;
            reader?.getFile(format, (file) async {
              fileName = file.fileName;
              assert(() {
                l.i(
                  "eachReadSessionValue fileName:$fileName fileSize:${file.fileSize}",
                );
                return true;
              }());
              bytes = await file.readAll();
              await callback(format, (fileName, bytes));
            });
          } else {
            debugger();
          }
        }
      }
      completer.complete();
    });
  }

  /// 获取所有文件路径
  Future<List<T>> getValueList<T extends Object>(
    DataFormat dataFormat,
    ValueFormat<T> valueFormat,
  ) async {
    List<T> result = [];
    await items.asyncForEach((item, completer) {
      final reader = item.dataReader;
      if (reader != null && reader.canProvide(dataFormat)) {
        reader.getValue<T>(
          valueFormat,
          (value) {
            if (value != null) {
              result.add(value);
            }
            completer.complete();
          },
          onError: (error) {
            completer.complete();
            assert(() {
              printError(error);
              return true;
            }());
          },
        );
      } else {
        completer.complete();
      }
    });
    return result;
  }

  /// 获取所有图片字节数据
  Future<List<Uint8List>> getFileValueList<T extends Object>(
    DataFormat dataFormat,
    FileFormat valueFormat,
  ) async {
    List<Uint8List> result = [];
    await items.asyncForEach((item, completer) {
      final reader = item.dataReader;
      if (reader != null && reader.canProvide(dataFormat)) {
        reader.getFile(
          valueFormat,
          (file) async {
            final bytes = await file.readAll();
            if (bytes.isNotEmpty) {
              result.add(bytes);
            }
            completer.complete();
          },
          onError: (error) {
            debugger();
            completer.complete();
            assert(() {
              printError(error);
              return true;
            }());
          },
          allowVirtualFiles: false /*macOS上从飞书拖拽图片过来会崩溃*/,
        );
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
