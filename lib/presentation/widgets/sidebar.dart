import 'package:flutter/material.dart';
import '../../core/localization/app_translations.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Drawer(
      backgroundColor: const Color(0xFFFFF8F3),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF5E0006),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_balance, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    'panchayat_portal'.tr(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        user.isAnonymous ? 'guest'.tr(context) : (user.email ?? ''),
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.newspaper,
                  title: 'news'.tr(context),
                  route: AppRoutes.news,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.card_giftcard,
                  title: 'wishes'.tr(context),
                  route: AppRoutes.wishes,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_add_alt_1_outlined,
                  title: 'membership'.tr(context),
                  route: AppRoutes.membership,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'settings'.tr(context),
                  route: AppRoutes.settings,
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'logout'.tr(context),
                  onTap: () async {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5E0006)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF241A06),
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (route != null) {
          Navigator.pop(context); // Close drawer
          // If we are already on the route, don't push it again
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
