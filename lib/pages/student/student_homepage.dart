import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisafe/pages/student/all_reports.dart';
import 'package:unisafe/pages/student/contact_us.dart';
import 'package:unisafe/pages/student/feedback.dart';
import 'package:unisafe/pages/student/profile.dart';
import 'package:unisafe/pages/student/settings.dart';
import 'package:unisafe/utils/user_helpers.dart';
import '../login/google_login_handler.dart';
import 'resolved_reports.dart';
import 'recent_reports.dart';
import 'faq.dart';
import 'report_incident.dart';
import 'stories.dart';
import 'tips.dart';
import 'support_contacts.dart';
import '../../models/theme_provider.dart';

class StudentHomePage extends StatefulWidget {
  final ValueNotifier<UserCredential?> userCredential;
  const StudentHomePage({super.key, required this.userCredential});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late int _selectedIndex;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;

    _widgetOptions = <Widget>[
      DashboardPage(userCredential: widget.userCredential),
      FeedbackPage(userCredential: widget.userCredential),
      ProfilePage(userCredential: widget.userCredential),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.withValues(alpha: 0.7),
        centerTitle: true,
        title: const Text('UNISAFE', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: _buildDrawer(context),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        // fixedColor: Colors.orange.withOpacity(0.2),
        backgroundColor: Colors.grey.withValues(alpha: 0.2),
        type: BottomNavigationBarType.fixed,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback_sharp), label: 'Feedback'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange.withValues(alpha: 0.9),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        // color: Colors.orange.shade50, // Change the background color of the drawer to a light shade of orange
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                getUserName(widget.userCredential.value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  // color: Colors.black, // Change text color to a darker shade of orange
                ),
              ),
              accountEmail: Text(
                getUserEmail(widget.userCredential.value),
                style: const TextStyle(
                  fontSize: 16,
                  // color: Colors.orange
                  //     .shade700, // Change text color to a medium shade of orange
                ),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(getUserPhoto(widget.userCredential.value)),
                onBackgroundImageError: (_, _) {},
                child: getUserPhoto(widget.userCredential.value).isEmpty ? const Icon(Icons.person, size: 50) : null,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade700,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 5, spreadRadius: 5)],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentSettingsPage(userCredential: widget.userCredential)),
                );
              },
              color: Colors.orange.shade600, // Change the color of the icon and text to a darker shade of orange
            ),
            _buildDrawerItem(
              icon: Icons.contacts,
              text: 'Contact Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsPage()));
              },
              color: Colors.orange.shade600, // Change the color of the icon and text to a darker shade of orange
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'LogOut',
              onTap: () async {
                Navigator.pop(context);
                bool result = await signOutFromGoogle();
                if (result) widget.userCredential.value = null;
              },
              color: Colors.orange.shade600, // Change the color of the icon and text to a darker shade of orange
            ),
            ListTile(
              leading: Row(mainAxisSize: MainAxisSize.min, children: [...themeSwitchWithIcons(context)]),
              title: Text(
                'Theme',
                style: TextStyle(fontSize: 16, color: Colors.orange.shade600, fontWeight: FontWeight.bold),
              ),
              onTap: () async {},
              // tileColor: Colors.orange
              //     .shade200, // Change the tile background color to a lighter shade of orange
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap, required Color color}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}

class DashboardPage extends StatefulWidget {
  final ValueNotifier<UserCredential?> userCredential;
  const DashboardPage({super.key, required this.userCredential});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //
  void navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileReportPage(userCredential: widget.userCredential)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyReportsPage(userCredential: widget.userCredential)));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TipsPage()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => StoriesPage()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = [
      _buildCard(context, Icons.donut_large, 'Recent Reports', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecentReportsPage(userCredential: widget.userCredential)));
      }),
      _buildCard(context, Icons.star, 'All reports', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AllReportsPage(userCredential: widget.userCredential)));
      }),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: ListView(scrollDirection: Axis.horizontal, children: cards),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 25,
              children: List.generate(6, (index) {
                final List<IconData> icons = [
                  Icons.dashboard,
                  Icons.psychology,
                  Icons.account_circle,
                  Icons.lightbulb_outline,
                  Icons.library_add,
                  Icons.help,
                ];
                final List<String> labels = ['Report Incident', 'Support', 'Resolved Reports', 'Anonymous Tip', 'Stories', 'FAQ'];

                IconData icon = icons[index];
                String label = labels[index];

                return Card(
                  color: Colors.deepOrange.withValues(alpha: 0.7),
                  elevation: 20,
                  shadowColor: Colors.deepOrange,
                  child: InkWell(
                    onTap: () {
                      navigateToPage(context, index);
                    },
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 50), Text(label)]),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    double cardWidth = MediaQuery.of(context).size.width * 0.50; // Adjust this value as needed

    return SizedBox(
      width: cardWidth,
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: const Color.fromARGB(255, 255, 115, 0).withValues(alpha: 0.7),
          elevation: 20,
          shadowColor: const Color.fromARGB(255, 255, 115, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(label, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
