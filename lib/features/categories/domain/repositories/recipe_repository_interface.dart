import 'package:whisk_and_serve_core/entities/explore/category.dart';

abstract class RecipeRepositoryInterface {
  Future<List<Category>> getRecipeCategories();
}
