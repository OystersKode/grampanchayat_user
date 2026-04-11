import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/localization/app_translations.dart';
import '../../routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
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
                  icon: Icons.notifications_none,
                  title: 'announcements'.tr(context),
                  route: AppRoutes.announcements,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.card_giftcard,
                  title: 'wishes'.tr(context),
                  route: AppRoutes.wishes,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.location_city,
                  title: 'villages'.tr(context),
                  route: AppRoutes.villages,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.directions_car,
                  title: 'taluka_vehicles'.tr(context),
                  route: AppRoutes.vehicles,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_add_alt_1_outlined,
                  title: 'membership'.tr(context),
                  route: AppRoutes.membership,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.feedback_outlined,
                  title: 'feedback'.tr(context),
                  route: AppRoutes.feedback,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialIcon(
                  imagePath: 'assets/images/globe.png',
                  url: 'https://kagwad.in',
                  color: Colors.blue,
                  label: 'Website',
                ),
                _buildSocialIcon(
                  imagePath: 'assets/images/instagram.png',
                  url: 'https://www.instagram.com/kagwad.in?igsh=MWJuaDg1ZDJlYXExZg%3D%3D&utm_source=qr',
                  color: const Color(0xFFE4405F),
                  label: 'Instagram',
                ),
                _buildSocialIcon(
                  imagePath: 'assets/images/youtube.svg',
                  url: 'https://youtube.com/@kagwad.in1?si=ZLFWK8XuSyFazUGD',
                  color: const Color(0xFFFF0000),
                  label: 'YouTube',
                  isSvg: true,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon({
    required String imagePath,
    required String url,
    required Color color,
    required String label,
    bool isSvg = false,
  }) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint("Could not launch $url: $e");
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: isSvg
                ? SvgPicture.asset(
                    imagePath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    imagePath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.bold,
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
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushNamed(context, route);
          }
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
