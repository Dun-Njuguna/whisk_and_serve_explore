import 'package:whisk_and_serve_core/entities/explore/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> fetchMeals(String ingredient);
}
