import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/authentication/controllers/profile_controller.dart';
import 'package:fyp/authentication/models/user_model.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/post-new-item.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../authentication/authentication_repo.dart';
import 'AddContact.dart';
import 'blogs.dart';
import 'login_screen.dart';
import 'map.dart';

class CommunityForumPage extends StatelessWidget {
  const CommunityForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF769DC9),
                    Color(0xFF769DC9),
                  ],
                ),
              ),
            ),
            title: Text(
              'Community Forum',
              style: TextStyle(fontFamily: 'outfit', color: Colors.white),

            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            leading: ResponsiveAppBarActions(),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                colors: [
                  Color(0xFF769DC9),
                  Color(0xFF769DC9),
                  Color(0xFF7EA3CA),
                  Color(0xFF769DC9),
                  Color(0xFFCBE1EE),
                ],
              ),
            ),
            child: HomeTab(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostNewItemPage()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

//HomeTab
Future<List<Post>> fetchPosts() async {
  List<Post> posts = [];
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('items').get();

  for (QueryDocumentSnapshot doc in snapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Comment> comments = await fetchComments(data['id'] ?? '');

    posts.add(
      Post(
        postId: data['id'] ?? '',
        username: data['username'] ?? 'Unknown User',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        likes: data['likes'] ?? 0,
        comments: comments,
      ),
    );
  }

  return posts;
}

Future<List<Comment>> fetchComments(String postId) async {
  print("Fetching comments for post with ID: $postId");
  QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
      .collection('items')
      .doc(postId)
      .collection('comments')
      .get();

  print("Fetched ${commentSnapshot.docs.length} comments");

  return commentSnapshot.docs.map((commentDoc) {
    Map<String, dynamic> commentData =
        commentDoc.data() as Map<String, dynamic>;
    return Comment(
      username: commentData['username'] ?? '',
      text: commentData['text'] ?? '',
    );
  }).toList();
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<Post> posts = snapshot.data ?? [];

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        );
      },
    );
  }
}

class Post {
  final String postId;
  final String username;
  final String description;
  final String imageUrl;
  int likes;
  final List<Comment> comments;

  Post({
    required this.postId,
    required this.username,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });
}

class Comment {
  final String username;
  final String text;

  Comment({
    required this.username,
    required this.text,
  });
}

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double marginHorizontal = screenWidth > 600 ? 106.0 : 16.0;

    return Center(
      child: Card(
        margin:
            EdgeInsets.symmetric(vertical: 28.0, horizontal: marginHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(widget.post.username),
              subtitle: Text(widget.post.description),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;

                // Adjust the post width based on the available width
                double postWidth = maxWidth > 600 ? 400 : maxWidth;

                return Container(
                  width: postWidth,
                  child: Image.network(
                    widget.post.imageUrl,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up_alt : Icons.thumb_up,
                          color: isLiked ? Colors.blue : null,
                        ),
                        onPressed: () {
                          // Handle like button press
                          handleLikeButton();
                        },
                      ),
                      Text('${widget.post.likes} Likes'),
                      // Display fetched likes count
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.comment,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          showCommentsDialog(context);
                        },
                      ),
                      Text('${widget.post.comments.length} Comments'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleLikeButton() {
    String postId = widget.post.postId;
    print('Post ID: $postId');

    if (isLiked) {
      // User has already liked the post, remove like
      setState(() {
        isLiked = false;
        widget.post.likes--;
      });
      removeLike(postId);
    } else {
      // User hasn't liked the post, add like
      setState(() {
        isLiked = true;
        widget.post.likes++;
      });
      addLike(postId);
    }
  }

  void addLike(String postId) {
    FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: postId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'likes': FieldValue.increment(1)});
      });
    });
  }

  void removeLike(String postId) {
    FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: postId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'likes': FieldValue.increment(-1)});
      });
    });
  }

  // Function to show comments in a dialog with a text field for adding a comment
  void showCommentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments'),
          content: Column(
            children: [
              CommentSection(comments: widget.post.comments),
              SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                String newCommentText = commentController.text;
                if (newCommentText.isNotEmpty) {
                  Comment newComment = Comment(
                    username: widget.post.username,
                    text: newCommentText,
                  );
                  setState(() {
                    widget.post.comments.add(newComment);
                  });

                  final ProfileController userController =
                      Get.put(ProfileController());
                  saveComment(widget.post.postId, newComment, userController);
                  commentController.clear();
                }
                setState(() {});
              },
              child: Text('Add Comment'),
            ),
          ],
        );
      },
    );
  }

  void saveComment(
      String postId, Comment comment, ProfileController userController) async {
    try {
      usermodel currentUser = await userController.getUserData();
      FirebaseFirestore.instance
          .collection('items')
          .doc(postId)
          .collection('comments')
          .add({
        'username': currentUser.username,
        'text': comment.text,
      });
    } catch (error) {
      print('Error saving comment: $error');
    }
  }
}

