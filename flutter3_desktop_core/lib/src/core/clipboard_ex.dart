part of '../../flutter3_desktop_core.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/13
///
/// https://pub.dev/packages/super_clipboard

//MARK: - read

/// 枚举读取系统剪切板数据
/// - [ValueFormat]  数值类型返回数据
///   - [SimpleValueFormat]
///       - [Formats.fileUri] 复制文件/文件夹 对应这个格式
///       - `file:///Users/angcyo/Downloads/Untitled.ydp`
///       - `file:///Users/angcyo/Library/Containers/com.tencent.qq/Data/Library/Application%20Support/QQ/nt_qq_ca465af70ecf541c7c4596e666d14d70/nt_data/Emoji/emoji-recv/2025-12/Ori/f0e5c7ad67cafa73eb8d55ce0b87b373.png`
///   - [Uri]
///   - [NamedUri]
/// - [FileFormat] 文件类型返回[DataReaderFile]
///   - [SimpleFileFormat] ``
///       - [Formats.jpeg] 对应这个格式
///       - [Formats.png] 对应这个格式
///   - [DataReaderFileValueAdapter] 复制磁盘文件
///   - [DataReaderVirtualFileAdapter] 直接复制图片
@allPlatformFlag
Future eachReadClipboardValue(
  FutureOr Function(DataFormat format, dynamic value) callback,
) async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return null; // Clipboard API is not supported on this platform.
  }
  final reader = await clipboard.read();
  for (final format in Formats.standardFormats) {
    if (reader.canProvide(format)) {
      if (format is ValueFormat) {
        final value = await reader.readValue(format);
        await callback(format, value);
      } else if (format is FileFormat) {
        /*Uint8List? bytes;
        await asyncFuture((completer) {
          reader.getFile(format, (file) async {
            */ /*final fileName = file.fileName;
            debugger();*/ /*
            assert(() {
              l.i("fileName:${file.fileName} fileSize:${file.fileSize}");
              return true;
            }());
            bytes = await file.readAll();
            completer.complete(bytes);
          });
        });
        await callback(format, bytes);*/
        DataReaderFile? file = await asyncFuture((completer) {
          reader.getFile(format, (file) async {
            completer.complete(file);
          });
        });
        await callback(format, file);
      } else {
        debugger();
      }
    }
  }
}

/// 泛型读取系统剪切板数据
/// - [format] 剪切板数据格式
///   - [Formats.uri]
///   - [Formats.fileUri]
///   - [Formats.png]
///   - [Formats.plainText]
///   - [Formats.htmlText]
/// - [valueFormat] 对应的数据格式
@allPlatformFlag
Future<T?> readClipboardValue<T extends Object>(
  DataFormat format,
  ValueFormat<T> valueFormat,
) async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return null; // Clipboard API is not supported on this platform.
  }
  final reader = await clipboard.read();

  if (reader.canProvide(format)) {
    return reader.readValue(valueFormat);
  }
  return null;
}

/// 读取剪切板图片字节数据
@allPlatformFlag
Future<Uint8List?> readClipboardImageBytes() async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return null; // Clipboard API is not supported on this platform.
  }
  final reader = await clipboard.read();
  if (reader.canProvide(Formats.png)) {
    Uint8List? bytes;
    await asyncFuture((completer) {
      reader.getFile(Formats.png, (file) async {
        // Do something with the PNG image
        //final stream = file.getStream();
        bytes = await file.readAll();
        completer.complete(bytes);
      });
    });
    return bytes;
  }
  return null;
}

/// 读取剪切板图片
@allPlatformFlag
Future<UiImage?> readClipboardImage() async =>
    (await readClipboardImageBytes())?.toImage();

/// 读取剪切板图片列表
@allPlatformFlag
Future<List<UiImage>> readClipboardImageList({
  List<DataFormat> formats = const [Formats.png, Formats.jpeg],
}) async {
  final List<UiImage> result = [];
  await eachReadClipboardValue((format, value) async {
    //debugger();
    if (formats.contains(format)) {
      if (value is DataReaderFile) {
        final bytes = await value.readAll();
        final image = await bytes.toImage();
        result.add(image);
      }
    }
  });
  return result;
}

/// 读取剪切板文本
@allPlatformFlag
Future<String?> readClipboardText() async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return null; // Clipboard API is not supported on this platform.
  }
  final reader = await clipboard.read();
  if (reader.canProvide(Formats.plainText)) {
    return reader.readValue(Formats.plainText);
  }
  if (reader.canProvide(Formats.htmlText)) {
    return reader.readValue(Formats.htmlText);
  }
  return null;
}

/// 读取剪切板字符串列表
@allPlatformFlag
Future<List<String>> readClipboardTextList({
  List<DataFormat> formats = const [Formats.plainText],
}) async {
  final List<String> result = [];
  await eachReadClipboardValue((format, value) async {
    //debugger();
    if (formats.contains(format)) {
      if (value is String) {
        result.add(value);
      }
    }
  });
  return result;
}

/// 读取剪切板文件
@allPlatformFlag
Future<NamedUri?> readClipboardUri() =>
    readClipboardValue(Formats.uri, Formats.uri);

/// 读取剪切板文件
@allPlatformFlag
Future<Uri?> readClipboardFileUri() =>
    readClipboardValue(Formats.fileUri, Formats.fileUri);

/// 读取剪切板文件列表
@allPlatformFlag
Future<List<Uri>> readClipboardFileUriList({
  List<DataFormat> formats = const [Formats.fileUri],
}) async {
  final List<Uri> result = [];
  await eachReadClipboardValue((format, value) {
    //debugger();
    if (formats.contains(format)) {
      if (value is Uri) {
        result.add(value);
      }
    }
  });
  return result;
}

//MARK: - write

/// 写入剪切板数据
@allPlatformFlag
Future<void> writeClipboardValue(DataWriterItem item) async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return; // Clipboard API is not supported on this platform.
  }
  /*final item = DataWriterItem();
  item.add(Formats.htmlText(""));*/

  /*final item = DataWriterItem();
  item.add(Formats.htmlText('<b>HTML text</b>'));
  item.add(Formats.plainText('plain text'));
  item.add(Formats.png(imageData));*/

  return await clipboard.write([item]);
}

/// 写入图片到剪切板
@allPlatformFlag
Future<void> writeClipboardImage(UiImage? image) async {
  final data = await image?.toByteData(format: UiImageByteFormat.png);
  final bytes = data?.buffer.asUint8List();

  if (bytes == null) {
    return;
  }

  final item = DataWriterItem();
  item.add(Formats.png(bytes));

  return await writeClipboardValue(item);
}

/// 写入文本到剪切板
@allPlatformFlag
Future<void> writeClipboardText(String? text) async {
  if (text == null) {
    return;
  }

  final item = DataWriterItem();
  item.add(Formats.plainText(text));

  return await writeClipboardValue(item);
}

/// 写入html文本到剪切板
@allPlatformFlag
Future<void> writeClipboardHtmlText(String? text) async {
  if (text == null) {
    return;
  }

  final item = DataWriterItem();
  item.add(Formats.htmlText(text));

  return await writeClipboardValue(item);
}

//MARK: - clear

/// 清空剪切板
@allPlatformFlag
Future<void> clearSystemClipboard() async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return; // Clipboard API is not supported on this platform.
  }
  return await clipboard.write([]);
}
