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
  late String _audioFilePath;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioStreamController = StreamController<Uint8List>();
    _isPlaying = false;
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  @override
  void dispose() {
    _audioStreamController.close();
    _audioPlayer.dispose();
    // Clear temporary audio file
    Provider.of<HomeProvider>(context, listen: false)
        .clearTempAudio(_audioFilePath);
    super.dispose();
  }

  Future<void> _loadAudio() async {
    try {
      final HomeProvider provider =
          Provider.of<HomeProvider>(context, listen: false);
      final Song song = provider.songs[widget.index];
      // Fetch audio data and save it to a temporary file
      _audioFilePath = await provider.fetchAndSaveAudio(song.songUrl);
      // Play audio from the temporary file
      await _audioPlayer.play(AssetSource(_audioFilePath));
      setState(() {});
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                return CircularProgressIndicator();
              }
            },
          ),
          // Your other UI components
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
      ),
    );
  }
}
