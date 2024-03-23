import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';
import 'package:nymtune/src/presentation/presentation/responsive.dart';
import 'package:nymtune/src/presentation/presentation/views/dashboard.dart';
import 'package:nymtune/src/presentation/providers/song_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/song_model.dart';

class DetailsView extends StatefulWidget {
  final int index;

  const DetailsView({super.key, required this.index});

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late SongProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<SongProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeProvider.playAudio(_homeProvider.songs[widget.index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, provider, _) {
        final bool isSongReady =
            !_homeProvider.isFetchingAudio && _homeProvider.hasFetchedAudio;

        Widget content;
        if (provider.isLoading) {
          content = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.hasError) {
          content = Center(
            child: Text(provider.errorMessage),
          );
        } else {
          content = buildAudioPlayerWidget(context, isSongReady);
        }

        return ResponsiveWidget(
          maxWidth: 1900,
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leadingWidth: 80,
              leading: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                          milliseconds: 500), // Adjust duration as needed
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const DashboardView(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          )
                              .chain(CurveTween(curve: Curves.linear))
                              .animate(animation),
                          child: child,
                        );
                      },
                    ),
                    (route) => false, // Clear navigation history
                  );
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.dark2(),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.grey.shade200,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            body: content,
          ),
        );
      },
    );
  }

  Widget buildAudioPlayerWidget(BuildContext context, bool isSongReady) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    // Adjust sizes based on the screen size
    final double imageHeight = isLargeScreen
        ? MediaQuery.of(context).size.height * 0.70
        : MediaQuery.of(context).size.width * 1.5;

    final SongProvider homeProvider = Provider.of<SongProvider>(context);

    final Song? song = homeProvider.currentSong;
    final Duration? duration = homeProvider.duration;
    final Duration? position = homeProvider.position;
    final bool isPlaying = homeProvider.isPlaying;

    if (song == null) {
      return Container(); // Return an empty container if song is null
    }

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
                song.imageUrl,
                width: double.infinity, // Adjust for web
                height: imageHeight, // Adjust for web

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            song.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.header.copyWith(fontFamily: "Michroma"),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            song.artist,
            textAlign: TextAlign.center,
            style: AppTextStyles.subHeader.copyWith(
              fontFamily: "OldTurkic",
              letterSpacing: 1.2,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 35),
        SliderTheme(
          data: SliderThemeData(
              trackHeight: 3,
              activeTrackColor: AppColors.greenYellow(),
              overlayColor: AppColors.greenYellow(),
              inactiveTrackColor: Colors.amber.withOpacity(0.5),
              thumbColor: AppColors.greenYellow(),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              activeTickMarkColor: AppColors.greenYellow()),
          child: Slider(
            value: position?.inSeconds.toDouble() ?? 0,
            min: 0,
            max: duration?.inSeconds.toDouble() ?? 1,
            onChanged: (value) {
              homeProvider.seek(Duration(seconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position ?? Duration.zero),
                style: AppTextStyles.subHeader.copyWith(
                  color: AppColors.greenYellow(),
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(duration ?? Duration.zero),
                style: AppTextStyles.subHeader.copyWith(
                  color: Colors.amber,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (widget.index != 0) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(
                          milliseconds: 500), // Adjust duration as needed
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DetailsView(index: widget.index - 1),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        // Customize your transition here (optional)
                        return SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero)
                              .animate(animation),
                          child: child,
                        );
                      },
                    ),
                    (route) => false, // Clear navigation history
                  );
                }
              },
              child: GlassmorphicContainer(
                width: 65,
                height: 65,
                borderRadius: 40,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.dark2(),
                    AppColors.dark3(),
                  ],
                ),
                border: 2,
                blur: 10,
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.index == 0
                      ? [Colors.transparent, Colors.transparent]
                      : [
                          AppColors.greenYellow().withOpacity(0.5),
                          AppColors.greenYellow().withOpacity(0.2),
                        ],
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.backward_end_fill,
                    size: 24,
                    color: widget.index == 0
                        ? AppColors.greenYellow().withOpacity(0.3)
                        : AppColors.greenYellow(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 25),
            GestureDetector(
              onTap: () {
                homeProvider.togglePlayPause();
              },
              child: GlassmorphicContainer(
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
                  child: isSongReady
                      ? Icon(
                          isPlaying
                              ? CupertinoIcons.pause_fill
                              : CupertinoIcons.play_fill,
                          size: 30,
                          color: AppColors.dark2(),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(width: 25),
            InkWell(
              onTap: () {
                if (homeProvider.songs.length < widget.index) ;
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(
                        milliseconds: 500), // Adjust duration as needed
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        DetailsView(index: widget.index + 1),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Customize your transition here (optional)
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .animate(animation),
                        child: child,
                      );
                    },
                  ),
                  (route) => false, // Clear navigation history
                );
              },
              child: GlassmorphicContainer(
                width: 65,
                height: 65,
                borderRadius: 40,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.dark2(),
                    AppColors.dark3(),
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
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(1, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
