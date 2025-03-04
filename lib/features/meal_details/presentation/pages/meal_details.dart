import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_core/widgets/base_scaffold.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/bloc/meal_details_bloc.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/meal_details_section.dart';

class MealDetailsPage extends StatefulWidget {
  const MealDetailsPage({super.key});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  String? mealId;

  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newCategoryName =
        NavigationHelper.getPathParameter(context, 'mealId');

    if (mealId == newCategoryName && isInitialized) return;

    mealId = newCategoryName;
    isInitialized = true;

    addBlocEvent<MealDetailsBloc>(
      context,
      FetchMealDetailsById(mealId: mealId!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: createBlocBuilder<MealDetailsBloc, MealDetailsState>(
        builder: (context, state) {
          if (state is MealDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealDetailsLoaded) {
            final meal = state.meal;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 400,
                      maxWidth: MediaQuery.of(context).size.width > 500
                          ? 500
                          : MediaQuery.of(context).size.width,
                    ),
                    child: Image.network(
                      meal.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MealDetailsSection(
                      meal: meal,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is MealDetailsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
