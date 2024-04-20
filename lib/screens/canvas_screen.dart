// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';
// import 'package:techagogics_open_core/services/supabase_manager.dart';

// extension RandomColor on Color {
//   static Color getRandomFromId(String id) {
//     final seed = utf8.encode(id).reduce((value, element) => value + element);

//     return Color((Random(seed).nextDouble() * 0xFFFFFF).toInt() << 0)
//         .withOpacity(1.0);
//   }
// }

// class CanvasPainter extends CustomPainter {
//   final Map<String, UserCursor> userCursors;

//   CanvasPainter({required this.userCursors});

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final cursor in userCursors.values) {
//       final position = cursor.position;
//       canvas.drawPath(
//           Path()
//             ..moveTo(position.dx, position.dy)
//             ..lineTo(position.dx + 14.29, position.dy + 44.84)
//             ..lineTo(position.dx + 20.35, position.dy + 25.93)
//             ..lineTo(position.dx + 39.85, position.dy + 24.51)
//             ..lineTo(position.dx, position.dy),
//           Paint()..color = cursor.color);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class UserCursor {
//   final String id;
//   final Offset position;
//   final Color color;

//   UserCursor({
//     required this.id,
//     required this.position,
//   }) : color = RandomColor.getRandomFromId(id);

//   UserCursor.fromJson(Map<String, dynamic> json)
//       : position = Offset(json['position']['x'], json['position']['y']),
//         color = RandomColor.getRandomFromId(json['id']),
//         id = json['id'];

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'position': {'x': position.dx, 'y': position.dy},
//       };
// }

// class CanvasPage extends StatefulWidget {
//   const CanvasPage({Key? key}) : super(key: key);

//   @override
//   _CanvasPageState createState() => _CanvasPageState();
// }

// class _CanvasPageState extends State<CanvasPage> {
//   final Map<String, UserCursor> _userCursors = {};

//   late final String _myId;

//   late final RealtimeChannel _canvasChannel;

//   @override
//   void initState() {
//     super.initState();
//     _myId = const Uuid().v4();

//     _canvasChannel = SupabaseManager.client.channel('canvas').onBroadcast(
//         event: 'canvas',
//         callback: (payload) {
//           final cursor = UserCursor.fromJson(payload['cursor']);
//           setState(() {
//             _userCursors[cursor.id] = cursor;
//             if (kDebugMode) {
//               print('test');
//             }
//           });
//         });
//   }

//   @override
//   void dispose() {
//     _canvasChannel.unsubscribe();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MouseRegion(
//         onHover: (event) {
//           final myCursor = UserCursor(id: _myId, position: event.position);
//           _canvasChannel.sendBroadcastMessage(
//             event: 'canvas',
//             payload: {'cursor': myCursor.toJson()},
//           );
//         },
//         child: CustomPaint(
//           size: MediaQuery.of(context).size,
//           painter: CanvasPainter(userCursors: _userCursors),
//         ),
//       ),
//     );
//   }
// }
