class GetPostResponseModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  GetPostResponseModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  GetPostResponseModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return GetPostResponseModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory GetPostResponseModel.fromJson(Map<String, dynamic> json) {
    return GetPostResponseModel(
      userId: json['userId'] as int?,
      id: json['id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
    );
  }

  static bool isValid(Map<String, dynamic> json) {
    return json.containsKey('userId') &&
        (json['userId'] == null || json['userId'] is int) &&
        json.containsKey('id') &&
        (json['id'] == null || json['id'] is int) &&
        json.containsKey('title') &&
        (json['title'] == null || json['title'] is String) &&
        json.containsKey('body') &&
        (json['body'] == null || json['body'] is String);
  }

  @override
  String toString() =>
      "GetPostResponseModel(userId: $userId,id: $id,title: $title,body: $body)";

  @override
  int get hashCode => Object.hash(userId, id, title, body);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetPostResponseModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          id == other.id &&
          title == other.title &&
          body == other.body;
}
