import 'package:whisk_and_serve_core/entities/explore/meal_details.dart';
import 'package:whisk_and_serve_explore/features/meal_details/data/data_sources/meal_details_remote_data_source.dart';
import 'package:whisk_and_serve_explore/features/meal_details/data/models/meal_details_model.dart';
import 'package:whisk_and_serve_explore/features/meal_details/domain/repositories/meal_details_repository_interface.dart';

class MealDetailsRepositoryImplementation
    implements MealDetailsRepositoryInterface {
  final MealDetailsRemoteDataSource remoteDataSource;

  MealDetailsRepositoryImplementation({
    required this.remoteDataSource,
  });

  @override
  Future<MealDetails> getMealDetailsById({required String mealId}) async {
    final MealDetailsModel details =
        await remoteDataSource.getMealDetails(mealId: mealId);

    return MealDetails(
      id: details.id,
      name: details.name,
      category: details.category,
      area: details.area,
      instructions: details.instructions,
      thumbnail: details.thumbnail,
      youtube: details.youtube,
      ingredients: details.ingredients,
    );
  }
}
