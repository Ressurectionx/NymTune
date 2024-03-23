// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import 'package:nymtune/src/presentation/presentation/views/details_view.dart';
import 'package:provider/provider.dart';
import '../../data/models/song_model.dart';
import '../../providers/favourite_provider.dart';
import '../../providers/song_provider.dart';

class TopPicks extends StatelessWidget {
  ScrollController horizontalScrollController;
  TopPicks({required this.horizontalScrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (provider.hasError) {
          return Text(provider.errorMessage); // Show error message
        } else {
          // Show songs using ListView.builder
          return SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: horizontalScrollController,
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
    super.key,
    required this.song,
    required this.index,
  });

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

class SongImage extends StatefulWidget {
  final String imageUrl;
  final int index; // Update constructor

  const SongImage({
    super.key,
    required this.imageUrl,
    required this.index,
  });

  @override
  State<SongImage> createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "song_image_${widget.index}", // Use index for unique tag
      child: Card(
        elevation: 1,
        color: Colors.grey,
        shadowColor: Colors.grey,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          width: 245,
          height: 170,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class SongDetails extends StatefulWidget {
  final Song song;

  const SongDetails({
    super.key,
    required this.song,
  });

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  @override
  Widget build(BuildContext context) {
    // Access the FavoriteProvider
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 170,
                child: Text(
                  widget.song.title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title
                      .copyWith(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 170,
                child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                    text: 'by ',
                    style: AppTextStyles.info
                        .copyWith(color: Colors.grey.shade600, fontSize: 12),
                    children: [
                      TextSpan(
                        text: widget.song.artist,
                        style: AppTextStyles.info.copyWith(
                            color: Colors.grey.shade400, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Consumer<FavoriteProvider>(
            builder: (context, provider, _) {
              bool isLikedNow = provider.isFavorite(widget.song.title);
              return GestureDetector(
                onTap: () {
                  // Toggle the liked state using the provider
                  if (isLikedNow) {
                    favoriteProvider.removeFavorite(widget.song.title);
                    isLikedNow = false;
                  } else {
                    favoriteProvider.addFavorite(widget.song.title);
                    isLikedNow = true;
                  }
                },
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: isLikedNow
                      ? Lottie.asset("assets/json_lottie/heart.json",
                          height: 60, repeat: false, fit: BoxFit.cover)
                      : const Icon(
                          Icons.favorite_border,
                          size: 30,
                          color: Colors.grey,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
