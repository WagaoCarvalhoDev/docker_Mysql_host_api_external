class JsonModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  JsonModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory JsonModel.fromJson(Map json) {
    return JsonModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
