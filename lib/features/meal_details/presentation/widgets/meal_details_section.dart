import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/expandable_section.dart';

class MealDetailsSection extends StatelessWidget {
  final MealDetails meal;

  const MealDetailsSection({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Meal
        Text(
          meal.name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Category & Cuisine
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(label: Text('Category: ${meal.category}')),
            Chip(label: Text('Cuisine: ${meal.area}')),
          ],
        ),
        const SizedBox(height: 16),

        // Ingredients Section (Collapsible)
        ExpandableSection(
          title: 'Ingredients',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: meal.ingredients
                .map((ingredient) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.circle, size: 8),
                      title: Text(
                        '${ingredient['strMeasure']} ${ingredient['strIngredient']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Instructions Section (Collapsible)
        ExpandableSection(
          title: 'Instructions',
          child: Text(
            meal.instructions,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
