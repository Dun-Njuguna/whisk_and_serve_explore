import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/features/categories/presentation/bloc/recipe_categories_bloc.dart';
import 'package:whisk_and_serve_explore/core/widgets/list_view_item.dart';

Widget gridViewItem(RecipeCategoriesLoaded state) {
  return LayoutBuilder(
    builder: (context, constraints) {
      int columns = getColumnCount(screenWidth: constraints.maxWidth);
      return GridView.builder(
        key: const PageStorageKey<String>('exploreGrid'),
        itemCount: state.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          childAspectRatio: 0.85,
        ),
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final category = state.categories[index];
          return GestureDetector(
            onTap: () {
              NavigationHelper.navigateTo(
                  context, '/${AppRoutes.meals}/${category.name}');
            },
            child: ListItemCard(
              item: ListItem(
                title: category.name,
                thumbUrl: category.thumbUrl,
              ),
            ),
          );
        },
      );
    },
  );
}
