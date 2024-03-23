import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../data/models/song_model.dart';
import '../../providers/favourite_provider.dart';
import '../../providers/song_provider.dart';
import '../views/details_view.dart';

class TrendingNow extends StatefulWidget {
  const TrendingNow({super.key});
  @override
  State<TrendingNow> createState() => _TrendingNowState();
}

class _TrendingNowState extends State<TrendingNow> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (provider.hasError) {
          return Text(provider.errorMessage); // Show error message
        } else {
          // Determine the number of columns based on the screen width
          int crossAxisCount = MediaQuery.of(context).size.width > 1200 ? 2 : 1;
          return GridView.builder(
            shrinkWrap: true, // Needed to use GridView inside a Column/ListView
            physics:
                const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Set based on screen width
              childAspectRatio: 10 / 3, // Adjust the aspect ratio as needed
              crossAxisSpacing: 10, // Adjust the spacing as needed
              mainAxisSpacing: 10, // Adjust the spacing as needed
            ),
            itemCount: provider.songs.length,
            itemBuilder: (context, index) {
              final song = provider.songs[index];
              return TrendingSongItem(
                  index: index,
                  song: song,
                  isLast: index == provider.songs.length - 1);
            },
          );
        }
      },
    );
  }
}

class TrendingSongItem extends StatelessWidget {
  final Song song;
  final bool isLast;
  final int index;

  const TrendingSongItem(
      {super.key,
      required this.song,
      required this.isLast,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    // Determine if the current song is liked
    favoriteProvider
        .isFavorite(song.title); // Assuming each song has a unique 'id'
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            transitionDuration:
                const Duration(milliseconds: 500), // Adjust duration as needed
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailsView(index: index),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                )
                    .chain(CurveTween(curve: Curves.easeInOutQuad))
                    .animate(animation),
                child: child,
              );
            },
          ),
          (route) => false, // Clear navigation history
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: isLast ? Colors.transparent : AppColors.dark3()),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrendingSongImage(imageUrl: song.imageUrl),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: AppTextStyles.title
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      text: 'by ',
                      style: AppTextStyles.info
                          .copyWith(color: Colors.grey.shade600, fontSize: 14),
                      children: [
                        TextSpan(
                          text: song.artist,
                          style: AppTextStyles.info.copyWith(
                              color: Colors.grey.shade400, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Consumer<FavoriteProvider>(
              builder: (context, provider, _) {
                bool isLikedNow = provider.isFavorite(song.title);

                return GestureDetector(
                  onTap: () {
                    // Toggle the liked state using the provider
                    if (isLikedNow) {
                      favoriteProvider.removeFavorite(song.title);
                      isLikedNow = false;
                    } else {
                      favoriteProvider.addFavorite(song.title);
                      isLikedNow = true;
                    }
                  },
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: isLikedNow
                        ? Lottie.asset("assets/json_lottie/heart.json",
                            height: 65, repeat: false, fit: BoxFit.cover)
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
      ),
    );
  }
}

class TrendingSongImage extends StatelessWidget {
  final String imageUrl;

  const TrendingSongImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
