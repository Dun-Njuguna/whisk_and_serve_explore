part of 'recipe_categories_bloc.dart';

@immutable
sealed class RecipeCategoriesEvent {}

class FetchRecipeCategories extends RecipeCategoriesEvent {}
