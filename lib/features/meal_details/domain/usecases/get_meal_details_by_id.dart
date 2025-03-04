import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_explore/features/meal_details/domain/repositories/meal_details_repository_interface.dart';

class GetMealDetailsById {
  final MealDetailsRepositoryInterface repository;

  GetMealDetailsById({
    required this.repository,
  });

  Future<MealDetails> call({required String mealId}) async {
    return await repository.getMealDetailsById(mealId: mealId);
  }
}
