/// Model Task + serialisasi JSON — kontrak data dengan REST API.
library;

class Task {
  final int id;
  final String title;
  final bool completed;

  const Task({required this.id, required this.title, this.completed = false});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: (json['id'] as num).toInt(),
        title: (json['title'] ?? '') as String,
        completed: (json['completed'] ?? false) as bool,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
      }; // id dibuat server, tidak dikirim saat create
}
