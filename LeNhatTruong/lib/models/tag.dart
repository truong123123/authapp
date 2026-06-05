class Tag {
  final String id;
  final String tagName;
  final String? icon;

  Tag({
    required this.id,
    required this.tagName,
    this.icon,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] ?? '',
      tagName: json['tagName'] ?? '',
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tagName': tagName,
      'icon': icon,
    };
  }
}
