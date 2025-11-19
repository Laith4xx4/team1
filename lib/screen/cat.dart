import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:team1/features/category_management/presentation/cubit/category_cubit.dart';
import 'package:team1/features/category_management/presentation/cubit/category_state.dart';
import 'package:team1/screen/pro.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategories(); // تحميل الفئات
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFEDEDED)!,
        lightSource: LightSource.right,
        depth: 8,
      ),
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: NeumorphicAppBar(
          title: const Text('All Categories', style: TextStyle(color: Colors.black87)),
          centerTitle: true,
          leading: NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
              depth: 4,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // =========================
              // شريط البحث Neumorphic
              // =========================
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // =========================
              // شبكة الفئات Neumorphic
              // =========================
              Expanded(
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoryError) {
                      return Center(child: Text(state.message));
                    } else if (state is CategoryLoaded) {
                      final filteredCategories = state.categories
                          .where((cat) => cat.name.toLowerCase().contains(searchQuery.toLowerCase()))
                          .toList();

                      if (filteredCategories.isEmpty) {
                        return const Center(child: Text('No categories found.'));
                      }

                      return GridView.builder(
                        itemCount: filteredCategories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Pro(categoryId: category.id),
                                ),
                              );
                              print('Selected category: ${category.name}');
                            },
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                depth: 8,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                                color: Color(0xFF129AA6),
                              ),
                              child: Center(
                                child: Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
