// import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techagogics_open_core/models/image_model.dart';
import 'supabase_manager.dart';

Future<List<Map<String, dynamic>>> fetchImages() async {
  try {
    final response = await SupabaseManager.client.from('images').select();

    if (response.isEmpty) {
      throw Exception('No images found');
    }

    return List<Map<String, dynamic>>.from(response);
  } catch (error) {
    throw Exception('Error fetching images: $error');
  }
}

Future<List<ImageModel>> fetchImagesAsModels() async {
  try {
    final List<Map<String, dynamic>> imageData = await fetchImages();
    // convert raw data in ImageModel objects
    return imageData.map((imageMap) => ImageModel.fromJson(imageMap)).toList();
  } catch (e) {
    throw Exception('Failed to load images: $e');
  }
}

Future<RealtimeChannel> joinChannel(String name) async {
  final supabase = SupabaseManager.client;

  return supabase.channel(name);
}

// void subscribeToChannelPresence() async {
//   // SupabaseManager.channel.onPresenceSync((_) {
//   //   final newState = SupabaseManager.channel.presenceState();
//   //   if (kDebugMode) {
//   //     print('sync: $newState');
//   //   }
//   // }).onPresenceJoin((payload) {
//   //   if (kDebugMode) {
//   //     print('join: $payload');
//   //   }
//   // }).onPresenceLeave((payload) {
//   //   if (kDebugMode) {
//   //     print('leave: $payload');
//   //   }
//   // }).subscribe();

//   // Track the user's status
//   final userStatus = {
//     'user': 'user-1',
//     'online_at': DateTime.now().toIso8601String()
//   };

//   final presenceTrackStatus =
//       await SupabaseManager.client.channel('lobby').track(userStatus);
//   if (kDebugMode) {
//     print('TrackStatus: $presenceTrackStatus');
//   }
// }

// subscribeToChannel() async {
//   SupabaseManager.client.channel('lobby').onPresenceSync((_) {
//     final newState = SupabaseManager.client.channel('lobby').presenceState();
//     if (kDebugMode) {
//       print('sync: $newState');
//     }
//   }).onPresenceJoin((payload) {
//     if (kDebugMode) {
//       print('join: $payload');
//     }
//   }).onPresenceLeave((payload) {
//     if (kDebugMode) {
//       print('leave: $payload');
//     }
//   }).subscribe((status, error) {
//     // Wait for successful connection
//     if (status != RealtimeSubscribeStatus.subscribed) {
//       return;
//     }

//     if (kDebugMode) {
//       print(status);
//     }
//   }).onBroadcast(
//       event: 'test',
//       callback: (payload) {
//         if (kDebugMode) {
//           print('Received message: $payload');
//         }
//       });

//   final userStatus = {
//     'user': 'user-${UniqueKey()}',
//     'online_at': DateTime.now().toIso8601String()
//   };

//   final presenceTrackStatus =
//       await SupabaseManager.client.channel('lobby').track(userStatus);
//   if (kDebugMode) {
//     print('TrackStatus: $presenceTrackStatus');
//   }
// }

// void sendBroadcastMessage(String message) async {
//   // Send a message once the client is subscribed
//   SupabaseManager.client.channel('lobby').sendBroadcastMessage(
//     event: 'test',
//     payload: {'message': message},
//   );
// }
