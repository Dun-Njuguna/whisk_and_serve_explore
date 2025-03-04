import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_core/widgets/base_scaffold.dart';
import 'package:whisk_and_serve_explore/core/widgets/list_view_item.dart';
import 'package:whisk_and_serve_explore/features/meals/presentation/bloc/meals_bloc.dart';

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  String? categoryName;

  bool isInitialized = false; // To ensure the event is dispatched only once

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newCategoryName =
        NavigationHelper.getPathParameter(context, 'category');

    if (categoryName == newCategoryName && isInitialized) return;

    categoryName = newCategoryName;
    isInitialized = true;

    addBlocEvent<MealsBloc>(
      context,
      FetcMealsByMainIngrident(ingredient: categoryName!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "$categoryName Meals",
      child: createBlocBuilder<MealsBloc, MealsState>(
        builder: (context, state) {
          if (state is MealsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealsLoaded) {
            return staggeredMealsGrid(state, categoryName!);
          } else if (state is MealsError) {
            _showErrorSnackbar(state.message);
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Press refresh to load categories"));
        },
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    SnackbarHandler(context).show(GenericMessage(
      message: message,
      type: MessageType.error,
    ));
  }
}

Widget staggeredMealsGrid(MealsLoaded state, String categoryName) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MasonryGridView.count(
      key: const PageStorageKey<String>('mealsGrid'),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: state.meals.length,
      itemBuilder: (context, index) {
        final meal = state.meals[index];

        return GestureDetector(
          onTap: () {
            NavigationHelper.navigateTo(
                context, '/${AppRoutes.meals}/$categoryName/${meal.mealId}');
          },
          child: SizedBox(
            height: index.isEven ? 220 : 170,
            child: ListItemCard(
              item: ListItem(
                title: meal.name,
                thumbUrl: meal.thumbnail,
              ),
            ),
          ),
        );
      },
    ),
  );
}
