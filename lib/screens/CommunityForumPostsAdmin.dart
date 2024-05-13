import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/usermanagement.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../authentication/authentication_repo.dart';
import 'CrimeDataPage.dart';
import 'admindashboard.dart';
import 'analyticsandreports.dart';
import 'login_screen.dart';

class CommunityForumPostsAdmin extends StatelessWidget {
  const CommunityForumPostsAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF769DC9),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Community Forum Posts ',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF769DC9),
                  Color(0xFF769DC9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF769DC9),
                        Color(0xFF769DC9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: GestureDetector(
                          child: Image.asset(
                            "assets/admin.png",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Watchful Eyes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'Admin Dashboard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard, color: Colors.white),
                  title: Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboard()),
                    );
                  },
                ),
                Divider(
                  color: Colors.white,
                ),
                if (kIsWeb)
                  ListTile(
                    leading:
                        Icon(Icons.supervised_user_circle, color: Colors.white),
                    title: Text(
                      'User Management',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserManagement()),
                      );
                    },
                  ),
                if (kIsWeb)
                  ListTile(
                    leading: Icon(Icons.analytics, color: Colors.white),
                    title: Text(
                      'Analytics and Reports',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyticsAndReports()),
                      );
                    },
                  ),
                if (kIsWeb)
                  Divider(
                    color: Colors.white,
                  ),
                if (!kIsWeb)
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.white),
                    title: Text(
                      'Community Forum Posts',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                if (!kIsWeb)
                  ListTile(
                    leading: Icon(Icons.warning, color: Colors.white),
                    title: Text(
                      'Registered Complaints',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CrimeDataPage()),
                      );
                    },
                  ),
                if (!kIsWeb)
                  Divider(
                    color: Colors.white,
                  ),
                GestureDetector(
                  onTap: () async {
                    bool confirmLogout =
                        await _showLogoutConfirmationDialog(context);

                    if (confirmLogout) {
                      await AuthenticationRepository.instance.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.white),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
              ],
            ),
          ),
          child: HomeTab(),
        ),
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logout Confirmation'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true); // Yes, logout

                    // Perform logout
                    await AuthenticationRepository.instance.logout();

                    // Redirect to the login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child:
                      const Text('Yes', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child:
                      const Text('No', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
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
                    child: kIsWeb
                        ? Image.network(
                            widget.post.imageUrl,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.4,
                          )
                        : Image.network(
                            widget.post.imageUrl,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.4,
                          ));
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
                  Row(children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        // Handle delete button press
                        handleDeleteButton();
                      },
                    ),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleDeleteButton() {
    String postId = widget.post.postId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                deletePost(postId);
              },
              child: Text('Yes', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void deletePost(String postId) {
    FirebaseFirestore.instance
        .collection('items')
        .where('id', isEqualTo: postId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete().then((value) {
          // Check if the widget is still mounted before calling setState
          if (mounted) {
            setState(() {
              Get.snackbar(
                "Congratulations",
                "Post deleted successfully.",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            });

            // Refresh the page by navigating back to the same page
            Get.to(() => CommunityForumPostsAdmin());
          }
        }).catchError((error) {
          // Check if the widget is still mounted before calling setState
          if (mounted) {
            // Handle errors that may occur during deletion
            print('Error deleting post: $error');
            // Show a snackbar with the error message
            Get.snackbar(
              "Error",
              "Post not deleted.",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
      });
    });
  }

  // Function to show comments in a dialog
  void showCommentsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            children: [
              CommentSection(comments: widget.post.comments),
              SizedBox(height: 10),
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
          ],
        );
      },
    );
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
        Text(
          'Comments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
