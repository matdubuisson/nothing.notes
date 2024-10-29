class Task {
  final String id;
  final String title;
  final DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  });

  // Convert Task to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Create Task from Map
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'],
    );
  }
}
