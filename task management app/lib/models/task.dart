enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String? description;
  bool isCompleted;
  final TaskPriority priority;
  final String category;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = 'General',
    this.dueDate,
  });

  // Method to toggle completion status
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  // Support for JSON serialization (needed for persistent storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      priority: TaskPriority.values[json['priority'] ?? 1],
      category: json['category'] ?? 'General',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }
}
