import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noviindus_round_2/core/extensions/margin_extension.dart';
import 'package:noviindus_round_2/shared/utils/screen_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import '../../../../core/style/app_text_style.dart';
import '../../../../core/style/colors.dart';

class VideoPostCard extends StatefulWidget {
  final String profileImage;
  final String name;
  final String time;
  final String videoUrl;
  final String description;

  const VideoPostCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.time,
    required this.videoUrl,
    required this.description,
  });

  @override
  State<VideoPostCard> createState() => _VideoPostCardState();
}

class _VideoPostCardState extends State<VideoPostCard> {
  late VideoPlayerController _controller;

  bool isInitialized = false;
  bool showControls = true;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {
              isInitialized = true;
            });
          });

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      showControls = true;
    } else {
      _controller.play();
      showControls = false;
    }
    setState(() {});
  }

  void toggleControls() {
    setState(() {
      showControls = !showControls;
    });
  }

  void openFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideo(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final position = _controller.value.position;
    final duration = _controller.value.duration;

    return Container(
      color: const Color.fromARGB(255, 32, 31, 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: widget.profileImage.isEmpty
                      ? const AssetImage("assets/images/User-Profile.png")
                      : NetworkImage(widget.profileImage) as ImageProvider,
                ),
                15.w.wBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppTextStyles.textStyle_500_14.copyWith(
                        fontSize: 13,
                        color: whiteClr,
                      ),
                    ),
                    3.h.hBox,
                    Text(
                      DateFormat("dd / MM / yyyy")
                          .format(DateTime.parse(widget.time)),
                      style: AppTextStyles.textStyle_400_14.copyWith(
                        fontSize: 10,
                        color: textClr2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: toggleControls,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isInitialized)
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                else
                  Container(
                    height: 220,
                    color: Colors.black,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: redClr2,
                        radius: 16,
                      ),
                    ),
                  ),
                if (showControls && isInitialized)
                  IconButton(
                    iconSize: 60,
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: whiteClr,
                    ),
                    onPressed: togglePlayPause,
                  ),
                if (isInitialized)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: showControls ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        color: Colors.black.withOpacity(0.6),
                        child: Column(
                          children: [
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                              colors: VideoProgressColors(
                                playedColor: redClr2,
                                bufferedColor:
                                    whiteClr.withOpacity(0.4),
                                backgroundColor:
                                    Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${formatDuration(position)} / ${formatDuration(duration)}",
                                style: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr)
                                ),
                                IconButton(
                                  onPressed: openFullScreen,
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          10.h.hBox,

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.description,
              style: AppTextStyles.textStyle_400_14.copyWith(
                color: textClr2,
                fontSize: 12,
              ),
            ),
          ),

          10.h.hBox,
        ],
      ),
    );
  }
}


class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({super.key, required this.controller});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool showControls = true;

  void toggleControls() {
    setState(() {
      showControls = !showControls;
    });
  }

  void togglePlayPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      showControls = true;
    } else {
      widget.controller.play();
      showControls = false;
    }
    setState(() {});
  }

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final position = widget.controller.value.position;
    final duration = widget.controller.value.duration;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: toggleControls,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: VideoPlayer(widget.controller),
                ),
              ),
              if (showControls)
                Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Screen.close(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: whiteClr,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          iconSize: 70,
                          onPressed: togglePlayPause,
                          icon: Icon(
                            widget.controller.value.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: whiteClr,
                          ),
                        ),
                        Column(
                          children: [
                            VideoProgressIndicator(
                              widget.controller,
                              allowScrubbing: true,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              colors: VideoProgressColors(
                                playedColor: Colors.redAccent,
                                bufferedColor: Colors.white54,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDuration(position),
                                    style: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr)
                                  ),
                                  Text(
                                    formatDuration(duration),
                                   style: AppTextStyles.textStyle_400_14.copyWith(color: whiteClr)
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
