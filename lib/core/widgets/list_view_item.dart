import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/widgets/app_card.dart';

class ListItem {
  final String title;
  final String thumbUrl;

  const ListItem({
    required this.title,
    required this.thumbUrl,
  });
}

class ListItemCard extends StatelessWidget {
  const ListItemCard({
    super.key,
    required this.item,
  });

  final ListItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            item.thumbUrl,
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
              color: Colors.white.withValues(alpha: 0.85),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
