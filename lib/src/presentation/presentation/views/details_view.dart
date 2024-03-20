import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import 'package:nymtune/src/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/song_model.dart';

class DetailsView extends StatefulWidget {
  final int index;

  const DetailsView({Key? key, required this.index}) : super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late StreamController<Uint8List> _audioStreamController;
  late bool _isPlaying;
  late String _audioFilePath = '';
  late AudioPlayer _audioPlayer;
  bool _hasFetchedAudio = false; // New variable to track if audio is fetched
  bool _isFetchingAudio = false;
  bool _fetchErrorOccurred =
      false; // New variable to track if an error occurred
  Song? song;
  @override
  void initState() {
    super.initState();
    _audioStreamController = StreamController<Uint8List>.broadcast();
    _isPlaying = false;
    _audioPlayer = AudioPlayer();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _initAudioFetching();
    });
  }

  @override
  void dispose() {
    // Dispose all the resources
    _audioStreamController.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  String songId = '';
  Future<void> _initAudioFetching() async {
    if (!_hasFetchedAudio && !_isFetchingAudio) {
      _isFetchingAudio = true; // Indicate that fetching is in progress
      final HomeProvider provider =
          Provider.of<HomeProvider>(context, listen: false);
      final Song song = provider.songs[widget.index];
      songId = song.title; // Assuming each song has a unique title attribute

      try {
        _audioFilePath = await provider.fetchAndSaveAudio(song.songUrl, songId);
        _hasFetchedAudio = true;
        _isFetchingAudio = false;
        _fetchErrorOccurred = false; // Reset error state if any
        setState(() {});
      } catch (e) {
        _isFetchingAudio = false;
        _fetchErrorOccurred = true; // Set error state
        print('Error fetching and saving audio: $e');
        setState(() {}); // Update UI to show error message
      }
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(
          UrlSource(_audioFilePath)); // Changed from AssetSource to UrlSource
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider provider = Provider.of<HomeProvider>(context);
    song = provider.songs[widget.index];

    // If the audio has been fetched, display the audio player widget, else show a loading indicator.
    Widget content;
    if (_hasFetchedAudio) {
      content = buildAudioPlayerWidget(); // Define your audio player UI here
    } else {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 90,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.dark2(),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ),
      body: content,
    );
  }

  Widget buildAudioPlayerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            // Your image
            Hero(
              tag: "song_image_details",
              child: Image.network(
                song!.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 1.2,
                fit: BoxFit.fill,
              ),
            ),
            // Linear gradient to fade the bottom of the image
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black, // Fade starts at 80% opacity
                    ],
                    stops: [0.8, 1.0], // Stop points for the gradient
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        // Audio player widget
        StreamBuilder<Uint8List>(
          stream: _audioStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                onTap: _togglePlayPause,
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 48,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        Text(
          'Take you home',
          style: AppTextStyles.header.copyWith(fontFamily: "Michroma"),
        ),
        const SizedBox(height: 10),
        Text('Kang',
            style: AppTextStyles.subHeader.copyWith(
                fontFamily: "OldTurkic",
                letterSpacing: 1.2,
                color: Colors.grey)),
        const SizedBox(height: 35),
        Container(
          width: 300,
          height: 100,
          // Replace with your music waves widget
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassmorphicContainer(
              width: 65,
              height: 65,
              borderRadius: 40,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: 2,
              blur: 10,
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.greenYellow().withOpacity(0.5),
                  AppColors.greenYellow().withOpacity(0.2),
                ],
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.backward_end_fill,
                  size: 24,
                  color: AppColors.greenYellow(),
                ),
              ),
            ),
            const SizedBox(width: 25),
            GlassmorphicContainer(
              width: 90,
              height: 90,
              borderRadius: 50,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.greenYellow().withOpacity(0.9),
                  AppColors.greenYellow().withOpacity(0.6),
                ],
              ),
              border: 2,
              blur: 10,
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.dark2(),
                  AppColors.dark3(),
                ],
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.pause_fill,
                  size: 30,
                  color: AppColors.dark2(),
                ),
              ),
            ),
            const SizedBox(width: 25),
            GlassmorphicContainer(
              width: 65,
              height: 65,
              borderRadius: 40,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: 2,
              blur: 10,
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.greenYellow().withOpacity(0.5),
                  AppColors.greenYellow().withOpacity(0.2),
                ],
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.forward_end_fill,
                  size: 24,
                  color: AppColors.greenYellow(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
