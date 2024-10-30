import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/bloc/bloc_helpers.dart';
import 'package:whisk_and_serve_core/entities/category.dart';
import 'package:whisk_and_serve_explore/domain/use_cases/get_recipe_categories.dart';

part 'recipe_categories_event.dart';
part 'recipe_categories_state.dart';

class RecipeCategoriesBloc
    extends BaseBloc<RecipeCategoriesEvent, RecipeCategoriesState> {
  final GetRecipeCategories getRecipeCategories;

  RecipeCategoriesBloc({
    required this.getRecipeCategories,
  }) : super(
          RecipeCategoriesInitial(),
        ) {
    onWithStateEmitter<FetchRecipeCategories>(
      _onFetchRecipeCategories,
    );
  }

  Future<void> _onFetchRecipeCategories(
    FetchRecipeCategories event,
    StateEmitter<RecipeCategoriesState> emitter,
  ) async {
            print("event.....  ${event}");
    await emitter.emit(RecipeCategoriesLoading());
    try {
      final categories = await getRecipeCategories.call();
      for (var item in categories) {
        print("categories.....  ${item}");
      }
      await emitter.emit(RecipeCategoriesLoaded(categories: categories));
    } catch (e) {
      await emitter.emit(RecipeCategoriesError(message: e.toString()));
    }
  }
}
