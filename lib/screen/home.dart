import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:team1/features/category_management/presentation/cubit/category_cubit.dart';
import 'package:team1/features/category_management/presentation/cubit/category_state.dart';
import 'package:team1/features/product_management/presentation/cubit/product_cubit.dart';
import 'package:team1/features/product_management/presentation/cubit/product_state.dart';
import 'package:team1/features/product_management/presentation/pages/product_listing_screen.dart';
import 'package:team1/features/product_management/presentation/widget/drawer.dart';
import 'package:team1/screen/cat.dart';
import 'package:team1/screen/profail.dart';

import '../features/product_management/presentation/widget/carousl.dart';

const String _baseImageUrl = 'http://192.168.100.66:5086/';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? selectedCategoryId; // لتتبع الفئة المحددة
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  bool _isRewardLoading = false;
  bool _isRewardEarned = false;
  bool _showRewardWhenReady = false;

  var role;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts(); // تحميل كل المنتجات
    context.read<CategoryCubit>().loadCategories(); // تحميل الكاتيجري
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerAd();
      _loadRewardedAd();
    });
  }

  Future<void> _loadBannerAd() async {
    final width = MediaQuery.sizeOf(context).width.truncate();
    final AnchoredAdaptiveBannerAdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    if (adSize == null) {
      debugPrint('⚠️ Unable to determine anchored adaptive banner size');
      return;
    }

    final BannerAd banner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // Test ID
      request: const AdRequest(),
      size: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner loaded 👍');
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (_) => debugPrint('Banner opened'),
        onAdClosed: (_) => debugPrint('Banner closed'),
        onAdClicked: (_) => debugPrint('Banner clicked'),
        onAdImpression: (_) => debugPrint('Banner impression'),
      ),
    );

    await banner.load();
  }

  Future<void> _loadRewardedAd({bool showOnLoad = false}) async {
    if (_isRewardLoading) return;
    setState(() {
      _isRewardLoading = true;
      if (showOnLoad) _showRewardWhenReady = true;
    });

    await RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('Rewarded ad loaded 🎉');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) =>
                debugPrint('Rewarded ad showed'),
            onAdFailedToShowFullScreenContent: (ad, err) {
              debugPrint('Rewarded ad failed to show: $err');
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd();
            },
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('Rewarded ad dismissed');
              ad.dispose();
              setState(() => _rewardedAd = null);
              _loadRewardedAd();
            },
            onAdImpression: (ad) => debugPrint('Rewarded ad impression'),
            onAdClicked: (ad) => debugPrint('Rewarded ad clicked'),
          );

          setState(() {
            _rewardedAd = ad;
            _isRewardLoading = false;
          });

          if (_showRewardWhenReady) {
            _showRewardWhenReady = false;
            _presentRewardedAd();
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded ad failed to load: $error');
          setState(() {
            _isRewardLoading = false;
            _showRewardWhenReady = false;
          });
          Future.delayed(const Duration(seconds: 5), _loadRewardedAd);
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جارٍ تحميل الإعلان، سيتم عرضه فور الجاهزية.'),
        ),
      );
      _loadRewardedAd(showOnLoad: true);
      return;
    }
    _presentRewardedAd();
  }

  void _presentRewardedAd() {
    final ad = _rewardedAd;
    if (ad == null) return;

    ad.show(
      onUserEarnedReward: (AdWithoutView adWithoutView, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        setState(() => _isRewardEarned = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حصلت على ${reward.amount} ${reward.type}!')),
        );
      },
    );
    _rewardedAd = null;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('موقعك', style: TextStyle(color: Colors.black, fontSize: 16)),
            Text(
              'lshop',
              style: TextStyle(
                color: const Color(0xFF129AA6),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Carousl(),
            const SizedBox(height: 20),
            _buildCategoriesSection(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _showRewardedAd,
                    icon: const Icon(Icons.emoji_events,color: Color(0xFF129AA6)),
                    label: Text(
                      _rewardedAd != null
                          ? 'شاهد إعلان واحصل على مكافأة'
                          : (_isRewardLoading
                          ? 'جاري تحميل الإعلان...'
                          : 'اضغط لتحميل وإظهار الإعلان'),
                      style: TextStyle(
                        color: Color(0xFF129AA6), // هنا لون النص
                        fontSize: 16,              // حجم الخط (اختياري)
                        fontWeight: FontWeight.bold, // سمك الخط (اختياري)
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: const Color(0xFFFCF5FD),
                    ),
                  ),
                  if (_isRewardLoading) const SizedBox(height: 10),
                  if (_isRewardLoading)
                    const LinearProgressIndicator(minHeight: 4),
                  if (_isRewardEarned)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        '🎁 تم منحك المكافأة! يمكنك استخدامها الآن.',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: screenHeight * 0.5,
              child: _buildProductsSection(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // bottomNavigationBar: _bannerAd == null
      //     ? null
      //     : SafeArea(
      //         child: SizedBox(
      //           width: _bannerAd!.size.width.toDouble(),
      //           height: _bannerAd!.size.height.toDouble(),
      //           child: AdWidget(ad: _bannerAd!),
      //         ),
      //       ),
    );
  }

  Widget _buildCategoriesSection() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is CategoryError) return Center(child: Text(state.message));

        if (state is CategoryLoaded) {
          final categories = state.categories;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        selectedCategoryId = null;
                        setState(() {});
                        context
                            .read<ProductCubit>()
                            .loadProducts(); // كل المنتجات
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AllCategoriesScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'All categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF129AA6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 55,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          selectedCategoryId = null;
                          setState(() {});
                          context.read<ProductCubit>().loadProducts();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedCategoryId == null
                              ? Color(0xFF129AA6)
                              : Colors.grey.shade200,
                          foregroundColor: selectedCategoryId == null
                              ? Colors.white
                              : Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("All"),
                      ),
                    ),
                    ...categories.map((cat) {
                      final bool isSelected = cat.id == selectedCategoryId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            selectedCategoryId = cat.id;
                            setState(() {});
                            context.read<ProductCubit>().loadProductsByCategory(
                              cat.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? const Color(0xFF9400FF)
                                : Colors.grey.shade200,
                            foregroundColor: isSelected
                                ? Colors.white
                                : Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: isSelected ? 3 : 0,
                          ),
                          child: Text(
                            cat.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  // Widget _buildProductsSection() {
  //   return BlocConsumer<ProductCubit, ProductState>(
  //     listener: (context, state) {
  //       if (state is ProductError) {
  //         ScaffoldMessenger.of(
  //           context,
  //         ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
  //       } else if (state is ProductActionSuccess) {
  //         ScaffoldMessenger.of(
  //           context,
  //         ).showSnackBar(SnackBar(content: Text(state.message)));
  //       }
  //     },
  //     builder: (context, state) {
  //       if (state is ProductLoading)
  //         return const Center(child: CircularProgressIndicator());
  //       if (state is ProductLoaded) {
  //         final products = state.products;
  //         if (products.isEmpty)
  //           return const Center(child: Text('No products to display.'));
  //         return ListView.builder(
  //           itemCount: products.length,
  //           itemBuilder: (context, index) {
  //             final product = products[index];
  //             return Card(
  //               margin: const EdgeInsets.all(8.0),
  //               child: ListTile(
  //                 leading: SizedBox(
  //                   width: 50,
  //                   height: 50,
  //                   child:
  //                       product.mainImageUrl != null &&
  //                           product.mainImageUrl!.startsWith('file://')
  //                       ? Image.file(
  //                           File(
  //                             product.mainImageUrl!.replaceFirst('file://', ''),
  //                           ),
  //                           fit: BoxFit.cover,
  //                         )
  //                       : (product.mainImageUrl != null
  //                             ? Image.network(
  //                                 _baseImageUrl + product.mainImageUrl!,
  //                                 fit: BoxFit.cover,
  //                               )
  //                             : const Icon(Icons.image_not_supported)),
  //                 ),
  //                 title: Text(product.name),
  //                 subtitle: Text(
  //                   'Price: \$${product.price.toStringAsFixed(2)}',
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //       return const Center(child: Text('No products to display.'));
  //     },
  //   );
  // }
  Widget _buildProductsSection() {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        } else if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const Center(child: Text('No products to display.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.8,
                    surfaceIntensity: 0.2,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    color: Color(0xFF129AA6),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 55,
                        height: 55,
                        child: _buildProductImage(product),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Price: \$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 18),
                    onTap: () {
                      // تنقل لصفحة تفاصيل المنتج
                    },
                  ),
                ),
              );
            },
          );
        }

        return const Center(child: Text('No products to display.'));
      },
    );
  }

  Widget _buildProductImage(product) {
    if (product.mainImageUrl != null &&
        product.mainImageUrl!.startsWith('file://')) {
      return Image.file(
        File(product.mainImageUrl!.replaceFirst('file://', '')),
        fit: BoxFit.cover,
      );
    }

    return product.mainImageUrl != null
        ? Image.network(
      _baseImageUrl + product.mainImageUrl!,
      fit: BoxFit.cover,
    )
        : const Icon(Icons.image_not_supported, color: Colors.black45);
  }

}
