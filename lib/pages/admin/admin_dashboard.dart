//admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_unisafe/models/theme_provider.dart';
import 'package:flutter_unisafe/pages/admin/admins_management.dart';
import 'package:flutter_unisafe/pages/admin/contact_us.dart';
import 'package:flutter_unisafe/pages/admin/obligations.dart';
import '../login/google_login_handler.dart';
import 'student_reports.dart';

class AdminDashboard extends StatefulWidget {
  final ValueNotifier userCredential;
  final int block;
  const AdminDashboard(
      {super.key, required this.userCredential, required this.block});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int? selectedBlock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // actions: themeSwitchWithIcons(context),
        title: const Text(
          'ADMIN DASHBOARD',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700.withOpacity(0.7),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.userCredential.value.user!.displayName!.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // color: Colors.black, // Change text color to a darker shade of orange
                  ),
                ),
                accountEmail: Text(
                  widget.userCredential.value.user!.email!.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    // color: Colors.orange
                    //     .shade700, // Change text color to a medium shade of orange
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    widget.userCredential.value.user!.photoURL!.toString(),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.contacts),
                title: Text(
                  "Contact Us",
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ContactUsAdminPage(), // Now fetching reports from Firestore
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  "LogOut",
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.pop(context); //routes
                  bool result = await signOutFromGoogle();
                  if (result) widget.userCredential.value = '';
                },
              ),
              ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...themeSwitchWithIcons(context),
                  ],
                ),
                title: Text(
                  'Theme',
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () async {},
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            (widget.block != 0)
                ? Text(
                    'Block ${widget.block}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<int>(
                      value: selectedBlock,
                      hint: const Text('Select Block'),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedBlock = newValue;
                        });
                      },
                      items: [
                        const DropdownMenuItem<int>(
                          value: 0,
                          child: Text('All Blocks'),
                        ),
                        ...List<DropdownMenuItem<int>>.generate(
                          56,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('Block ${index + 1}'),
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: <Widget>[
                  // In DashboardCard where you define the 'Student Reports' card
                  DashboardCard(
                    icon: Icons.description,
                    title: 'Student Reports',
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentReportPage(
                            block: (widget.block != 0)
                                ? widget.block
                                : selectedBlock ?? 0,
                          ), // Now fetching reports from Firestore
                        ),
                      );
                    },
                  ),
                  DashboardCard(
                    icon: Icons.checklist,
                    title: 'Obligations',
                    color: const Color.fromARGB(255, 64, 182, 60),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminObligationsPage()),
                      );
                    },
                  ),
                  if (widget.block == 0)
                    DashboardCard(
                      icon: Icons.event_note,
                      title: 'Admins Management',
                      color: Colors.purple,
                      onPressed: () {
                        // Navigate to events page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminManagementPage(
                              userCredential: widget.userCredential,
                            ),
                          ),
                        );
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
}

class DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isPressed ? 15 : 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color.withOpacity(0.5), widget.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(widget.icon, size: 70.0, color: Colors.white),
            const SizedBox(height: 10),
            Center(
              child: Text(
                widget.title,
                textAlign:
                    TextAlign.center, // Align text in the center horizontally
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
