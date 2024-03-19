import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import 'package:nymtune/src/core/utils/app_routes.dart';
import '../../data/models/song_model.dart';

class TopPicks extends StatefulWidget {
  @override
  _TopPicksState createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {
  final List<Song> _songs = []; // List to hold songs

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    String imgUrl =
        "https://images-platform.99static.com/bi6KeQq1GTyLD_yseZT3QsR1Brc=/0x0:2000x2000/500x500/top/smart/99designs-contests-attachments/127/127640/attachment_127640646";
    String imgUrl1 =
        "https://www.billboard.com/wp-content/uploads/2024/02/02-beyonce-press-2024-cr-Mason-Poole-billboard-1548.jpg?w=942&h=623&crop=1";
    String imgUrl2 =
        "https://i.ebayimg.com/images/g/jUEAAOSwSvVlbbm3/s-l1200.webp";
    String imgUrl3 =
        "https://i0.wp.com/fabukmagazine.com/wp-content/uploads/2023/09/PAUL-RUSSELL-RELEASES-HIGH-ENERGY-MUSIC-VIDEO-FOR-BUZZING-SINGLE-LIL-BOO-THANG-TODAY.jpg?resize=768%2C768&ssl=1";
    String imgUrl4 =
        "https://i.ytimg.com/vi/k6HIl6ZY5ro/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLD0UGW_dtJfLxElR6WZOw4TJGb6ZQ";

    var json = [
      {
        "id": 1,
        "title": "Bohemian Rhapsody",
        "artist": "Queen",
        "imageUrl": imgUrl
      },
      {
        "id": 2,
        "title": "Hotel California",
        "artist": "Eagles",
        "imageUrl": imgUrl1
      },
      {
        "id": 3,
        "title": "Stairway to Heaven",
        "artist": "Led Zeppelin",
        "imageUrl": imgUrl2
      },
      {
        "id": 4,
        "title": "Hey Jude",
        "artist": "The Beatles",
        "imageUrl": imgUrl3
      },
      {
        "id": 5,
        "title": "Imagine",
        "artist": "John Lennon",
        "imageUrl": imgUrl4
      }
    ];

    // Parse JSON data and add to the list of songs
    List<Song> songs = json.map((json) => Song.fromJson(json)).toList();

    setState(() {
      _songs.addAll(songs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return SongItem(
            song: song,
            index: index,
          );
        },
      ),
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
        Navigator.pushNamed(context, AppRoutes.details);
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
