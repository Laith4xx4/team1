import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {


  final IconData icon;
  final String title;
  final Color color;
  final Widget trailing;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // يجعل الصف بأكمله قابلاً للضغط مع تأثير متموج
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            // أيقونة بخلفية دائرية فاتحة
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1), // لون خفيف للخلفية
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24), // الأيقونة بلونها الأساسي
            ),
            const SizedBox(width: 16),
            // عنوان الإعداد
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 16),
            // العنصر الختامي (سهم، مفتاح، نص)
            trailing,
          ],
        ),
      ),
    );
  }
}

