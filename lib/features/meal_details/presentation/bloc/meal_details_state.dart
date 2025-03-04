part of 'meal_details_bloc.dart';

@immutable
sealed class MealDetailsState {}

final class MealDetailsInitial extends MealDetailsState {}

final class MealDetailsLoading extends MealDetailsState {}

final class MealDetailsLoaded extends MealDetailsState {
  final MealDetails meal;
  MealDetailsLoaded({
    required this.meal,
  });
}

final class MealDetailsError extends MealDetailsState {
  final String message;
  MealDetailsError({
    required this.message,
  });
}
