import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_core/widgets/base_scaffold.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/bloc/meal_details_bloc.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/meal_details_section.dart';

class MealDetailsPage extends StatefulWidget {
  const MealDetailsPage({super.key});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  String? mealId;
  bool isFavourite = false;
  bool isInitialized = false;

  MealDetails? meal;

  StreamSubscription<FavouritesBusResponse>? _favouriteEventSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newMealId = NavigationHelper.getPathParameter(context, 'mealId');

    // Avoid unnecessary re-initialization
    if (mealId == newMealId && isInitialized) return;

    mealId = newMealId;
    isInitialized = true;

    // Fetch meal details
    addBlocEvent<MealDetailsBloc>(
      context,
      FetchMealDetailsById(mealId: mealId!),
    );

    // Reset listeners to avoid duplication
    _setupFavouriteListeners();

    // Query favourite status for the meal
    _queryFavouriteStatus();
  }

  void _setupFavouriteListeners() {
    // Cancel existing subscriptions if any
    _favouriteEventSubscription?.cancel();

    // Listen to add/remove favourite events
    _favouriteEventSubscription =
        GlobalEventBus.on<FavouritesBusResponse>().listen((event) {
      if (event.mealId == mealId) {
        setState(() {
          isFavourite = event.isFavourite;
        });
      }
    });
  }

  void _queryFavouriteStatus() {
    GlobalEventBus.trigger(
      FavouritesBusQueryEvent(mealId: mealId!, action: FavouritesAction.query),
    );
  }

  void _updateFavourite(MealDetails meal, FavouritesAction action) {
    GlobalEventBus.trigger(
      FavouritesBusEvent(meal: meal, action: action),
    );
  }

  @override
  void dispose() {
    _favouriteEventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "",
      isMealFavourite: isFavourite,
      updateFavouriteStatus: () {
        if (isFavourite && meal != null) {
          _updateFavourite(meal!, FavouritesAction.remove);
        } else if (!isFavourite && meal != null) {
          _updateFavourite(meal!, FavouritesAction.add);
        }
      },
      child: createBlocBuilder<MealDetailsBloc, MealDetailsState>(
        builder: (context, state) {
          if (state is MealDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealDetailsLoaded) {
            meal = state.meal;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 400,
                      maxWidth: MediaQuery.of(context).size.width > 500
                          ? 500
                          : MediaQuery.of(context).size.width,
                    ),
                    child: Image.network(
                      meal!.thumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MealDetailsSection(meal: meal!),
                  ),
                ],
              ),
            );
          } else if (state is MealDetailsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
