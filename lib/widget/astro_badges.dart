import 'package:flutter/material.dart';

/// Overlays a small boost icon top-right on [child] when [show] is true.
/// Does not change [child]'s own size or layout.
class BoostWrap extends StatelessWidget {
  final Widget child;
  final bool show;
  const BoostWrap({Key? key, required this.child, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!show) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
            child: const Icon(Icons.bolt, size: 12, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

/// Small "Emergency" chip overlaid top-right, used when emergency access
/// is enabled for that service (chat or call/video).
class EmergencyWrap extends StatelessWidget {
  final Widget child;
  final bool show;
  const EmergencyWrap({Key? key, required this.child, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!show) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -6,
          left: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
            child: const Text('Emergency', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}