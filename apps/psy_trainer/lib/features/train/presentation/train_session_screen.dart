import 'package:flutter/widgets.dart';

/// Placeholder for a training session. Exists to demonstrate the nested route
/// pattern (`/train/session/:sessionId`); replaced in US-051.
class TrainSessionScreen extends StatelessWidget {
  const TrainSessionScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(child: Text('Session $sessionId')));
  }
}
