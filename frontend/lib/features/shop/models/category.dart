class CategoryModel {
  final String id;
  final String categoryName;
  final String? categoryDescription;
  final String? icon;
  final String? image;
  final String? placeholder;
  final bool active;
  final String? parentId;

  CategoryModel({
    required this.id,
    required this.categoryName,
    this.categoryDescription,
    this.icon,
    this.image,
    this.placeholder,
    required this.active,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryDescription: json['categoryDescription'],
      icon: json['icon'],
      image: json['image'],
      placeholder: json['placeholder'],
      active: json['active'] ?? true,
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'categoryDescription': categoryDescription,
      'icon': icon,
      'image': image,
      'placeholder': placeholder,
      'active': active,
      'parentId': parentId,
    };
  }
}
