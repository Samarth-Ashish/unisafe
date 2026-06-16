import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unisafe/core/auth_session.dart';
import 'package:unisafe/core/user_info_extensions.dart';
import 'package:unisafe/core/theme_provider.dart';
import 'drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final Color headerColor;
  final Color itemColor;
  final List<DrawerItemConfig> items;

  const AppDrawer({
    super.key,
    required this.headerColor,
    required this.itemColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthSession>().user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user.displayNameOrDefault,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              user.emailOrEmpty,
              style: const TextStyle(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoUrlOrPlaceholder),
              onBackgroundImageError: (_, _) {},
              child: user.photoUrlOrPlaceholder.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            decoration: BoxDecoration(
              color: headerColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ],
            ),
          ),
          ...items.map((item) {
            if (item.isThemeSwitch) {
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [...themeSwitchWithIcons(context)],
                ),
                title: Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 16,
                    color: itemColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              );
            }
            return DrawerItem(
              icon: item.icon,
              label: item.label,
              color: itemColor,
              onTap: item.onTap,
            );
          }),
        ],
      ),
    );
  }
}

class DrawerItemConfig {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isThemeSwitch;

  DrawerItemConfig({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isThemeSwitch = false,
  });
}
