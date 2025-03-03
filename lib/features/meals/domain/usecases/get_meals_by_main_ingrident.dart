import 'package:whisk_and_serve_core/entities/explore/meal.dart';
import 'package:whisk_and_serve_explore/features/meals/domain/repositories/meal_repository_interface.dart';

class GetMealsByMainIngrident {
  final MealRepository repository;

  GetMealsByMainIngrident({
    required this.repository,
  });

  Future<List<Meal>> call({required String ingredient}) async {
    return await repository.fetchMeals(
      ingredient,
    );
  }
}
