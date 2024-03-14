import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/map.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../authentication/EmergencycontactsRepo.dart';
import '../authentication/authentication_repo.dart';

import 'AddContact.dart';
import 'blogs.dart';
import 'login_screen.dart';

class SafetyDirectory extends StatefulWidget {
  const SafetyDirectory({Key? key}) : super(key: key);

  @override
  _SafetyDirectoryState createState() => _SafetyDirectoryState();
}

class _SafetyDirectoryState extends State<SafetyDirectory> {
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
              title: const Text(
                'Safety Directory',
                style: TextStyle(color: Colors.white, fontFamily: 'outfit'),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                ResponsiveAppBarActions(),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Column(
                      children: [
                        if (kIsWeb) Icon(Icons.warning, color: Colors.white),
                        Text('Threats Handling',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      children: [
                        if (kIsWeb) Icon(Icons.shield, color: Colors.white),
                        Text('Defence Procedures',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      children: [
                        if (kIsWeb) Icon(Icons.security, color: Colors.white),
                        Text('Defence Gadgets',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              )),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF769DC9),
                  Color(0xFF769DC9),
                  Color(0xFF7EA3CA),
                  Color(0xFF769DC9),
                  Color(0xFFCBE1EE),
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TabBarView(
                  children: [
                    EmergencyPersonalThreatProcedure(),
                    SelfDefenseProcedures(),
                    SelfDefenseGadgets(),
                  ],
                );
              },
            ),
          ),
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

class EmergencyPersonalThreatProcedure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Personal Threat Procedure',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'outfit',
              ),
            ),
            SizedBox(height: 10),
            buildInstructionTile(
              'Threats to self or others may include harassment, assault, suicide, robbery, or armed hold-ups.',
              Icons.warning,
            ),
            buildSubtitle('Remain Calm:'),
            buildInstructionTile('- Do not panic or shout.', Icons.mic),
            buildInstructionTile('- Avoid eye contact.', Icons.remove_red_eye),
            buildInstructionTile(
                '- Do not make sudden movements.', Icons.directions_walk),
            buildSubtitle('Do Not Take Risks:'),
            buildInstructionTile(
                '- Hand over whatever is requested.', Icons.check),
            buildInstructionTile(
                '- Do not do anything that may antagonize the offender.',
                Icons.block),
            buildInstructionTile('- Alert others around you if safe to do so.',
                Icons.notification_important),
            buildInstructionTile(
              '- Contain yourself in a secure area by locking your office door, closing blinds, and staying out of sight.',
              Icons.security,
            ),
            buildSubtitle('Do Only What You Are Told:'),
            buildInstructionTile(
                '- Do not volunteer any other information.', Icons.info),
            buildSubtitle(
                'Personal Threat Report (observe offender’s characteristics):'),
            buildInstructionTile(
                '- Sex, height, voice, clothing, tattoos, jewelry, items touched, etc.',
                Icons.person),
            buildInstructionTile(
              '- Note the type of vehicle used for escape, registration number if possible, and last known direction.',
              Icons.directions_car,
            ),
            buildSubtitle('Telephone:'),
            buildInstructionTile(
                '- Dial 15 and state the threat.', Icons.phone),
            buildInstructionTile(
                '- Lahore Police Complaint 8300, UAN: 0304-1110911',
                Icons.phone),
            buildInstructionTile('- Mayo Hospital	042-99211100', Icons.phone),
            buildInstructionTile(
                '- Stay on the line and keep the line of communication open.',
                Icons.call),
            buildInstructionTile(
              '- Give your location and request urgent attendance.',
              Icons.assignment_turned_in,
            ),
            buildInstructionTile(
                '- Most importantly – Remain CALM.', Icons.sentiment_neutral),
          ],
        ),
      ),
    );
  }

  Widget buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'outfit',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildInstructionTile(String text, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

class SelfDefenseProcedures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Self Defense Procedures',
              style: TextStyle(
                fontFamily: 'outfit',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            // Responsive layout for the images
            MediaQuery.of(context).size.width > 700
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageBox(
                        context,
                        'Weak Points',
                        'assets/procedure1.jpg',
                      ),
                      _buildImageBox(
                        context,
                        'Self Defense Move',
                        'assets/procedure2.jpg',
                      ),
                      _buildImageBox(
                        context,
                        'Emergency Information',
                        'assets/procedure3.jpg',
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildImageBox(
                        context,
                        'Weak Points',
                        'assets/procedure1.jpg',
                      ),
                      SizedBox(height: 44),
                      _buildImageBox(
                        context,
                        'Self Defense Move',
                        'assets/procedure2.jpg',
                      ),
                      SizedBox(height: 44),
                      _buildImageBox(
                        context,
                        'Emergency Information',
                        'assets/procedure3.jpg',
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            // Responsive layout for the cards
            MediaQuery.of(context).size.width > 900
                ? Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                            'Key Elements of Self-Defence', Icons.lightbulb, [
                          'Situational Awareness',
                          'Mindset',
                          'Avoidance and Evasion',
                          'Verbal De-escalation and Boundary Setting',
                          'Physical Self Defence',
                          'Aftermath',
                        ]),
                      ),
                      SizedBox(width: 20), // Add some spacing between the cards
                      Expanded(
                        child: _buildCard(
                            'Self-Defence Tips', Icons.check_circle, [
                          'Create distance to assess the situation.',
                          'Be loud to draw witnesses.',
                          'Act decisively and fight hard.',
                          'Stay on your feet or get up asap.',
                          'Target hard bones to vulnerable points.',
                          'The goal is to get to safety.',
                        ]),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildCard(
                          'Key Elements of Self-Defence', Icons.lightbulb, [
                        'Situational Awareness',
                        'Mindset',
                        'Avoidance and Evasion',
                        'Verbal De-escalation and Boundary Setting',
                        'Physical Self Defence',
                        'Aftermath',
                      ]),
                      SizedBox(
                          height: 20), // Add some spacing between the cards
                      _buildCard('Self-Defence Tips', Icons.check_circle, [
                        'Create distance and barriers to buy time and assess the situation.',
                        'Be loud to draw witnesses.',
                        'Act decisively and fight hard.',
                        'Stay on your feet or get up as soon as you can.',
                        'Target hard bones to vulnerable points.',
                        'The goal is to get to safety.',
                      ]),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBox(BuildContext context, String title, String imagePath) {
    return InkWell(
      onTap: () {
        _showImageDialog(context, imagePath);
      },
      child: Container(
        width: MediaQuery.of(context).size.width > 700 ? 200 : double.infinity,
        height: MediaQuery.of(context).size.width > 700 ? 200 : 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width > 700 ? 100 : 200,
              height: MediaQuery.of(context).size.width > 700 ? 100 : 200,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'outfit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, List<String> content) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(icon, color: Color(0xFF779ECA)),
              title: Text(
                title,
                style: TextStyle(
                  fontFamily: 'outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF779ECA),
                ),
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: content.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.arrow_right, color: Color(0xFF779ECA)),
                  title: Text(
                    content[index],
                    style: TextStyle(fontSize: 16, color: Color(0xFF779ECA)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog on tap.
            },
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SelfDefenseGadgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Self Defense Gadgets',
              style: TextStyle(
                  fontFamily: 'outfit',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20),
            _buildGadgetsRow(context, [
              GadgetItem(
                title: 'Pepper Spray',
                buyLink:
                    'https://saamaan.pk/products/reusable-pepper-spray-with-keychain?_pos=1&_sid=6fb898c5c&_ss=r',
                imagePath: 'assets/pepper-spray.png',
              ),
              GadgetItem(
                title: 'Taser',
                buyLink:
                    'https://www.survivalgear.pk/shop/dz-x10-taser-pakistan/',
                imagePath: 'assets/taser.png',
              ),
              GadgetItem(
                title: 'Paralyzer',
                buyLink:
                    'https://tacticalgears.pk/products/paralyzer-high-voltage-pulse-batons-510-fz?_pos=5&_sid=2f7647d9a&_ss=r',
                imagePath: 'assets/stick.png',
              ),
              // Add more gadgets as needed
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildGadgetsRow(BuildContext context, List<GadgetItem> gadgets) {
    if (MediaQuery.of(context).size.width > 600) {
      // For wider screens, show all gadgets in the same row
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            gadgets.map((gadget) => _buildGadget(context, gadget)).toList(),
      );
    } else {
      // For smaller screens, show one gadget per row
      return Column(
        children:
            gadgets.map((gadget) => _buildGadget(context, gadget)).toList(),
      );
    }
  }

  Widget _buildGadget(BuildContext context, GadgetItem gadget) {
    return InkWell(
      onTap: () {
        _showGadgetDetails(context, gadget.title, gadget.buyLink);
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width > 1100 ? 300 : 150,
                height: MediaQuery.of(context).size.width > 1100 ? 300 : 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF779ECA)),
                ),
                child: Image.asset(
                  gadget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                gadget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGadgetDetails(BuildContext context, String title, String buyLink) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontFamily: 'outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _launchURL(buyLink);
                },
                child: Text('Buy Now'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class GadgetItem {
  final String title;
  final String buyLink;
  final String imagePath;

  GadgetItem({
    required this.title,
    required this.buyLink,
    required this.imagePath,
  });
}
