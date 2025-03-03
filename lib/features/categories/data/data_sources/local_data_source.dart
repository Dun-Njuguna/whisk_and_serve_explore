import 'package:whisk_and_serve_core/data/isar_helpers.dart';
import 'package:whisk_and_serve_core/entities/explore/category.dart';
import 'package:whisk_and_serve_explore/features/categories/data/models/category_model.dart';

class LocalDataSource {
  final IsarHelpers isarHelpers;

  LocalDataSource(this.isarHelpers);

  Future<List<Category>> getCachedCategories() async {
    return await isarHelpers.getAll<Category>();
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final items = categories
        .map((categoryModel) => Category(
              categoryId: categoryModel.idCategory,
              name: categoryModel.strCategory,
              thumbUrl: categoryModel.strCategoryThumb,
              description: categoryModel.strCategoryDescription,
            ))
        .toList();

    await isarHelpers.putAll(items);
  }

  Future<void> clearExpiredCategories(Duration expiryDuration) async {
    await isarHelpers.clearExpiredRecords<Category>(expiryDuration);
  }
}
