import 'package:whisk_and_serve_core/entities/category.dart';

import '../repositories/recipe_repository_interface.dart';

class GetRecipeCategories {
  final RecipeRepositoryInterface repository;

  GetRecipeCategories({required this.repository});

  Future<List<Category>> call() async {
    return await repository.getRecipeCategories();
  }
}
