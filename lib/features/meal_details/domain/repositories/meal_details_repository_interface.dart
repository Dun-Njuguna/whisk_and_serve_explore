import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';

abstract class MealDetailsRepositoryInterface {
  Future<MealDetails> getMealDetailsById({required String mealId});
}
