class Post {
  String? id;
  String content;
  int department;
  DateTime? postedAt = DateTime.now();

  Post({
    this.id,
    required this.content,
    required this.department,
    DateTime? postedAt,
  }) : postedAt = postedAt ?? DateTime.now();

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      content: data["content"],
      department: data["department"],
      postedAt:
          data["postedAt"] != null ? DateTime.parse(data["postedAt"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "department": department,
      "postedAt": postedAt?.toIso8601String(),
    };
  }
}
