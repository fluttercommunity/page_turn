import 'package:flutter/material.dart';

import '../effects/index.dart';

class PageTurnImage extends StatefulWidget {
  const PageTurnImage({
    Key? key,
    required this.amount,
    required this.image,
    this.backgroundColor = const Color(0xFFFFFFCC),
  }) : super(key: key);

  final Animation<double> amount;
  final ImageProvider image;
  final Color backgroundColor;

  @override
  _PageTurnImageState createState() => _PageTurnImageState();
}

class _PageTurnImageState extends State<PageTurnImage> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  bool _isListeningToStream = false;

  late ImageStreamListener _imageListener;

  @override
  void initState() {
    super.initState();
    _imageListener = ImageStreamListener(_handleImageFrame);
  }

  @override
  void dispose() {
    _stopListeningToStream();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _resolveImage();
    if (TickerMode.of(context)) {
      _listenToStream();
    } else {
      _stopListeningToStream();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(PageTurnImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _resolveImage();
    }
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _resolveImage() {
    final ImageStream newStream = widget.image.resolve(createLocalImageConfiguration(context));
    _updateSourceStream(newStream);
  }

  void _handleImageFrame(ImageInfo imageInfo, bool synchronousCall) {
    setState(() => _imageInfo = imageInfo);
  }

  // Updates _imageStream to newStream, and moves the stream listener
  // registration from the old stream to the new stream (if a listener was
  // registered).
  void _updateSourceStream(ImageStream newStream) {
    if (_imageStream?.key == newStream.key) return;

    if (_isListeningToStream) _imageStream?.removeListener(_imageListener);

    _imageStream = newStream;
    if (_isListeningToStream) _imageStream?.addListener(_imageListener);
  }

  void _listenToStream() {
    if (_isListeningToStream) return;
    _imageStream?.addListener(_imageListener);
    _isListeningToStream = true;
  }

  void _stopListeningToStream() {
    if (!_isListeningToStream) return;
    _imageStream?.removeListener(_imageListener);
    _isListeningToStream = false;
  }

  @override
  Widget build(BuildContext context) {
    final imageInfo = _imageInfo;
    if (imageInfo != null) {
      return CustomPaint(
        painter: PageTurnEffect(
          amount: widget.amount,
          image: imageInfo.image,
          backgroundColor: widget.backgroundColor,
        ),
        size: Size.infinite,
      );
    } else {
      return const SizedBox();
    }
  }
}
