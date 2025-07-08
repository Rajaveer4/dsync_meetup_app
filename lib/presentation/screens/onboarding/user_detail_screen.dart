import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dsync_meetup_app/logic/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  DateTime? _selectedDate;
  String? _gender;
  File? _selectedImage;
  String? _selectedAvatarPath;
  final List<String> _avatars = List.generate(
    15,
    (index) => 'assets/onboarding/avatar${index + 1}.jpg',
  );

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authCubit = context.read<AuthCubit>();
    final currentUser = (authCubit.state as Authenticated).user;

    final updatedUser = currentUser.copyWith(
      username: _nicknameController.text,
      photoUrl: _selectedAvatarPath ?? _selectedImage?.path,
      updatedAt: DateTime.now(),
    );

    await authCubit.updateProfile(updatedUser);
    await authCubit.completeOnboarding();
    if (mounted) context.goNamed('locationScreen');
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _selectedAvatarPath = null;
      });
    }
  }

  ImageProvider? _getImage() {
    if (_selectedImage != null) return FileImage(_selectedImage!);
    if (_selectedAvatarPath != null) return AssetImage(_selectedAvatarPath!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Tell us about yourself",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Nickname
              const Text("Your Nicname please"),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nicknameController,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter nickname' : null,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 24),

              // Avatar/Photo Upload
              const Text("Upload Your Photo or select an Avatar"),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => _showImagePickerDialog(),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _getImage(),
                    child: _getImage() == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Date of birth
              const Text("When should we wish you"),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd / MM / yyyy').format(_selectedDate!)
                        : 'DD / MM / YYYY',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Gender
              const Text("Select Gender"),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
              ),

              const SizedBox(height: 32),

              // Avatar Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: _avatars.map((avatar) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatarPath = avatar;
                        _selectedImage = null;
                      });
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage(avatar),
                      radius: 30,
                      child: _selectedAvatarPath == avatar
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black45,
                              ),
                              child: const Icon(Icons.check, color: Colors.white),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
