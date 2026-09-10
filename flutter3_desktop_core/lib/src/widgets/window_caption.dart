// import 'package:flutter/material.dart';
// import 'package:flutter3_desktop_core/src/core/native_api_ex.dart';
// import 'package:flutter3_desktop_core/src/widgets/window_caption_button.dart';
//
// import 'drag_to_move_area.dart';
//
// const double kWindowCaptionHeight = 32;
//
// /// A widget to simulate the title bar of windows 11.
// ///
// /// {@tool snippet}
// ///
// /// ```dart
// /// Scaffold(
// ///   appBar: PreferredSize(
// ///     child: WindowCaption(
// ///       brightness: Theme.of(context).brightness,
// ///       title: Text('window_manager_example'),
// ///     ),
// ///     preferredSize: const Size.fromHeight(kWindowCaptionHeight),
// ///   ),
// /// )
// /// ```
// /// {@end-tool}
// class WindowCaption extends StatefulWidget {
//   const WindowCaption({
//     super.key,
//     this.title,
//     this.backgroundColor,
//     this.brightness,
//   });
//
//   final Widget? title;
//   final Color? backgroundColor;
//   final Brightness? brightness;
//
//   @override
//   State<WindowCaption> createState() => _WindowCaptionState();
// }
//
// class _WindowCaptionState extends State<WindowCaption>
//     with NativeWindowEventStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color:
//             widget.backgroundColor ??
//             (widget.brightness == Brightness.dark
//                 ? const Color(0xff1C1C1C)
//                 : Colors.transparent),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: DragToMoveArea(
//               child: SizedBox(
//                 height: double.infinity,
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.only(left: 16),
//                       child: DefaultTextStyle(
//                         style: TextStyle(
//                           color: widget.brightness == Brightness.light
//                               ? Colors.black.withValues(alpha: 0.8956)
//                               : Colors.white,
//                           fontSize: 14,
//                         ),
//                         child: widget.title ?? Container(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           WindowCaptionButton.minimize(
//             brightness: widget.brightness,
//             onPressed: () async {
//               bool isMinimized = $nativeCurrentWindow?.isMinimized == true;
//               if (isMinimized) {
//                 $nativeCurrentWindow?.restore();
//               } else {
//                 $nativeCurrentWindow?.minimize();
//               }
//             },
//           ),
//           FutureBuilder<bool>(
//             future: () async {
//               return $nativeCurrentWindow?.isMaximized == true;
//             }(),
//             builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//               if (snapshot.data == true) {
//                 return WindowCaptionButton.unmaximize(
//                   brightness: widget.brightness,
//                   onPressed: () {
//                     $nativeCurrentWindow?.unmaximize();
//                   },
//                 );
//               }
//               return WindowCaptionButton.maximize(
//                 brightness: widget.brightness,
//                 onPressed: () {
//                   $nativeCurrentWindow?.maximize();
//                 },
//               );
//             },
//           ),
//           WindowCaptionButton.close(
//             brightness: widget.brightness,
//             onPressed: () {
//               $nativeCurrentWindow?.isClosable = true;
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void onWindowEventMixin(Object event) {
//     super.onWindowEventMixin(event);
//     if (event.isWindowMaximizedEvent || event.isWindowRestoredEvent) {
//       setState(() {});
//     }
//   }
// }
