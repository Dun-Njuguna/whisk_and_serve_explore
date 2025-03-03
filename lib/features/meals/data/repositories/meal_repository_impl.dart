import 'package:whisk_and_serve_core/entities/explore/meal.dart';
import 'package:whisk_and_serve_explore/features/meals/data/data_sources/remote_data_source.dart';
import 'package:whisk_and_serve_explore/features/meals/data/models/meal_model.dart';
import 'package:whisk_and_serve_explore/features/meals/domain/repositories/meal_repository_interface.dart';

class MealRepositoryImpl implements MealRepository {
  final RemoteDataSource remoteDataSource;

  MealRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Meal>> fetchMeals(String ingredient) async {
    final meals = await remoteDataSource.fetchMealsByMainIngredient(ingredient);

    return meals.map((model) => _mapMealToEntity(model)).toList();
  }
}

// Helper method to map a MealModel to a Meal entity
Meal _mapMealToEntity(MealModel meal) => Meal(
      mealId: meal.mealId,
      name: meal.strMeal,
      thumbnail: meal.strMealThumb,
    );
