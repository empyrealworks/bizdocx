import 'dart:ui';
import 'package:flutter/material.dart';

class PrivacyOverlay extends StatefulWidget {
  final Widget child;
  const PrivacyOverlay({super.key, required this.child});

  @override
  State<PrivacyOverlay> createState() => _PrivacyOverlayState();
}

class _PrivacyOverlayState extends State<PrivacyOverlay> with WidgetsBindingObserver {
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      // Show overlay when app is inactive, paused, or hidden (app switcher)
      _showOverlay = state != AppLifecycleState.resumed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showOverlay)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                color: Colors.white.withAlpha(204), // Soft white overlay
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_small.png',
                    height: 100,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
