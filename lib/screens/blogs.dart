import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/screens/community-forum.dart';
import 'package:fyp/screens/crime-registeration-form.dart';
import 'package:fyp/screens/map.dart';
import 'package:fyp/screens/safety-directory.dart';
import 'package:fyp/screens/user-panel.dart';
import 'package:fyp/screens/user-profile.dart';
import 'package:video_player/video_player.dart';

import '../authentication/authentication_repo.dart';
import 'AddContact.dart';
import 'login_screen.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Blog> blogs = [
    Blog(title: 'Tackling Behaviors', imagePath: 'assets/blog1.jpg'),
    Blog(title: 'Abuse Awareness', imagePath: 'assets/blog3.jpg'),
    Blog(title: 'Safe Night-Out', imagePath: 'assets/blog2.jpg'),
  ];

  List<VideoPlayerWidget> videos = [
    VideoPlayerWidget(
      videoPath:
          'assets/5-Choke-Hold-Defenses-Women-MUSTKnow_SelfDefense_AjaDang.mp4',
      key: UniqueKey(),
      title: 'Choke Hold Defenses',
      imagePath: 'assets/video1.PNG',
    ),
    VideoPlayerWidget(
      videoPath:
          'assets/7-Self-Defense-Techniques-for-Women-from-Professionals.mp4',
      key: UniqueKey(),
      title: 'Self-Defense Techniques',
      imagePath: 'assets/video2.PNG',
    ),
    VideoPlayerWidget(
      videoPath: 'assets/Safety-Tips-for-Women.mp4',
      key: UniqueKey(),
      title: 'Safety Tips for Women',
      imagePath: 'assets/video3.PNG',
    ),
  ];

  int selectedBlogIndex = 0;
  int selectedVideoIndex = -1;

  bool isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Blog Screen',
              style: TextStyle(fontFamily: 'outfit', color: Colors.white),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
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
            actions: [
              ResponsiveAppBarActions(),
            ],
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Display the sidebar
            return Row(
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Container(
                    width: 200,
                    decoration: const BoxDecoration(
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
                      border: Border(
                        right: BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Blogs Section
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Blogs',
                            style: TextStyle(
                              fontFamily: 'outfit',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Container(
                          height: 200, // Adjust the height as needed
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: blogs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(blogs[index].imagePath),
                                ),
                                title: Text(blogs[index].title,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onTap: () {
                                  setState(() {
                                    selectedBlogIndex = index;
                                    selectedVideoIndex = -1;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        // Videos Section
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Videos',
                            style: TextStyle(
                              fontFamily: 'outfit',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white, // Text color
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.white, // Divider color
                        ),
                        Container(
                          height: 200, // Adjust the height as needed
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              int videoIndex = index + 1;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    videos[index].imagePath,
                                  ),
                                ),
                                title: Text(
                                  '${videos[index].title}',
                                  style: const TextStyle(
                                      fontFamily: 'outfit',
                                      color: Colors.white),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedVideoIndex = index;
                                    selectedBlogIndex = -1;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedBlogIndex != -1 &&
                              selectedBlogIndex < blogs.length)
                            Column(
                              children: [
                                if (selectedBlogIndex == 0)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'We’re in this together: tackling anti-social behaviour as a community',
                                      style: TextStyle(
                                        fontFamily: 'outfit',
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                if (selectedBlogIndex == 0)
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            blogs[selectedBlogIndex].imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (selectedBlogIndex == 0)
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 16),
                                          Text(
                                            'Anti-social behaviour (ASB) covers a wide range of unacceptable activity that causes harm to communities, the environment, and individuals.',
                                            style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Broadly speaking, examples of ASB include:',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            '- Environmental damage\n'
                                            '- Rowdy or nuisance neighbours\n'
                                            '- Abandonment of cars, littering, and dumping of rubbish\n'
                                            '- Street drinking and drug taking\n'
                                            '- Prostitution\n'
                                            '- Misuse of fireworks\n'
                                            '- Inappropriate use of vehicles',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Before dealing with ASB yourself:',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Anti-social behaviour may tempt you to take matters into your own hands, but acting on impulse might result in an escalation of the issue.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Before diving in or calling on your neighbors to help, there are three things you need to consider:',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            '1. Are you being unreasonable? Is this really ASB or simply a minor, harmless disturbance that will soon subside?\n'
                                            '2. Do you feel able to approach the person or group calmly and explain the problems you’re experiencing?\n'
                                            '3. Does the situation suggest your personal safety would be at risk if you approached those involved?',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Your answers to the above should dictate whether or not it’s safe to intervene.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'If you’re happy you can do so calmly and that the situation is serious yet safe enough to justify an approach, there are two things you can try:',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            '1. Approach ASB as a group',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'The Neighbourhood Watch scheme is a fantastic way for communities to work together when it comes to tackling ASB. However, even if you don’t have a Neighbourhood Watch scheme in place, you can still operate as a group.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'For instance, if the issue relates to noise, your neighbors are probably just as annoyed about it as you are. Talk to each other and discuss whether or not it would be sensible to approach the issue yourselves and without intervention from the authorities.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Early intervention is key, and if you can work as a team to approach the people committing the anti-social behaviour and address your concerns as soon as possible, there will be far less chance of it getting worse.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            '2. Mediation',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Sometimes, both parties feel they’re in the right.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'For example, if a particular household is rather fond of late night parties in their front garden, they may argue it’s their right to do so and point to the fact that no one is being physically harmed.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Clearly, you (and your neighbors) have a point too, and when such disputes take place, mediation is a great option to explore.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'The idea is to bring both parties together in the presence of an independent mediator who can listen to both sides of the argument and work towards a peaceful resolution that satisfies everyone.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'If this sounds like an option you’d like to explore, we advise contacting your local council to ask what mediation services are available in your area (some are offered for free), but to also consider restorative justice, which is an effective way of settling disputes.',
                                            style: TextStyle(
                                              fontFamily: 'outfit',
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          if (selectedBlogIndex == 1)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Do you know what to do if an adult is at risk of harm and abuse?',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (selectedBlogIndex == 1)
                            Container(
                              height: MediaQuery.of(context).size.width * 0.5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      blogs[selectedBlogIndex].imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (selectedBlogIndex == 1)
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Text(
                                  'We should all know how to spot signs of abuse and the actions that should be taken if we have a concern. Statistics show that:',
                                  style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '- Last year in Northamptonshire (2019-20) 3,577 concerns were received\n'
                                  '- 1,062 of those concerns needed further action\n'
                                  '- 51% of abuse was due to neglect\n'
                                  '- 30% occurred in the person’s home\n',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'To help raise awareness, the Northamptonshire Safeguarding Adults Board has launched an online survey to find out people’s understanding of safeguarding and if they know how to raise a concern if someone they know is at risk of harm and abuse.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Tim Bishop, Independent Chair of the Safeguarding Adults Board, said: “This is an important opportunity to find out how people in Northamptonshire and our colleagues recognise'
                                  ' how to report a safeguarding concern and what they need to do to report harm and abuse.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  ' “All Northamptonshire residents, whatever their background, are encouraged to complete the survey even if they have not witnessed, or been the victim of abuse.  The information that is gathered from'
                                  'the survey will provide much needed feedback to help NSAB to raise more awareness across the county.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '“We also want to make people aware of the work of the Safeguarding Adults'
                                  ' Board and the range of useful resources that are available on the NSAB website'
                                  ' www.northamptonshiresab.org.uk.”',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'People with care and support needs, such as older people or people with disabilities, are more'
                                  ' likely to become victims of abuse and neglect. '
                                  'They may be seen as easy targets and may be less likely to identify abuse themselves or to report it.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'People with communication difficulties may also be at risk because they may'
                                  ' not be able to alert others, and sometimes they may not even be aware that they are being abused;'
                                  ' this is especially likely if they have a cognitive impairment.'
                                  ' Abusers may try to prevent others from helping the person they abuse.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          if (selectedBlogIndex == 2)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '“Where’s Dave?” 6 tips for a silly but safe night out',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if (selectedBlogIndex == 2)
                            Container(
                              height: MediaQuery.of(context).size.width * 0.5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      blogs[selectedBlogIndex].imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (selectedBlogIndex == 2)
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Text(
                                  'Whether it be an extended catch-up session with friends in a pub garden or'
                                  ' long sunset walk along the beachfront, '
                                  'us Brits certainly know how to make the most of the warmer months.',
                                  style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'However – and without wanting to rain on your summer parade '
                                  '– staying safe while out and about late at night should still be high on your agenda.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'So, to avoid your perfect summer’s evening being wrecked by the '
                                  'actions of someone else, we’ve got six tips for staying safe:',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '1. Keep your valuables hidden',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'There’s no getting away from the fact that most of us carry a fair degree of expensive tech these days. '
                                  'From smartphones to smartwatches and pricey,'
                                  ' eye-catching headphones, personal possessions remain an easy target for thieves.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'If you’re under the influence of alcohol, or preoccupied by blaring music, you’re an '
                                  'even easier target for the nefarious in society. Do all you can to keep your valuables hidden; '
                                  'keep that stuff safely locked away in your bag, purse or zipped pocket.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '2. Stick to well-lit areas',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'If you’re out walking at night after sunset, make sure you keep to well-lit areas.'
                                  ' The more you shroud yourself in darkness, the more you risk your personal safety.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Avoid dark passageways and instead stick to routes that feature adequate street lighting – even if it means taking the long way home',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '3. Identify when you’ve had enough',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'The key thing to a successful, safe night out that you won’t forget, is to identify when you’ve had enough.'
                                  ' If truth be told, we all know when that point arrives; it’s when you know '
                                  '(and even say to yourself) that ‘just one more’ will be one more too many.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'When you reach that point – stop.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Know your limits; you’ll get home safely and feel far fresher in the morning, to boot.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '4. Book a taxi whenever possible',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'We’ve talked about walking home above, but the safest route'
                                  ' back is always via a licensed taxi or lift from someone you know and trust.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Avoid unlicensed cabs, even if they promise a quicker and cheaper route home. Also, if a member of the group wants'
                                  ' to leave early, make sure a member of the team (that’s what you are!) accompanies them home.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '5. Stay together',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'How many times have you headed out for a night with friends only to become separated '
                                  'from the main group? Similarly, how often has '
                                  'the phrase “has anyone seen Dave since he went to the bar?” been uttered during one of your outings?',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Don’t be that person; stick together. '
                                  'The term ‘safety in numbers’ is particularly relevant when it comes to nights out.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  '6. Stay away from hostile situations',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'If you find yourself within the vicinity of a fight or serious disagreement, don’t get involved.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No one wants you to be the hero on a night out, so if you happen to encounter a hostile situation,'
                                  ' leave it to the bouncers and police to resolve. You’re out to have a good time, remember.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Final thought',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'There’s no reason to feel unsafe on a night out – providing you follow the tried-and-tested tips above. '
                                  'In doing so, you’ll remain in '
                                  'control of your own destiny and greatly reduce your chances of ending up in harmful situations.',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'The summer is a wonderful time of year. Go out and enjoy yourself – just stay safe!',
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          Center(
                            child: Text(
                              selectedVideoIndex != -1
                                  ? videos[selectedVideoIndex].title
                                  : "",
                              style: TextStyle(
                                fontFamily: 'outfit',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (selectedVideoIndex != -1 &&
                              selectedVideoIndex < videos.length)
                            videos[selectedVideoIndex],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Display dropdown menu
            return Container(
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
              child: Column(
                children: [
                  // Display default text based on selection
                  Text(
                    'Blogs Below :',
                    style: TextStyle(fontFamily: 'outfit', color: Colors.white),
                  ),
                  // Dropdown button for Blogs
                  DropdownButton<String>(
                    value: selectedBlogIndex == -1
                        ? null
                        : blogs[selectedBlogIndex].title,
                    items: blogs.map((Blog blog) {
                      return DropdownMenuItem<String>(
                        value: blog.title,
                        child: Text(
                          blog.title,
                          style: TextStyle(
                              fontFamily: 'outfit', color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBlogIndex =
                            blogs.indexWhere((blog) => blog.title == newValue);
                        selectedVideoIndex = -1;
                      });
                    },
                    style: TextStyle(fontFamily: 'outfit', color: Colors.black),
                    dropdownColor: Colors.black,
                  ),

// Dropdown button for Videos
                  Text(
                    'Videos Below:',
                    style: TextStyle(fontFamily: 'outfit', color: Colors.white),
                  ),
                  DropdownButton<String>(
                    value: selectedVideoIndex == -1
                        ? null
                        : videos[selectedVideoIndex].title,
                    items: videos.map((VideoPlayerWidget video) {
                      return DropdownMenuItem<String>(
                        value: video.title,
                        child: Text(
                          video.title,
                          style: TextStyle(
                              fontFamily: 'outfit', color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVideoIndex = videos
                            .indexWhere((video) => video.title == newValue);
                        selectedBlogIndex = -1;
                      });
                    },
                    style: TextStyle(fontFamily: 'outfit', color: Colors.black),
                    dropdownColor: Colors.black,
                  ),

                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
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
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selectedBlogIndex != -1 &&
                                selectedBlogIndex < blogs.length)
                              Column(
                                children: [
                                  if (selectedBlogIndex == 0)
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'We’re in this together: tackling anti-social behaviour as a community',
                                        style: TextStyle(
                                          fontFamily: 'outfit',
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  if (selectedBlogIndex == 0)
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              blogs[selectedBlogIndex]
                                                  .imagePath),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  if (selectedBlogIndex == 0)
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 16),
                                            Text(
                                              'Anti-social behaviour (ASB) covers a wide range of unacceptable activity that causes harm to communities, the environment, and individuals.',
                                              style: TextStyle(
                                                  fontFamily: 'outfit',
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Broadly speaking, examples of ASB include:',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '- Environmental damage\n'
                                              '- Rowdy or nuisance neighbours\n'
                                              '- Abandonment of cars, littering, and dumping of rubbish\n'
                                              '- Street drinking and drug taking\n'
                                              '- Prostitution\n'
                                              '- Misuse of fireworks\n'
                                              '- Inappropriate use of vehicles',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Before dealing with ASB yourself:',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Anti-social behaviour may tempt you to take matters into your own hands, but acting on impulse might result in an escalation of the issue.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Before diving in or calling on your neighbors to help, there are three things you need to consider:',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '1. Are you being unreasonable? Is this really ASB or simply a minor, harmless disturbance that will soon subside?\n'
                                              '2. Do you feel able to approach the person or group calmly and explain the problems you’re experiencing?\n'
                                              '3. Does the situation suggest your personal safety would be at risk if you approached those involved?',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Your answers to the above should dictate whether or not it’s safe to intervene.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'If you’re happy you can do so calmly and that the situation is serious yet safe enough to justify an approach, there are two things you can try:',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '1. Approach ASB as a group',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'The Neighbourhood Watch scheme is a fantastic way for communities to work together when it comes to tackling ASB. However, even if you don’t have a Neighbourhood Watch scheme in place, you can still operate as a group.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'For instance, if the issue relates to noise, your neighbors are probably just as annoyed about it as you are. Talk to each other and discuss whether or not it would be sensible to approach the issue yourselves and without intervention from the authorities.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Early intervention is key, and if you can work as a team to approach the people committing the anti-social behaviour and address your concerns as soon as possible, there will be far less chance of it getting worse.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              '2. Mediation',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Sometimes, both parties feel they’re in the right.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'For example, if a particular household is rather fond of late night parties in their front garden, they may argue it’s their right to do so and point to the fact that no one is being physically harmed.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Clearly, you (and your neighbors) have a point too, and when such disputes take place, mediation is a great option to explore.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'The idea is to bring both parties together in the presence of an independent mediator who can listen to both sides of the argument and work towards a peaceful resolution that satisfies everyone.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'If this sounds like an option you’d like to explore, we advise contacting your local council to ask what mediation services are available in your area (some are offered for free), but to also consider restorative justice, which is an effective way of settling disputes.',
                                              style: TextStyle(
                                                fontFamily: 'outfit',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            if (selectedBlogIndex == 1)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Do you know what to do if an adult is at risk of harm and abuse?',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (selectedBlogIndex == 1)
                              Container(
                                height: MediaQuery.of(context).size.width * 0.5,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        blogs[selectedBlogIndex].imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (selectedBlogIndex == 1)
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    'We should all know how to spot signs of abuse and the actions that should be taken if we have a concern. Statistics show that:',
                                    style: TextStyle(
                                        fontFamily: 'outfit',
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '- Last year in Northamptonshire (2019-20) 3,577 concerns were received\n'
                                    '- 1,062 of those concerns needed further action\n'
                                    '- 51% of abuse was due to neglect\n'
                                    '- 30% occurred in the person’s home\n',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'To help raise awareness, the Northamptonshire Safeguarding Adults Board has launched an online survey to find out people’s understanding of safeguarding and if they know how to raise a concern if someone they know is at risk of harm and abuse.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Tim Bishop, Independent Chair of the Safeguarding Adults Board, said: “This is an important opportunity to find out how people in Northamptonshire and our colleagues recognise'
                                    ' how to report a safeguarding concern and what they need to do to report harm and abuse.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    ' “All Northamptonshire residents, whatever their background, are encouraged to complete the survey even if they have not witnessed, or been the victim of abuse.  The information that is gathered from'
                                    'the survey will provide much needed feedback to help NSAB to raise more awareness across the county.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '“We also want to make people aware of the work of the Safeguarding Adults'
                                    ' Board and the range of useful resources that are available on the NSAB website'
                                    ' www.northamptonshiresab.org.uk.”',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'People with care and support needs, such as older people or people with disabilities, are more'
                                    ' likely to become victims of abuse and neglect. '
                                    'They may be seen as easy targets and may be less likely to identify abuse themselves or to report it.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'People with communication difficulties may also be at risk because they may'
                                    ' not be able to alert others, and sometimes they may not even be aware that they are being abused;'
                                    ' this is especially likely if they have a cognitive impairment.'
                                    ' Abusers may try to prevent others from helping the person they abuse.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            if (selectedBlogIndex == 2)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '“Where’s Dave?” 6 tips for a silly but safe night out',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (selectedBlogIndex == 2)
                              Container(
                                height: MediaQuery.of(context).size.width * 0.5,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        blogs[selectedBlogIndex].imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            if (selectedBlogIndex == 2)
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16),
                                  Text(
                                    'Whether it be an extended catch-up session with friends in a pub garden or'
                                    ' long sunset walk along the beachfront, '
                                    'us Brits certainly know how to make the most of the warmer months.',
                                    style: TextStyle(
                                        fontFamily: 'outfit',
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'However – and without wanting to rain on your summer parade '
                                    '– staying safe while out and about late at night should still be high on your agenda.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'So, to avoid your perfect summer’s evening being wrecked by the '
                                    'actions of someone else, we’ve got six tips for staying safe:',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '1. Keep your valuables hidden',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'There’s no getting away from the fact that most of us carry a fair degree of expensive tech these days. '
                                    'From smartphones to smartwatches and pricey,'
                                    ' eye-catching headphones, personal possessions remain an easy target for thieves.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'If you’re under the influence of alcohol, or preoccupied by blaring music, you’re an '
                                    'even easier target for the nefarious in society. Do all you can to keep your valuables hidden; '
                                    'keep that stuff safely locked away in your bag, purse or zipped pocket.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '2. Stick to well-lit areas',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'If you’re out walking at night after sunset, make sure you keep to well-lit areas.'
                                    ' The more you shroud yourself in darkness, the more you risk your personal safety.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Avoid dark passageways and instead stick to routes that feature adequate street lighting – even if it means taking the long way home',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '3. Identify when you’ve had enough',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'The key thing to a successful, safe night out that you won’t forget, is to identify when you’ve had enough.'
                                    ' If truth be told, we all know when that point arrives; it’s when you know '
                                    '(and even say to yourself) that ‘just one more’ will be one more too many.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'When you reach that point – stop.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Know your limits; you’ll get home safely and feel far fresher in the morning, to boot.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '4. Book a taxi whenever possible',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'We’ve talked about walking home above, but the safest route'
                                    ' back is always via a licensed taxi or lift from someone you know and trust.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Avoid unlicensed cabs, even if they promise a quicker and cheaper route home. Also, if a member of the group wants'
                                    ' to leave early, make sure a member of the team (that’s what you are!) accompanies them home.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '5. Stay together',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'How many times have you headed out for a night with friends only to become separated '
                                    'from the main group? Similarly, how often has '
                                    'the phrase “has anyone seen Dave since he went to the bar?” been uttered during one of your outings?',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Don’t be that person; stick together. '
                                    'The term ‘safety in numbers’ is particularly relevant when it comes to nights out.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '6. Stay away from hostile situations',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'If you find yourself within the vicinity of a fight or serious disagreement, don’t get involved.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No one wants you to be the hero on a night out, so if you happen to encounter a hostile situation,'
                                    ' leave it to the bouncers and police to resolve. You’re out to have a good time, remember.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Final thought',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'There’s no reason to feel unsafe on a night out – providing you follow the tried-and-tested tips above. '
                                    'In doing so, you’ll remain in '
                                    'control of your own destiny and greatly reduce your chances of ending up in harmful situations.',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'The summer is a wonderful time of year. Go out and enjoy yourself – just stay safe!',
                                    style: TextStyle(
                                      fontFamily: 'outfit',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            Center(
                              child: Text(
                                selectedVideoIndex != -1
                                    ? videos[selectedVideoIndex].title
                                    : "",
                                style: TextStyle(
                                  fontFamily: 'outfit',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (selectedVideoIndex != -1 &&
                                selectedVideoIndex < videos.length)
                              videos[selectedVideoIndex],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}

class Blog {
  final String title;
  final String imagePath;

  Blog({required this.title, required this.imagePath});
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

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final Key key;
  final String title;
  final String imagePath;

  VideoPlayerWidget({
    required this.videoPath,
    required this.key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);

    // Add listener to update the UI when player state changes
    _controller.addListener(() {
      setState(() {}); // Trigger a rebuild to update the UI
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != oldWidget.videoPath) {
      _controller.dispose();
      _controller = VideoPlayerController.asset(widget.videoPath);
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(1.0);
      _controller.addListener(() {
        setState(() {}); // Trigger a rebuild to update the UI
      });
    }
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: 50.0,
            color: Colors.white,
          ),
          alignment: Alignment.bottomCenter,
          onPressed: _togglePlayPause,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
