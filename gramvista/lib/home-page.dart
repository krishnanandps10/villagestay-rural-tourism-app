import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gramvista/features/auth/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> spotlightPlaces = const [
    {
      'image': 'Carousel/1.png',
      'title': 'Pottery Village - Rajasthan',
    },
    {
      'image': 'Carousel/2.png',
      'title': 'Organic Farm Stay - Kerala',
    },
    {
      'image': 'Carousel/3.png',
      'title': 'Himalayan Homestay - Uttarakhand',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
  elevation: 0,
  centerTitle: true,
  backgroundColor: Colors.green[800],
  title: Image.asset(
    'assets/logo/logo.png',
    height: 220,
    fit: BoxFit.contain,
  ),
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// 🌟 Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 320,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 4),
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              items: spotlightPlaces.map((place) {
                return Builder(
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              place['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Text('Image not found')),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Text(
                                place['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 6,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// ✨ Centered Quote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: const [
                  Text(
                    '"Experience the heart of India through its villages — where tradition meets tranquility."',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 🔐 Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text(
                'Login to Explore',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 40),

            /// 🧭 About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'About Athithya',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Athithya is your gateway to explore the rich cultural and rural heritage of India. '
                    'Discover authentic village experiences, sustainable stays, and community-driven tourism that preserves tradition while empowering locals.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// 📞 Contact Us
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '📍 Location: Bengaluru, India\n'
                    '📧 Email: support@athithya.in\n'
                    '📞 Phone: +91-9876543210',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
            const Text(
              'Powered by Village Communities 🏡',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
