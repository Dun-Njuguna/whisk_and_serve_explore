part of 'meals_bloc.dart';

@immutable
sealed class MealsState {}

final class MealsInitial extends MealsState {}

class MealsLoading extends MealsState {}

class MealsLoaded extends MealsState {
  final List<Meal> meals;

  MealsLoaded({
    required this.meals,
  });
}

class MealsError extends MealsState {
  final String message;

  MealsError({required this.message});
}
