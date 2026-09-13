/// Model domain StudyTracker — latihan inti P02.
///
/// Kontrak field sudah final; kerjakan semua `TODO(student)`.
/// Setelah semua TODO selesai, `flutter test` harus hijau.
library;

enum Priority { low, medium, high }

extension PriorityLabel on Priority {
  String get label => switch (this) {
        Priority.low => 'Rendah',
        Priority.medium => 'Sedang',
        Priority.high => 'Tinggi',
      };
}

/// Mixin untuk entitas yang bisa diberi label/tag.
mixin Taggable {
  List<String> get tags;

  bool hasTag(String tag) => tags.any((t) => t.toLowerCase() == tag.toLowerCase());
}

class Task with Taggable {
  final String id;
  final String title;
  final String description;
  final String category;
  final Priority priority;
  final DateTime? dueDate; // nullable: tugas boleh tanpa deadline
  final bool completed;

  @override
  final List<String> tags;

  // Contoh selesai — constructor named parameter dengan nilai default.
  // TODO(student) P02-1: pelajari pola ini ({required, default, const list}),
  // lalu tulis ulang versimu di catatan — akan dipakai untuk tugas P02.
  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'Umum',
    this.priority = Priority.medium,
    this.dueDate,
    this.completed = false,
    this.tags = const [],
  });

  /// Factory dari JSON map (simulasi payload API).
  // TODO(student) P02-2: implementasikan fromJson.
  // Hint: Priority.values.byName(json['priority'] as String),
  // dueDate hanya di-parse bila tidak null.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] ?? '') as String,
      category: (json['category'] ?? 'Umum') as String,
      priority: Priority.values.byName(json['priority'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      completed: (json['completed'] ?? false) as bool,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
    );
  }

  /// Apakah tugas terlambat: sudah lewat dueDate tapi belum selesai.
  // TODO(student) P02-3: implementasikan isOverdue.
  // Tugas tanpa dueDate atau sudah completed tidak pernah terlambat.
  bool get isOverdue {
    if (dueDate == null || completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Salinan dengan sebagian field diganti (immutable style).
  // TODO(student) P02-4: implementasikan copyWith.
  Task copyWith({
    String? title,
    String? description,
    String? category,
    Priority? priority,
    DateTime? dueDate,
    bool? completed,
    List<String>? tags,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      tags: tags ?? this.tags,
    );
  }

  /// Serialisasi ke JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'priority': priority.name,
        'dueDate': dueDate?.toIso8601String(),
        'completed': completed,
        'tags': tags,
      };

  @override
  String toString() => 'Task($id, $title, ${priority.label})';
}
