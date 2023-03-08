class JsonModelPost<ConnectionSettings> {
  final int id;
  final String name;

  JsonModelPost({
    required this.id,
    required this.name,
  });

  factory JsonModelPost.fromJson(Map json) {
    return JsonModelPost(
      id: json['id'],
      name: json['name'],
    );
  }

  Map toJson() {
    return {
      'id': name,
      'name': name,

    };
  }
}
