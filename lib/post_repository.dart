// post_repository.dart

import 'authentication/models/post_model.dart';

abstract class PostRepository {
  Future<void> submitPostRequest(PostModel post);
  Future<List<PostModel>> getAllPosts();
}

class MockPostRepository implements PostRepository {
  List<PostModel> _posts = [];

  @override
  Future<void> submitPostRequest(PostModel post) async {
    // Implement submitting post requests to the in-memory database
    _posts.add(post);
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    // Implement fetching posts from the in-memory database
    return _posts;
  }
}
