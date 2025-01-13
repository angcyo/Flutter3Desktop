part of '../../flutter3_desktop_core.dart';

///
/// @author <a href="mailto:angcyo@126.com">angcyo</a>
/// @date 2025/01/13
///
/// https://pub.dev/packages/super_clipboard

/// 读取剪切板数据
@allPlatformFlag
Future<T?> readClipboardValue<T extends Object>(
    DataFormat format, ValueFormat<T> valueFormat) async {
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

/// 读取剪切板图片
@allPlatformFlag
Future<UiImage?> readClipboardImage() async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return null; // Clipboard API is not supported on this platform.
  }
  final reader = await clipboard.read();
  if (reader.canProvide(Formats.png)) {
    UiImage? image;
    await asyncFuture((completer) {
      reader.getFile(Formats.png, (file) async {
        // Do something with the PNG image
        //final stream = file.getStream();
        final bytes = await file.readAll();
        image = await bytes.toImage();
        completer.complete(image);
      });
    });
    return image;
  }
  return null;
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

/// 读取剪切板文件
@allPlatformFlag
Future<Uri?> readClipboardUri() =>
    readClipboardValue(Formats.fileUri, Formats.fileUri);

//--

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

//--

/// 清空剪切板
@allPlatformFlag
Future<void> clearSystemClipboard() async {
  final clipboard = SystemClipboard.instance;
  if (clipboard == null) {
    return; // Clipboard API is not supported on this platform.
  }
  return await clipboard.write([]);
}
