import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import '../../data/models/song_model.dart';

class TrendingNow extends StatefulWidget {
  @override
  _TrendingNowState createState() => _TrendingNowState();
}

class _TrendingNowState extends State<TrendingNow> {
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
      height: (_songs.length * 120) + 150,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          final isLast =
              index == _songs.length - 1; // Checking if it's the last item

          return TrendingSongItem(song: song, isLast: isLast);
        },
      ),
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
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

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
