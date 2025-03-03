import 'package:whisk_and_serve_core/entities/explore/category.dart';
import 'package:whisk_and_serve_explore/features/categories/data/data_sources/local_data_source.dart';
import 'package:whisk_and_serve_explore/features/categories/data/data_sources/remote_data_source.dart';
import 'package:whisk_and_serve_explore/features/categories/data/models/category_model.dart';
import 'package:whisk_and_serve_explore/features/categories/domain/repositories/recipe_repository_interface.dart';

class RecipeRepositoryImpl implements RecipeRepositoryInterface {
  final RecipeRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final Duration cacheExpiryDuration;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.cacheExpiryDuration = const Duration(days: 1),
  });

  @override
  Future<List<Category>> getRecipeCategories() async {
    // // Check if there's valid cached data
    final cachedCategories = await localDataSource.getCachedCategories();

    if (cachedCategories.isNotEmpty && _isCacheValid(cachedCategories)) {
      print("fetching from cache");
      return cachedCategories;
    }

    print("fetching from remote");
    final categoryModels = await remoteDataSource.getRecipeCategories();

    await localDataSource.cacheCategories(categoryModels);

    return categoryModels.map((model) => _mapModelToEntity(model)).toList();
  }

  bool _isCacheValid(List<Category> cachedCategories) {
    // Check if any cached category is still valid based on the expiry duration
    return cachedCategories.any((category) {
      return category.createdAt
          .isAfter(DateTime.now().subtract(cacheExpiryDuration));
    });
  }
}

// Helper method to map a CategoryModel to a Category entity
Category _mapModelToEntity(CategoryModel model) {
  return Category(
    categoryId: model.idCategory,
    name: model.strCategory,
    thumbUrl: model.strCategoryThumb,
    description: model.strCategoryDescription,
  );
}
