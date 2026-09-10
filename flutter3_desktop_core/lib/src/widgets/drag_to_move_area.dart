// import 'package:flutter/material.dart';
// import 'package:flutter3_desktop_core/src/core/native_api_ex.dart';
//
// /// A widget for drag to move window.
// ///
// /// When you have hidden the title bar, you can add this widget to move the window position.
// ///
// /// {@tool snippet}
// ///
// /// The sample creates a red box, drag the box to move the window.
// ///
// /// ```dart
// /// DragToMoveArea(
// ///   child: Container(
// ///     width: 300,
// ///     height: 32,
// ///     color: Colors.red,
// ///   ),
// /// )
// /// ```
// /// {@end-tool}
// class DragToMoveArea extends StatelessWidget {
//   const DragToMoveArea({super.key, required this.child});
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onPanStart: (details) {
//         $nativeCurrentWindow?.startDragging();
//       },
//       onDoubleTap: () async {
//         bool isMaximized = $nativeCurrentWindow?.isMaximized == true;
//         if (!isMaximized) {
//           $nativeCurrentWindow?.maximize();
//         } else {
//           $nativeCurrentWindow?.unmaximize();
//         }
//       },
//       child: child,
//     );
//   }
// }
