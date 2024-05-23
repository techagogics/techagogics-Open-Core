import 'dart:ui';
import 'package:uuid/uuid.dart';
import '../../utilities/realtime.dart';

/// Objects that are being synced in realtime over broadcast
///
/// Includes score and game logic objects (such as time)
abstract class SyncedObject {
  /// UUID unique identifier of the object
  final String id;

  factory SyncedObject.fromJson(Map<String, dynamic> json) {
    final objectType = json['object_type'];
    if (objectType == UserScore.type) {
      return UserScore.fromJson(json);
    } else {
      return GameObject.fromJson(json);
    }
  }

  SyncedObject({
    required this.id,
  });

  Map<String, dynamic> toJson();
}

/// Data model for the cursors displayed on the canvas.
class UserScore extends SyncedObject {
  static String type = 'score';

  final Color color;
  final int? score;

  UserScore({
    required super.id,
    required this.score,
  }) : color = RandomColor.getRandomFromId(id);

  UserScore.fromJson(Map<String, dynamic> json)
      : score = json['score'],
        color = RandomColor.getRandomFromId(json['id']),
        super(id: json['id']);

  @override
  Map<String, dynamic> toJson() {
    return {
      'object_type': type,
      'id': id,
      if (score != null) 'score': score,
    };
  }
}

/// Base model for any game logic objects such as time.
class GameObject extends SyncedObject {
  static String type = 'game_object';
  final DateTime? time;

  GameObject({
    required super.id,
    required this.time,
  });

  GameObject.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        super(id: json['id']);

  /// Constructor to be used when first starting to create a game object
  GameObject.createNew(this.time)
      : super(
          id: const Uuid().v4(),
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'object_type': type,
      'id': id,
      if (time != null) 'time': DateTime.now().toIso8601String(),
    };
  }
}
