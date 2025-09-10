import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';
import '../services/history_service.dart';

class PlayerPage extends StatefulWidget {
  final String slug;
  final String episodeTitle;
  final String url;
  PlayerPage({required this.slug, required this.episodeTitle, required this.url});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    try {
      _videoController = VideoPlayerController.network(widget.url);
      await _videoController!.initialize();
      final hist = Provider.of<HistoryService>(context, listen: false);
      final pos = hist.getPosition(widget.slug);
      if (pos > 0) {
        _videoController!.seekTo(Duration(milliseconds: (pos*1000).toInt()));
      }
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        allowFullScreen: true,
      );
    } catch (e) {
      print('Player init error: \$e');
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  void dispose() {
    final hist = Provider.of<HistoryService>(context, listen: false);
    if (_videoController != null) {
      final pos = _videoController!.value.position.inSeconds.toDouble();
      hist.savePosition(widget.slug, pos, episode: widget.episodeTitle);
    }
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.episodeTitle),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
        _chewieController != null ? Chewie(controller: _chewieController!) : Center(child: Text('Cannot play this video')),
    );
  }
}
