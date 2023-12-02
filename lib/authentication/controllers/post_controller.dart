// post_controller.dart

import '../../post_repository.dart';
import '../models/post_model.dart';

class PostController {
  final PostRepository _postRepository = MockPostRepository();

  Future<void> submitPostRequest(PostModel post) async {
    // Additional logic can be added here before submitting the request
    await _postRepository.submitPostRequest(post);
  }

  Future<List<PostModel>> getAllPosts() async {
    return _postRepository.getAllPosts();
  }
}
