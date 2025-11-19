import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String info;

  const ProfileCard({
    super.key,
    required this.name,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // لجعل البطاقة قابلة للضغط
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            // أيقونة المستخدم محاطة بحد بنفسجي
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF129AA6), width: 2),
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(width: 16),
            // الاسم ومعلومات التعديل
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // سهم الانتقال
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت مخصص لعنصر إعداد واحد في القائمة
