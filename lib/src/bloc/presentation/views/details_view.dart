import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:nymtune/src/core/theme/app_colors.dart';
import 'package:nymtune/src/core/theme/app_text_styles.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

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
          )),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Your image
              Hero(
                tag: "song_image_details",
                child: Image.network(
                  "https://images-platform.99static.com/bi6KeQq1GTyLD_yseZT3QsR1Brc=/0x0:2000x2000/500x500/top/smart/99designs-contests-attachments/127/127640/attachment_127640646",
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
                    Colors.white.withOpacity(0.1)
                  ],
                ),
                border: 2,
                blur: 10,
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.greenYellow().withOpacity(0.5),
                    AppColors.greenYellow().withOpacity(0.2)
                  ],
                ),
                child: Center(
                  child: Icon(CupertinoIcons.backward_end_fill,
                      size: 24, color: AppColors.greenYellow()),
                ),
              ),

              const SizedBox(
                  width: 25), // Adjust the spacing between icons as needed
              GlassmorphicContainer(
                width: 90,
                height: 90,
                borderRadius: 50,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.greenYellow().withOpacity(0.9),
                    AppColors.greenYellow().withOpacity(0.6)
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
                  child: Icon(CupertinoIcons.pause_fill,
                      size: 30, color: AppColors.dark2()),
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
                    Colors.white.withOpacity(0.1)
                  ],
                ),
                border: 2,
                blur: 10,
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.greenYellow().withOpacity(0.5),
                    AppColors.greenYellow().withOpacity(0.2)
                  ],
                ),
                child: Center(
                  child: Icon(CupertinoIcons.forward_end_fill,
                      size: 24, color: AppColors.greenYellow()),
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
