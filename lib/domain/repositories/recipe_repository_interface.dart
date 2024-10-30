import 'package:whisk_and_serve_core/entities/category.dart';

abstract class RecipeRepositoryInterface {
  Future<List<Category>> getRecipeCategories();
}
