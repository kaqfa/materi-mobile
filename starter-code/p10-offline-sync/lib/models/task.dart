/// Model offline-first: tiap baris tahu status sinkronnya sendiri.
library;

enum SyncState { synced, pending }

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.updatedAt,
    this.completed = false,
    this.syncState = SyncState.synced,
  });

  final String id;
  final String title;
  final bool completed;

  /// Penentu last-write-wins saat konflik.
  final DateTime updatedAt;
  final SyncState syncState;

  Task copyWith({
    String? title,
    bool? completed,
    DateTime? updatedAt,
    SyncState? syncState,
  }) =>
      Task(
        id: id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
        updatedAt: updatedAt ?? this.updatedAt,
        syncState: syncState ?? this.syncState,
      );

  Map<String, Object?> toRow() => {
        'id': id,
        'title': title,
        'completed': completed ? 1 : 0,
        'updated_at': updatedAt.toIso8601String(),
        'sync_state': syncState.name,
      };

  factory Task.fromRow(Map<String, Object?> row) => Task(
        id: row['id']! as String,
        title: row['title']! as String,
        completed: (row['completed']! as int) == 1,
        updatedAt: DateTime.parse(row['updated_at']! as String),
        syncState: SyncState.values.byName(row['sync_state']! as String),
      );
}
