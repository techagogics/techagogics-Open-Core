enum BroadcastEvent { canvas, quiz }

extension BroadcastEventExtension on BroadcastEvent {
  String get name {
    switch (this) {
      case BroadcastEvent.canvas:
        return 'canvas';
      case BroadcastEvent.quiz:
        return 'quiz';
      default:
        throw UnimplementedError('Unknown event type: $this');
    }
  }
}

enum Channel { canvas, quiz }

extension ChannelExtension on Channel {
  String get name {
    switch (this) {
      case Channel.canvas:
        return 'canvas';
      case Channel.quiz:
        return 'quiz';
      default:
        throw UnimplementedError('Unknown channel name: $this');
    }
  }
}

enum StorageBucket { canvas }

extension StorageBucketExtension on StorageBucket {
  String get name {
    switch (this) {
      case StorageBucket.canvas:
        return 'canvas_objects';
      default:
        throw UnimplementedError('Unknown storage bucket name: $this');
    }
  }
}
