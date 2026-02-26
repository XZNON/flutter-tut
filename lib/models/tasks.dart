class Task {
  final int id;
  final String title;
  final String description;

  Task({required this.id, required this.title, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      title: json["title"],
      description: json["description"],
    );
  }
}
