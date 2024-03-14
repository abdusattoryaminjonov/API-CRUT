
class PostRes {
  int? id;
  String? title;
  String? body;
  String? userId;

  PostRes({this.id, this.title, this.body, this.userId});

  PostRes.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        body = json['body'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'userId': userId,
  };
}