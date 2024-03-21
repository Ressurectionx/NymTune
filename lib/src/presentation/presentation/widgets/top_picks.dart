import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import 'package:nymtune/src/core/utils/app_routes.dart';
import 'package:nymtune/src/presentation/presentation/views/details_view.dart';
import 'package:nymtune/src/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/song_model.dart';

class TopPicks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return CircularProgressIndicator(); // Show loading indicator
        } else if (provider.hasError) {
          return Text(provider.errorMessage); // Show error message
        } else {
          // Show songs using ListView.builder
          return SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.songs.length,
              itemBuilder: (context, index) {
                final song = provider.songs[index];
                return SongItem(
                  song: song,
                  index: index,
                );
              },
            ),
          );
        }
      },
    );
  }
}

class SongItem extends StatelessWidget {
  final Song song;
  final int index;

  const SongItem({
    Key? key,
    required this.song,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsView(
              index: index,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(
          left: 20,
          right: 6,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.dark3().withOpacity(0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SongImage(imageUrl: song.imageUrl, index: index),
            SongDetails(song: song),
          ],
        ),
      ),
    );
  }
}

class SongImage extends StatelessWidget {
  final String imageUrl;
  final int index;

  const SongImage({
    Key? key,
    required this.imageUrl,
    required this.index, // Update constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "song_image_$index", // Use index to create a unique tag
      child: Card(
        elevation: 1,
        color: Colors.grey,
        shadowColor: Colors.grey,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          width: 200,
          height: 150,
          child: Stack(
            children: [
              SizedBox(
                width: 200,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: Lottie.asset(
                  "assets/images/heart.json",
                  height: 60,
                  repeat: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongDetails extends StatelessWidget {
  final Song song;

  const SongDetails({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              song.title,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'by ',
              style: AppTextStyles.description.copyWith(
                letterSpacing: 1.3,
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                  text: song.artist,
                  style: AppTextStyles.description.copyWith(
                    letterSpacing: 1.3,
                    color: Colors.grey.shade500,
                    fontSize: 12,
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
