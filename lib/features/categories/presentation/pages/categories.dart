import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_core/widgets/base_scaffold.dart';
import 'package:whisk_and_serve_explore/features/categories/presentation/bloc/recipe_categories_bloc.dart';
import 'package:whisk_and_serve_explore/core/widgets/custom_grid_view.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  ExploreState createState() => ExploreState();
}

class ExploreState extends State<Explore>
    with AutomaticKeepAliveClientMixin<Explore> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final state =
        getCurrentState<RecipeCategoriesBloc, RecipeCategoriesState>(context);

    if (state is RecipeCategoriesInitial) {
      addBlocEvent<RecipeCategoriesBloc>(context, FetchRecipeCategories());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseScaffold(
      child: createBlocBuilder<RecipeCategoriesBloc, RecipeCategoriesState>(
        builder: (context, state) {
          if (state is RecipeCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeCategoriesLoaded) {
            return gridViewItem(state);
          } else if (state is RecipeCategoriesError) {
            _showErrorSnackbar(state.message);
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Press refresh to load categories"));
        },
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    SnackbarHandler(context).show(GenericMessage(
      message: message,
      type: MessageType.error,
    ));
  }
}
