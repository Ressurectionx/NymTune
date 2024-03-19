import 'package:flutter/material.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
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
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return SongItem(song: song);
        },
      ),
    );
  }
}

class SongItem extends StatelessWidget {
  final Song song;

  const SongItem({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SongImage(imageUrl: song.imageUrl),
          SongDetails(song: song),
        ],
      ),
    );
  }
}

class SongImage extends StatelessWidget {
  final String imageUrl;

  const SongImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
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
