import 'package:flutter/material.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/post-new-item.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';

import 'blogs.dart';
import 'map.dart';

class CommunityForumPage extends StatelessWidget {
  const CommunityForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF000104), Color(0xFF0E121B), Color(0xFF141E2C), Color(0xFF18293F), Color(0xFF193552)],
              ),
            ),
          ),
          title: Text(
            'Community Forum',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'outfit'),
          ),
          centerTitle: true,
          actions: [
            ResponsiveAppBarActions(),
          ],

          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home, color: Colors.white)),
              Tab(icon: Icon(Icons.people, color: Colors.white)),
              Tab(icon: Icon(Icons.article, color: Colors.white))
            ],
            labelColor: Colors.white,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF000104), Color(0xFF0E121B), Color(0xFF141E2C), Color(0xFF18293F), Color(0xFF193552)],
            ),
          ),
          child: TabBarView(
            children: [
              HomeTab(),
              Center(
                child: const Text('People Page'),
              ),
              Center(
                child: const Text('My Page'),
              ),
            ],
          ),
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
    );
  }
}


class HomeTab extends StatelessWidget {
  final List<Post> posts = [
    Post(
      username: 'John Doe',
      description: 'This is a sample post description.',
      imageUrl: 'https://st.depositphotos.com/1444927/1881/i/450/depositphotos_18812045-stock-photo-broken-window-crime-scene.jpg',
    ),
    Post(
      username: 'Alice',
      description: 'This is a sample post description.',
      imageUrl: 'https://st.depositphotos.com/1444927/1881/i/450/depositphotos_18812045-stock-photo-broken-window-crime-scene.jpg',
    ),
    Post(
      username: 'Sara',
      description: 'This is a sample post description.',
      imageUrl: 'https://st.depositphotos.com/1444927/1881/i/450/depositphotos_18812045-stock-photo-broken-window-crime-scene.jpg',
    ),
    Post(
      username: 'Suzi',
      description: 'This is a sample post description.',
      imageUrl: 'https://st.depositphotos.com/1444927/1881/i/450/depositphotos_18812045-stock-photo-broken-window-crime-scene.jpg',
    ),
    // Add more dummy posts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}

class Post {
  final String username;
  final String description;
  final String imageUrl;

  Post({
    required this.username,
    required this.description,
    required this.imageUrl,
  });
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double marginHorizontal = screenWidth > 600 ? 106.0 : 16.0;

    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 28.0, horizontal: marginHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                ),
              ),
              title: Text(post.username),
              subtitle: Text(post.description),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth = constraints.maxWidth;

                // Adjust the post width based on the available width
                double postWidth = maxWidth > 600 ? 400 : maxWidth;

                return Container(
                  width: postWidth,
                  child: Image.network(
                    post.imageUrl,
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
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          // Handle like button press
                          // For now, let's print a message to the console
                          print('Liked!');
                        },
                      ),
                      Text('10 Likes'), // Hardcoded likes count
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          // Handle comment button press
                          // For now, show the comments dialog
                          showCommentsDialog(context);
                        },
                      ),
                      Text('5 Comments'), // Hardcoded comments count
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Handle share button press
                      // For now, let's print a message to the console
                      print('Shared!');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show comments in a dialog with a text field for adding a comment
  void showCommentsDialog(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments'),
          content: Column(
            children: [
              CommentSection(),
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
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add new comment logic here
                String newComment = commentController.text;
                if (newComment.isNotEmpty) {
                  // Add the new comment to the list or perform the desired action
                  print('Adding a new comment: $newComment');
                  commentController.clear();
                }
              },
              child: Text('Add Comment'),
            ),
          ],
        );
      },
    );
  }
}


// CommentSection widget to display comments
class CommentSection extends StatelessWidget {
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
        CommentTile(username: 'User4', comment: 'Amazing!'),
        CommentTile(username: 'User5', comment: 'I love it!'),
        CommentTile(username: 'User6', comment: 'Awesome work!'),
      ],
    );
  }
}

// CommentTile widget to display a single comment
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
        _buildNavBarItem("Community Forum", Icons.group, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityForumPage()),
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
            MaterialPageRoute(builder: (context) => const CrimeRegistrationForm()),
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
      ],
    );
  }

  Widget _buildNavBarItem(String title, IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: title,
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
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
            icon: Icon(Icons.more_vert, color: Colors.white),
            color: Colors.black,
          ),
      ],
    );
  }
}
