import 'package:flutter/material.dart';

class VoiceAssistantPage extends StatefulWidget {
  const VoiceAssistantPage({Key? key}) : super(key: key);

  @override
  State<VoiceAssistantPage> createState() => _VoiceAssistantPageState();
}

class _VoiceAssistantPageState extends State<VoiceAssistantPage> {
  // Gemini integration and all related code removed as per user request.

  // You may implement another assistant or leave this file as a placeholder.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
      ),
      body: const Center(
        child: Text('Voice Assistant Page'),
      ),
    );
  }
}
