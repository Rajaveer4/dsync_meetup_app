import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostScreen extends StatefulWidget {
  final String clubId;

  const CreatePostScreen({super.key, required this.clubId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final List<String> _attachments = [];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      // Here you would typically call your BLoC or service to create the post
      // Example:
      // await context.read<PostCubit>().createPost(
      //   content: _contentController.text,
      //   clubId: widget.clubId,
      //   attachments: _attachments,
      // );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully')),
      );
      
      // Navigate back using GoRouter
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(), // Go back using GoRouter
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
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'What would you like to share?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter post content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_attachments.isNotEmpty) ...[
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _attachments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            // Example attachment thumbnail
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, size: 40),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () {
                                  setState(() {
                                    _attachments.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () {
                      // Implement photo attachment logic
                      setState(() {
                        _attachments.add('photo_${_attachments.length + 1}');
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.link),
                    onPressed: () {
                      // Implement link attachment logic
                      setState(() {
                        _attachments.add('link_${_attachments.length + 1}');
                      });
                    },
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createPost,
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}