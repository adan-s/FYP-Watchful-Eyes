import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'blogs.dart';
import 'community-forum.dart';
import 'map.dart';
import 'user-profile.dart';
import 'dart:ui' as ui;
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class UserPanel extends StatefulWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'WatchfulEyes',
              style: TextStyle(color: Colors.white),
            ),
            ResponsiveAppBarActions(),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Safety Paragraph and Image
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF769DC9),
                          Color(0xFF769DC9),
                          Color(0xFF7EA3CA),
                          Color(0xFF769DC9),
                          Color(0xFFCBE1EE),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: Text(
                                        'Safety at Your Service',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'outfit'),
                                      )
                                          .animate()
                                          .fade(duration: 2000.ms)
                                          .slide(),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      kIsWeb
                                          ? "Welcome to 'Watchful Eyes' - "
                                              "Step into a new era of community safety with 'Watchful Eyes,'"
                                              " a groundbreaking crime reporting system designed to revolutionize "
                                              "the way we address security concerns. In the face of the traditionally "
                                              "challenging and disheartening process of reporting crimes—with its inherent "
                                              "complexities and concerns about law enforcement. 'Watchful Eyes' emerges as a beacon of change."
                                              " Our system is committed to simplifying and streamlining crime reporting, fostering "
                                              "enhanced police understanding, and, most importantly, elevating overall community safety. "
                                              "Trust in law enforcement is paramount, and 'Watchful Eyes' addresses this by providing a "
                                              "user-friendly platform, offering a seamless and efficient reporting experience."
                                          : "Welcome to 'Watchful Eyes' - "
                                              "Step into a new era of community safety with 'Watchful Eyes,'"
                                              " a groundbreaking crime reporting system designed to revolutionize "
                                              "the way we address security concerns. In the face of the traditionally "
                                              "challenging and disheartening process of reporting crimes—with its inherent "
                                              "complexities and concerns about law enforcement. 'Watchful Eyes' emerges as a beacon of change.",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'outfit'),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                              if (screenWidth > 600) SizedBox(width: 66),
                              if (screenWidth > 600)
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    '/homepage.png',
                                    width: 100,
                                    height: 350,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 46),
                          // AnimatedButton
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF769DC9),
                    Color(0xFF7EA3CA),
                    Color(0xFFCBE1EE),
                    Color(0xFFCBE1EE),
                    Color(0xFFCBE1EE),
                  ],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;

                  return Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Why Choose Us?',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'outfit',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (screenWidth > 600)
                            Expanded(
                              child: _buildWhyChooseUsItem(
                                'User-Friendly',
                                'Our system offers a user-friendly solution to streamline crime reporting, '
                                    'enhance police comprehension, and ultimately improve community safety. '
                                    'We understand the difficulties people face when reporting crimes – '
                                    'the time-consuming nature of the process, the scattered information, '
                                    'and the reservations about trusting law enforcement. "Watchful Eyes" addresses'
                                    ' these issues head-on, providing a seamless and efficient platform for reporting crimes.',
                                '/user-friendly',
                              ),
                            ),
                          if (screenWidth > 600)
                            Expanded(
                              child: _buildWhyChooseUsItem(
                                'Key Features',
                                'At the heart of our system are key features aimed at making the reporting process easy, '
                                    'transparent, and secure. Users can report crimes in real-time through a simple app or website, choosing to keep their identity private if desired. The system organizes crime information neatly, '
                                    '"Watchful Eyes" also focuses on enhancing '
                                    "women's safety, "
                                    'providing a dedicated resource section with safety tips and guidelines for various situations.',
                                '/key-features',
                              ),
                            ),
                          if (screenWidth > 600)
                            Expanded(
                              child: _buildWhyChooseUsItem(
                                  'Objectives',
                                  'Our objectives include developing a web-based application accessible on multiple platforms, '
                                      'crime data visualization with pinpointed locations, and a registration system to differentiate'
                                      ' user privileges. "Watchful Eyes" collaborates with law enforcement, sharing data with local '
                                      'governments and offering special features to users, '
                                      'presenting a unique business opportunity that aligns with our commitment to community safety.',
                                  '/objective'),
                            ),
                          if (screenWidth <= 600)
                            Column(
                              children: [
                                _buildWhyChooseUsItem(
                                  'User-Friendly',
                                  'Our system offers a user-friendly solution to streamline crime reporting, '
                                      'enhance police comprehension, and ultimately improve community safety. '
                                      'We understand the difficulties people face when reporting crimes – ',
                                  'assets/user-friendly',
                                ),
                                _buildWhyChooseUsItem(
                                  'Key Features',
                                  'At the heart of our system are key features aimed at making the reporting process easy, '
                                      'transparent, and secure. Users can report crimes in real-time through a simple app or website, choosing'
                                      ' to keep their identity private if desired. The system organizes crime information neatly, ',
                                  'assets/key-features',
                                ),
                                _buildWhyChooseUsItem(
                                  'Objectives',
                                  'Our objectives include developing a web-based application accessible on multiple platforms, '
                                      'crime data visualization with pinpointed locations, and a registration system to differentiate'
                                      ' user privileges. ',
                                  'assets/objective',
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            // More Benefits Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFCBE1EE),
                    Color(0xFF769DC9),
                    Color(0xFF7EA3CA),
                    Color(0xFF769DC9),
                    Color(0xFFCBE1EE),
                  ],
                ),
              ),
              padding: EdgeInsets.only(top: 40, bottom: 40),
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Some more Benefits',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'outfit',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    if (kIsWeb)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBenefitItem(
                              'Enhanced Safety', 'assets/public-safety.png'),
                          _buildBenefitItem('Innovative Reporting System',
                              'assets/record.png'),
                          _buildBenefitItem("Resources for Women's Safety",
                              'assets/safe.png'),
                        ],
                      ),
                    if (!kIsWeb)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/public-safety.png',
                            width: 65,
                            height: 65,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Enhanced Safety',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "outfit",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/record.png',
                            width: 65,
                            height: 65,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Innovative Reporting System',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "outfit",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/safe.png',
                            width: 65,
                            height: 65,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Resources for Women's Safety",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "outfit",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
      ],
    );
  }

  Widget _buildNavBarItem(String title, IconData icon, VoidCallback onPressed) {
    return kIsWeb ? IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: title,
    ): Row(
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
    return kIsWeb ? IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ): InkWell(
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

Widget _buildBenefitItem(String title, String iconName) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconName,
          width: 80,
          height: 80,
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "outfit",
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

Widget _buildWhyChooseUsItem(
    String title, String description, String iconName) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 26.0),
    child: Container(
      width: 260,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF769DC8),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            '$iconName.png',
            width: 80,
            height: 80,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "outfit",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "outfit",
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
