//admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';
import 'package:unisafe/core/app_colors.dart';
import 'package:unisafe/core/theme_provider.dart';
import 'package:unisafe/view/screens/admins_management.dart';
import 'package:unisafe/view/screens/admin_contact_us_page.dart';
import 'package:unisafe/view/screens/obligations.dart';
import 'package:unisafe/view/widgets/dashboard_card.dart';
import 'student_reports.dart';

class AdminDashboard extends StatefulWidget {
  final int block;
  const AdminDashboard({super.key, required this.block});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int? selectedBlock;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthSession>().user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ADMIN DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.green700.withValues(alpha: 0.7),
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  user.displayNameOrDefault,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // color: Colors.black, // Change text color to a darker shade of orange
                  ),
                ),
                accountEmail: Text(
                  user.emailOrEmpty,
                  style: const TextStyle(
                    fontSize: 16,
                    // color: Colors.orange
                    //     .shade700, // Change text color to a medium shade of orange
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.photoUrlOrPlaceholder),
                  onBackgroundImageError: (_, _) {},
                  child: user.photoUrlOrPlaceholder.isEmpty ? const Icon(Icons.person, size: 50) : null,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green700,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 5, spreadRadius: 5)],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.contacts),
                title: Text(
                  "Contact Us",
                  style: TextStyle(color: AppColors.green600, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminContactUsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  "LogOut",
                  style: TextStyle(color: AppColors.green600, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await context.read<AuthSession>().signOut();
                },
              ),
              ListTile(
                leading: Row(mainAxisSize: MainAxisSize.min, children: [...themeSwitchWithIcons(context)]),
                title: Text(
                  'Theme',
                  style: TextStyle(color: AppColors.green600, fontWeight: FontWeight.bold),
                ),
                onTap: () async {},
              ),
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
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
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
                        const DropdownMenuItem<int>(value: 0, child: Text('All Blocks')),
                        ...List<DropdownMenuItem<int>>.generate(
                          56,
                          (index) => DropdownMenuItem(value: index + 1, child: Text('Block ${index + 1}')),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 10),
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
                            block: (widget.block != 0) ? widget.block : selectedBlock ?? 0,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminObligationsPage()));
                    },
                  ),
                  if (widget.block == 0)
                    DashboardCard(
                      icon: Icons.event_note,
                      title: 'Admins Management',
                      color: Colors.purple,
                      onPressed: () {
                        // Navigate to events page
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminManagementPage()));
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
