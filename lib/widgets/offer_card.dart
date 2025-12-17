import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.title,
    required this.description1,
    required this.description2,
    required this.imagePath,
  });

  final String title;
  final String description1;
  final String description2;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 0, 1),
      child: Container(
        height: 160,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),

              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontFamily: "Inter Bold",
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description1,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          description2,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
