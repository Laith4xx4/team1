import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdExample extends StatefulWidget {
  const BannerAdExample({super.key});

  @override
  State<BannerAdExample> createState() => _BannerAdExampleState();
}

class _BannerAdExampleState extends State<BannerAdExample> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    // 1️⃣ احصل على حجم البانر المناسب تلقائياً
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      debugPrint("⚠️ Unable to get adaptive banner size");
      return;
    }

    // 2️⃣ إنشاء الإعلان
    final BannerAd banner = BannerAd(
      size: size,
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("Banner loaded 👍");
          setState(() => _bannerAd = ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Banner failed: $error");
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );

    // 3️⃣ تحميل الإعلان
    await banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adaptive Banner Example")),
      body: Center(child: const Text("Your Content Here")),

      // 4️⃣ عرض البانر في الأسفل
      bottomNavigationBar: _bannerAd == null
          ? const SizedBox()
          : SafeArea(
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      ),
    );
  }
}

