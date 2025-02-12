import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/entities/category.dart';
import 'package:whisk_and_serve_core/widgets/app_card.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            category.thumbUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              color: Colors.white.withValues(alpha: 0.65),
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
