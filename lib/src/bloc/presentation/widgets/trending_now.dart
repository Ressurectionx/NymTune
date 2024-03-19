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
        "imageUrl": imgUrl
      },
      {
        "id": 3,
        "title": "Stairway to Heaven",
        "artist": "Led Zeppelin",
        "imageUrl": imgUrl
      },
      {
        "id": 4,
        "title": "Hey Jude",
        "artist": "The Beatles",
        "imageUrl": imgUrl
      },
      {"id": 5, "title": "Imagine", "artist": "John Lennon", "imageUrl": imgUrl}
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
      height: _songs.length * 120,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return TrendingSongItem(song: song);
        },
      ),
    );
  }
}

class TrendingSongItem extends StatelessWidget {
  final Song song;

  const TrendingSongItem({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.dark3()),
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
