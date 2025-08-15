import 'package:flutter/material.dart';

class AppMenuDialog extends StatelessWidget {
  const AppMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.person,
              title: '个人资料',
              onTap: () {
                Navigator.pop(context, 'profile');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: '设置',
              onTap: () {
                Navigator.pop(context, 'settings');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.music_note,
              title: '我的音乐',
              onTap: () {
                Navigator.pop(context, 'music');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: '帮助与反馈',
              onTap: () {
                Navigator.pop(context, 'help');
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: '关于我们',
              onTap: () {
                Navigator.pop(context, 'about');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF171717),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF171717),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
