// lib/screens/errors/error_404_screen.dart
import 'package:flutter/material.dart';

class Error404Screen extends StatelessWidget {
  const Error404Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Page not found')),
    );
  }
}