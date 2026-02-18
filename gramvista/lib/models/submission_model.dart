class Submission {
  final String id;
  final String name;
  final String description;
  final String region;
  final String theme;
  final List<String> tags;
  final String? imageUrl;
  final bool isFeatured;
  final bool isAdminApproved;
  final String userId;

  Submission({
    required this.id,
    required this.name,
    required this.description,
    required this.region,
    required this.theme,
    required this.tags,
    required this.userId,
    this.imageUrl,
    this.isFeatured = false,
    this.isAdminApproved = false,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      region: json['region'],
      theme: json['theme'],
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['image_url'],
      isFeatured: json['is_featured'] ?? false,
      isAdminApproved: json['is_admin_approved'] ?? false,
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'region': region,
      'theme': theme,
      'tags': tags,
      'image_url': imageUrl,
      'is_featured': isFeatured,
      'is_admin_approved': isAdminApproved,
      'user_id': userId,
    };
  }
}
