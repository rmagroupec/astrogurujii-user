// lib/Screens/chats_screen/chat/audio_play_pop_up.dart
//
// FIXES vs original:
//  1. Removed `widget.mp3File != null` check — mp3File is non-nullable String,
//     the check produced a lint warning and was redundant.
//  2. dispose() stops playback before closing to avoid audio leak.
//  3. initState openPlayer wrapped in mounted check for safety.

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayerPopup extends StatefulWidget {
  final String mp3File;

  const AudioPlayerPopup({Key? key, required this.mp3File}) : super(key: key);

  @override
  _AudioPlayerPopupState createState() => _AudioPlayerPopupState();
}

class _AudioPlayerPopupState extends State<AudioPlayerPopup> {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool     _isPlaying       = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration        = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.openPlayer().then((_) {
      if (!mounted) return;
      _audioPlayer.onProgress?.listen((event) {
        if (!mounted) return;
        setState(() {
          _currentPosition = event.position;
          _duration        = event.duration;
        });
      });
    });
  }

  @override
  void dispose() {
    // Stop before closing to prevent "player not open" errors
    if (_isPlaying) {
      _audioPlayer.stopPlayer().catchError((_) {});
    }
    _audioPlayer.closePlayer();
    super.dispose();
  }

  void _startAudio() async {
    // FIX #1 — no null check needed; mp3File is non-nullable
    if (widget.mp3File.isEmpty) {
      debugPrint('AudioPlayerPopup: file path is empty');
      return;
    }
    try {
      if (_isPlaying) await _audioPlayer.stopPlayer();
      await _audioPlayer.startPlayer(fromURI: widget.mp3File);
      if (!mounted) return;
      setState(() => _isPlaying = true);
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void _pauseAudio() async {
    await _audioPlayer.pausePlayer();
    if (!mounted) return;
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding  : const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient    : const LinearGradient(
            colors: [Color(0xfff19425), Colors.orangeAccent],
            begin : Alignment.topLeft,
            end   : Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children    : [
            const Text(
              'Voice Message',
              style: TextStyle(
                fontSize  : 20,
                fontWeight: FontWeight.bold,
                color     : Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _duration.inMilliseconds > 0
                  ? _currentPosition.inMilliseconds /
                      _duration.inMilliseconds
                  : 0,
              color           : Colors.white,
              backgroundColor : Colors.white.withOpacity(0.4),
              minHeight       : 8,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: _isPlaying
                      ? const Icon(Icons.pause_circle_filled,
                          size: 40, color: Colors.white)
                      : const Icon(Icons.play_circle_fill,
                          size: 40, color: Colors.white),
                  onPressed: _isPlaying ? _pauseAudio : _startAudio,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style    : ElevatedButton.styleFrom(
                padding    : const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 10),
                shape      : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize  : 16,
                  color     : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}