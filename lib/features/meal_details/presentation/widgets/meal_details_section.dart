import 'package:flutter/material.dart';
import 'package:whisk_and_serve_core/whisk_and_serve_core.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/custom_chip.dart';
import 'package:whisk_and_serve_explore/features/meal_details/presentation/widgets/video_popup.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MealDetailsSection extends StatefulWidget {
  final MealDetails meal;

  const MealDetailsSection({super.key, required this.meal});

  @override
  MealDetailsSectionState createState() => MealDetailsSectionState();
}

class MealDetailsSectionState extends State<MealDetailsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.meal.youtube != null && widget.meal.youtube!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.meal.youtube!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  void _playVideo() {
    if (_youtubeController != null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => VideoPopup(controller: _youtubeController!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal Name
          Text(
            widget.meal.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Category & Cuisine + YouTube Video Chip
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              buildChip(context, 'Category: ${widget.meal.category}'),
              buildChip(context, 'Cuisine: ${widget.meal.area}'),

              // Add YouTube Chip if video exists
              if (widget.meal.youtube != null &&
                  widget.meal.youtube!.isNotEmpty)
                GestureDetector(
                  onTap: _playVideo,
                  child: buildChip(context, 'Watch Video',
                      icon: Icons.play_circle_fill),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'Ingredients'),
              Tab(text: 'Instructions'),
            ],
          ),

          // Tab Bar View
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Ingredients Tab
                ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: widget.meal.ingredients
                      .map((ingredient) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.circle, size: 8),
                            title: Text(
                              '${ingredient['strMeasure']} ${ingredient['strIngredient']}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ))
                      .toList(),
                ),

                // Instructions Tab
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.meal.instructions,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
