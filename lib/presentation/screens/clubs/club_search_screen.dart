import 'package:flutter/material.dart';

class ClubSearchScreen extends StatefulWidget {
  const ClubSearchScreen({super.key});

  @override
  State<ClubSearchScreen> createState() => _ClubSearchScreenState();
}

class _ClubSearchScreenState extends State<ClubSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchClubs(String query) {
    setState(() {
      _searchResults = List.generate(
        5,
        (index) => 'Club ${index + 1} matching "$query"',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search clubs...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _searchClubs(_searchController.text),
            ),
          ),
          onSubmitted: _searchClubs,
        ),
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_searchResults[index]),
            onTap: () {
              // Navigate to club details
            },
          );
        },
      ),
    );
  }
}