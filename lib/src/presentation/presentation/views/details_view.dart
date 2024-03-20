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
  Duration? _duration;
  Duration? _position;
  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _audioPlayer = AudioPlayer();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _initAudioFetching();
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      // Duration of the audio file
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      // Current position of the audio file
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = _duration;
      });
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
      song = provider.songs[widget.index];
      songId = song!.title; // Assuming each song has a unique title attribute

      try {
        _audioFilePath =
            await provider.fetchAndSaveAudio(song!.songUrl, songId);
        _hasFetchedAudio = true;
        _isFetchingAudio = false;
        _fetchErrorOccurred = false; // Reset error state if any

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            // Start playback immediately after fetching audio successfully
            _audioPlayer.play(UrlSource(_audioFilePath));
            _isPlaying = true;
          });
        }
      } catch (e) {
        _isFetchingAudio = false;
        _fetchErrorOccurred = true; // Set error state
        print('Error fetching and saving audio: $e');
        if (mounted) {
          setState(() {}); // Update UI to show error message
        }
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
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
        Text(
          song!.title,
          style: AppTextStyles.header.copyWith(fontFamily: "Michroma"),
        ),
        const SizedBox(height: 10),
        Text(song!.artist,
            style: AppTextStyles.subHeader.copyWith(
                fontFamily: "OldTurkic",
                letterSpacing: 1.2,
                color: Colors.grey)),
        const SizedBox(height: 35),
        SliderTheme(
          data: const SliderThemeData(
            trackHeight: 3,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
          ),
          child: Slider(
            value: _position?.inSeconds.toDouble() ?? 0,
            min: 0,
            max: _duration?.inSeconds.toDouble() ?? 1,
            onChanged: (value) {
              setState(() {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position ?? Duration.zero),
                  style: AppTextStyles.subHeader
                      .copyWith(color: AppColors.dark3(), fontSize: 12)),
              Text(_formatDuration(_duration ?? Duration.zero),
                  style: AppTextStyles.subHeader
                      .copyWith(color: AppColors.dark3(), fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 30),
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
