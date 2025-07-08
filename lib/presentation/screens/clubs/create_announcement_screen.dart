// Add these imports at the top of the file
import 'package:provider/provider.dart';
import 'package:dsync_meetup_app/data/models/announcement_model.dart';
import 'package:dsync_meetup_app/logic/announcement/announcement_cubit.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart'; // Add this import

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  final String clubId;

  const CreateAnnouncementScreen({super.key, required this.clubId});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitAnnouncement() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        final authState = context.read<AuthCubit>().state;
        final userId = authState is Authenticated ? authState.user.id : '';
        final announcement = AnnouncementModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          clubId: widget.clubId,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          authorId: userId,
          createdAt: DateTime.now(),
        );

        await context.read<AnnouncementCubit>().createAnnouncement(announcement);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Announcement published successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
            tooltip: 'Close',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Please enter announcement content' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAnnouncement,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Publish Announcement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
