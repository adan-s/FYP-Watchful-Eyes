// post_model.dart
class PostModel {
  final String id;
  final String username;
  final String description;
  final String imageUrl;

  PostModel({
    required this.id,
    required this.username,
    required this.description,
    required this.imageUrl,
  });

  // Convert PostModel to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Create PostModel from Map retrieved from the database
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      username: map['username'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }
}
