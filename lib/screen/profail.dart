import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team1/features/auth1/presentation/bloc/auth_cubit.dart';
import 'package:team1/features/auth1/presentation/pages/login_screen.dart';

import '../features/product_management/presentation/widget/ProfileCard.dart';
import '../features/product_management/presentation/widget/SettingsItem.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'.tr())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // قسم الحساب
            Text(
              'Account'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const ProfileCard(
              name: 'laith yassen',
              info: 'Edit My Info',
            ),
            const SizedBox(height: 30),

            // قسم الإعدادات الأخرى
            Text(
              'Other'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // قائمة الإعدادات
            SettingsItem(
              icon: Icons.folder_open,
              title: 'Offers History'.tr(),
              color: Colors.orange.shade400,
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => print('Go to Offers History'),
            ),
            SettingsItem(
              icon: Icons.sentiment_satisfied_alt,
              title: 'About Us'.tr(),
              color: const Color(0xFF129AA6),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => print('Go to About Us'),
            ),
            SettingsItem(
              icon: Icons.menu_book,
              title: 'Terms & Privacy Policy'.tr(),
              color: Colors.red.shade400,
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => print('Go to Terms'),
            ),
            SettingsItem(
              icon: Icons.language,
              title: 'Language'.tr(),
              color: Colors.orange.shade700,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.locale.languageCode == 'ar' ? 'Arabic' : 'English',
                    style: const TextStyle(color: Color(0xFF129AA6), fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
              onTap: () {
                final currentLocale = context.locale ?? const Locale('en');
                final newLocale = currentLocale.languageCode == 'ar'
                    ? const Locale('en')
                    : const Locale('ar');
                context.setLocale(newLocale);
                print('Language changed');
              },
            ),
            SettingsItem(
              icon: Icons.notifications_none,
              title: 'Notification'.tr(),
              color: Colors.blue.shade500,
              trailing: Switch(
                value: _isNotificationEnabled,
                onChanged: (value) {
                  setState(() => _isNotificationEnabled = value);
                },
                activeColor: const Color(0xFF129AA6),
              ),
              onTap: () {
                setState(() {
                  _isNotificationEnabled = !_isNotificationEnabled;
                });
              },
            ),
            SettingsItem(
              icon: Icons.logout,
              title: 'Sign Out'.tr(),
              color: Colors.red,
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                context.read<AuthCubit>().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
