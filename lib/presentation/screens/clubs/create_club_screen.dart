import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dsync_meetup_app/logic/club/club_cubit.dart';
import 'package:dsync_meetup_app/data/models/club_model.dart';
import 'package:dsync_meetup_app/data/services/club_service.dart';

class CreateClubScreen extends StatelessWidget {
  const CreateClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClubCubit(ClubService()),
      child: const CreateClubForm(),
    );
  }
}

class CreateClubForm extends StatefulWidget {
  const CreateClubForm({super.key});

  @override
  State<CreateClubForm> createState() => _CreateClubFormState();
}

class _CreateClubFormState extends State<CreateClubForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final cubit = context.read<ClubCubit>();

      try {
        await cubit.createClub(
          ClubModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameController.text.trim(),
            description: _descController.text.trim(),
            category: _categoryController.text.trim(), // ✅ FIX
            imageUrl: 'https://example.com/default_club.jpg',
            members: [],
            admins: [],
            createdAt: DateTime.now(),
          ),
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Club created successfully!')),
        );
        context.pop();

      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create club: $e')),
        );
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
      appBar: AppBar(title: const Text('Create Club')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Club Name'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'), // ✅ Added
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Club'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
