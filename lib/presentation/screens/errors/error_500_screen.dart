// lib/screens/errors/error_500_screen.dart
import 'package:flutter/material.dart';

class Error500Screen extends StatelessWidget {
  const Error500Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Server Error')),
      body: const Center(child: Text('Internal server error')),
    );
  }
}