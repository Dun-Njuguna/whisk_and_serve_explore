part of 'recipe_categories_bloc.dart';

@immutable
sealed class RecipeCategoriesState {}

class RecipeCategoriesInitial extends RecipeCategoriesState {}

class RecipeCategoriesLoading extends RecipeCategoriesState {}

class RecipeCategoriesLoaded extends RecipeCategoriesState {
  final List<Category> categories;

  RecipeCategoriesLoaded({required this.categories});
}

class RecipeCategoriesError extends RecipeCategoriesState {
  final String message;

  RecipeCategoriesError({required this.message});
}
