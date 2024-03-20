class Song {
  final String title;
  final String artist;
  final String duration;
  final String audioUrl;
  final String imageUrl;

  Song({
    required this.title,
    required this.artist,
    required this.duration,
    required this.audioUrl,
    required this.imageUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      duration: json['duration'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
