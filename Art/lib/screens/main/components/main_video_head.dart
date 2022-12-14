import 'dart:developer';

import 'package:art/config/responsive.dart';
import 'package:art/screens/main/vertical_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../data/constants.dart';
import '../../../model/content_model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainVideoHeader extends StatelessWidget {
  final Content featuredContent;
  const MainVideoHeader({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _MainVideoHeaderMobile(
        featuredContent: featuredContent,
      ),
      desktop: _ContentHeaderDesktop(
        featuredContent: featuredContent,
      ),
    );
  }
}

class _MainVideoHeaderMobile extends StatefulWidget {
  final Content featuredContent;
  const _MainVideoHeaderMobile({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  State<_MainVideoHeaderMobile> createState() => _MainVideoHeaderMobileState();
}

class _MainVideoHeaderMobileState extends State<_MainVideoHeaderMobile> {
  late VideoPlayerController _videoPlayerController;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.featuredContent.videoUrl!)
      ..initialize().then((_) => setState(() {}))
      ..setVolume(50)
      ..setLooping(true)
      ..setPlaybackSpeed(2);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _videoPlayerController.value.isPlaying
            ? _videoPlayerController.pause()
            : _videoPlayerController.play();
        setState(() {
          isPlaying = !isPlaying;
        });
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedCrossFade(
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController)),
              ),
              secondChild: Container(
                height: 500.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.featuredContent.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              crossFadeState: isPlaying
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: isPlaying ? 450 : 500.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            ),
          ),
          Positioned(
            bottom: 110,
            child: SizedBox(
              width: 250,
              child: Image.asset(widget.featuredContent.titleImageUrl!),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VerticalIconButton(
                  icon: Icons.add,
                  title: 'List',
                  onTap: () => log('MyList'),
                ),
                const _PlayButton(),
                VerticalIconButton(
                  icon: Icons.info_outline,
                  title: 'Info',
                  onTap: () => log('Info'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;
  const _ContentHeaderDesktop({Key? key, required this.featuredContent})
      : super(key: key);

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _videoPlayerController;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.featuredContent.videoUrl!)
      ..initialize().then((_) => setState(() {}))
      ..setVolume(0)
      ..play();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoPlayerController.value.isInitialized
                ? _videoPlayerController.value.aspectRatio
                : 2.344,
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Image.asset(
              widget.featuredContent.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.isInitialized
                  ? _videoPlayerController.value.aspectRatio
                  : 2.344,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60,
            right: 60,
            bottom: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   width: 250,
                //   child: Image.asset(widget.featuredContent.titleImageUrl!),
                // ),
                const SizedBox(
                  height: 15,
                ),
                // MyBuildAnimatedText(),
                Text(
                  widget.featuredContent.description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2.0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    const _PlayButton(),
                    const SizedBox(
                      width: 16,
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(25, 10, 30, 10),
                        ),
                      ),
                      onPressed: () => log('More Info'),
                      icon: const Icon(
                        Icons.info_outline,
                        size: 30,
                      ),
                      label: const Text(
                        'More Info',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    if (_videoPlayerController.value.isInitialized)
                      IconButton(
                        icon:
                        Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                        color: Colors.white,
                        iconSize: 30,
                        onPressed: () => setState(
                              () {
                            _isMuted
                                ? _videoPlayerController.setVolume(100)
                                : _videoPlayerController.setVolume(0);
                            _isMuted = _videoPlayerController.value.volume == 0;
                          },
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: !Responsive.isDesktop(context)
            ? MaterialStateProperty.all(
          const EdgeInsets.fromLTRB(15, 5, 20, 5),
        )
            : MaterialStateProperty.all(
          const EdgeInsets.fromLTRB(25, 10, 30, 10),
        ),
      ),
      onPressed: () {
        log('Play');
      },
      icon: const Icon(
        Icons.play_arrow,
        size: 30,
        color: Colors.black,
      ),
      label: const Text(
        'Play',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MyBuildAnimatedText extends StatelessWidget {
  const MyBuildAnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      // it applies same style to all the widgets under it
      style: Theme.of(context).textTheme.subtitle1!,
      maxLines: 1,
      child: Row(
        children: [
          // if (!Responsive.isMobileLarge(context))
          //   const FlutterCodedText(),

          if (!Responsive.isMobileLarge(context))
            const SizedBox(width: defaultPadding / 2),
          // const Text("I build "),
          Responsive.isMobile(context)
              ? const Expanded(child: AnimatedText())
              : const AnimatedText(),
          if (!Responsive.isMobileLarge(context))
            SizedBox(width: defaultPadding / 2),

          // if (!Responsive.isMobileLarge(context))
          //   FlutterCodedText(),
        ],
      ),
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        // TyperAnimatedText(
        //   "responsive web and mobile app.",
        //   speed: Duration(milliseconds: 60),
        // ),
        // TyperAnimatedText(
        //   "complete e-Commerce app UI.",
        //   speed: Duration(milliseconds: 60),
        // ),
        TyperAnimatedText(
          "Welcome to the art store.",
          speed: Duration(milliseconds: 60),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2.0, 4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        TyperAnimatedText(
         "I hope you can have a pleasant experience here.",
          speed: Duration(milliseconds: 60),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2.0, 4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FlutterCodedText extends StatelessWidget {
  const FlutterCodedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        text: "<",
        style: TextStyle(
          color: Colors.yellow,
        ),
        children: [
          TextSpan(
            text: "flutter",
            style: TextStyle(color: Colors.yellow),
          ),
          TextSpan(text: ">"),
        ],
      ),
    );
  }
}