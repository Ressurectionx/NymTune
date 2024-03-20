import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';
import '../../data/models/song_model.dart';

class TrendingNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (provider.hasError) {
          return Text(provider.errorMessage); // Show error message
        } else {
          return SizedBox(
            height: (provider.songs.length * 120) + 150,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.songs.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final song = provider.songs[index];
                final isLast = index == provider.songs.length - 1;

                return TrendingSongItem(song: song, isLast: isLast);
              },
            ),
          );
        }
      },
    );
  }
}

class TrendingSongItem extends StatelessWidget {
  final Song song;
  final bool isLast;

  const TrendingSongItem({
    super.key,
    required this.song,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${song.artist}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(CupertinoIcons.suit_heart)
        ],
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