class CommentSection extends StatelessWidget {
  final List<Comment> comments;

  CommentSection({required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(),
        for (var comment in comments)
          CommentTile(username: comment.username, comment: comment.text),
      ],
    );
  }
}

class CommentTile extends StatelessWidget {
  final String username;
  final String comment;

  const CommentTile({Key? key, required this.username, required this.comment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(username),
      subtitle: Text(comment),
    );
  }
}

class ResponsiveAppBarActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: [
        _buildNavBarItem("Home", Icons.home, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserPanel()),
          );
        }),
        if (!kIsWeb) // Check if the app is not running on the web
          _buildNavBarItem("Community Forum", Icons.group, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CommunityForumPage()),
            );
          }),
        if (!kIsWeb) // Check if the app is not running on the web
          _buildNavBarItem("Emergency Contact", Icons.phone, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddContact()),
            );
          }),
        _buildNavBarItem("Map", Icons.map, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapPage()),
          );
        }),
        _buildNavBarItem("Safety Directory", Icons.book, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SafetyDirectory()),
          );
        }),
        _buildNavBarItem("Crime Registeration", Icons.report, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CrimeRegistrationForm()),
          );
        }),
        _buildNavBarItem("Blogs", Icons.newspaper, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BlogPage()),
          );
        }),
        _buildIconButton(
          icon: Icons.person,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfilePage()),
            );
          },
        ),
        _buildNavBarItem("Logout", Icons.logout, () async {
          bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );

          if (confirmed == true) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text("Logging out..."),
                    ],
                  ),
                );
              },
              barrierDismissible: false,
            );

            try {
              await AuthenticationRepository.instance.logout();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } catch (e) {
              print("Logout error: $e");
              Navigator.pop(context);
            }
          }
        }),
      ],
    );
  }

  Widget _buildNavBarItem(String title, IconData icon, VoidCallback onPressed) {
    return kIsWeb
        ? IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
            tooltip: title,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(icon, color: Color(0xFF769DC9)),
                onPressed: onPressed,
                tooltip: title,
              ),
              GestureDetector(
                onTap: onPressed,
                child: Text(
                  title,
                  style: TextStyle(color: Color(0xFF769DC9)),
                ),
              ),
            ],
          );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return kIsWeb
        ? IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          )
        : InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(icon, color: Color(0xFF769DC9)),
                  onPressed: null, // Disable IconButton onPressed
                  tooltip: "User Profile",
                ),
                Text(
                  "User Profile",
                  style: TextStyle(color: Color(0xFF769DC9)),
                ),
              ],
            ),
          );
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;

  ResponsiveRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 600)
          ...children.map((child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: child,
              )),
        if (MediaQuery.of(context).size.width <= 600)
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return children
                  .map((child) => PopupMenuItem(
                        child: child,
                      ))
                  .toList();
            },
            icon: Icon(Icons.menu, color: Colors.white),
            color: Colors.white,
          ),
      ],
    );
  }
}
