// song.dart

class Song {
  final String id;
  final String title;
  final String artist;
  final String imageUrl; // URL to the song's image

  Song(
      {required this.id,
      required this.title,
      required this.artist,
      required this.imageUrl});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
    };
  }
}
