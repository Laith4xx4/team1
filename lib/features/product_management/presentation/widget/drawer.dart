import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team1/features/auth1/presentation/bloc/auth_cubit.dart';
import 'package:team1/features/auth1/presentation/bloc/auth_state.dart';
import 'package:team1/features/product_management/presentation/pages/product_listing_screen.dart';
import 'package:team1/screen/cat.dart';
import 'package:team1/screen/profail.dart';
import 'package:team1/successsialog.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", state.token);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login Successful')));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SuccessDialog(),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Login Failed')));
        }
      },
      builder: (context, state) {

        bool isAdmin = false;

        if (state is AuthSuccess) {
          // غيّرها حسب اسم المتغير عندك
          isAdmin = state.user.role == "admin";
        }

        return Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF129AA6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.store,
                          size: 32,
                          color: Color(0xFF129AA6),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'LShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'متجر إلكتروني متكامل',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('الرئيسية'),
                  onTap: () => Navigator.pop(context),
                ),

                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('جميع التصنيفات'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllCategoriesScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('الملف الشخصي'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('حول التطبيق'),
                  onTap: () => Navigator.pop(context),
                ),

                // ✅ يظهر فقط إذا كان المستخدم Admin
                if (isAdmin)
                  ListTile(
                    leading: const Icon(Icons.create_new_folder),
                    title: const Text("Add Product"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListingScreen(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
