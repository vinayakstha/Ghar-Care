import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String serviceName;
  final String price;
  final VoidCallback onCardTap;
  final VoidCallback? onFavorite;

  const ServiceCard({
    super.key,
    required this.imageUrl,
    required this.serviceName,
    required this.price,
    required this.onCardTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 210,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.error)),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),

              // Dark Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                ),
              ),

              // Favorite Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white70,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Text Content
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
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
