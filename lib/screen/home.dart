import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  List<String> banners = [

    "assets/WhatsApp Image 2025-11-12 at 14.38.35_6b54bf31.jpg",
    "assets/WhatsApp Image 2025-11-12 at 14.38.35_6b54bf31.jpg",
    "assets/WhatsApp Image 2025-11-12 at 14.38.35_6b54bf31.jpg",
    "assets/WhatsApp Image 2025-11-12 at 14.38.35_6b54bf31.jpg",
    "assets/WhatsApp Image 2025-11-12 at 14.38.35_6b54bf31.jpg",


  ];

  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,// لتوسيط المحتوى عموديًا
          children: [
// 🟦 Slider Banner
            CarouselSlider(
              items: banners
                  .map((img) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  img,
                  width: 100,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ))
                  .toList(),
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
            ),

            const SizedBox(height: 30),
            Container(
              width: 150,
              height: 150,

              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,

            ),
              child:  Center(
                child:
                Container(
                   child:  Image.asset(
                      "assets/rt.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,  // يحافظ على الجودة
                    )


                ),
              ),
        ),

            const SizedBox(height: 3),
            const Text(
              'ecommerce',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),

      ),
    );
  }
}
