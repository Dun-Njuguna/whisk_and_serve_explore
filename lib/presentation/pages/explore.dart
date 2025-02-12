import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/presentation/bloc/recipe_categories_bloc.dart';
import 'package:whisk_and_serve_explore/presentation/widgets/category_item.dart';

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

    return Scaffold(
      body: createBlocBuilder<RecipeCategoriesBloc, RecipeCategoriesState>(
        builder: (context, state) {
          if (state is RecipeCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeCategoriesLoaded) {
            return _buildGridView(state);
          } else if (state is RecipeCategoriesError) {
            _showErrorSnackbar(state.message);
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Press refresh to load categories"));
        },
      ),
    );
  }

  Widget _buildGridView(RecipeCategoriesLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = getColumnCount(screenWidth: constraints.maxWidth);
        return GridView.builder(
          key: const PageStorageKey<String>('exploreGrid'),
          itemCount: state.categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 8,
            mainAxisSpacing: 4,
            childAspectRatio: 0.8,
          ),
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            final category = state.categories[index];
            return CategoryItem(category: category);
          },
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    SnackbarHandler(context).show(GenericMessage(
      message: message,
      type: MessageType.error,
    ));
  }
}
