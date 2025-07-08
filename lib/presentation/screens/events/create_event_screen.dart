import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:dsync_meetup_app/logic/event/event_cubit.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/widgets/events/date_picker.dart';

class ImageUploadProvider with ChangeNotifier {
  List<File> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0;

  List<File> get images => _images;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;

  void addImages(List<File> newImages) {
    _images.addAll(newImages);
    notifyListeners();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  void updateProgress(double progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

  void reset() {
    _images = [];
    _isUploading = false;
    _uploadProgress = 0;
    notifyListeners();
  }
}

class CreateEventScreen extends StatefulWidget {
  final String clubId;
  final Event? existingEvent;

  const CreateEventScreen({
    super.key,
    required this.clubId,
    this.existingEvent,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _capacityController = TextEditingController();

  late DateTime _startTime;
  late DateTime _endTime;
  bool _isOnline = false;
  bool _isSubmitting = false;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _startTime = widget.existingEvent?.startTime ?? DateTime.now().add(const Duration(hours: 1));
    _endTime = widget.existingEvent?.endTime ?? _startTime.add(const Duration(hours: 2));
    
    if (widget.existingEvent != null) {
      _titleController.text = widget.existingEvent!.title;
      _descriptionController.text = widget.existingEvent!.description;
      _locationController.text = widget.existingEvent!.location;
      _categoryController.text = widget.existingEvent!.category;
      _capacityController.text = widget.existingEvent!.capacity?.toString() ?? '';
      _isOnline = widget.existingEvent!.location.startsWith('http');
    }
  }

  Future<List<File>> _pickAndCropImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    final List<File> croppedImages = [];
    if (pickedFiles.isNotEmpty) {
      for (final pickedFile in pickedFiles) {
        final croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          croppedImages.add(croppedFile);
        }
      }
    }
    return croppedImages;
  }

  Future<File?> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    final List<String> urls = [];
    final storage = FirebaseStorage.instance;
    final imageProvider = context.read<ImageUploadProvider>();

    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final fileName = '${_uuid.v4()}.jpg';
      final ref = storage.ref().child('events/${widget.clubId}/$fileName');
      final uploadTask = ref.putFile(image);
      
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        imageProvider.updateProgress(
          (i + progress) / images.length
        );
      });

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageUploadProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.existingEvent != null ? 'Edit Event' : 'Create Event'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ImageUploadProvider>().reset();
              context.pop();
            },
          ),
        ),
        body: BlocListener<EventCubit, EventState>(
          listener: (context, state) {
            if (state is EventCreatedSuccessfully) {
              context.read<ImageUploadProvider>().reset();
              context.pop(state.event);
            }
            if (state is EventUpdatedSuccessfully) {
              context.read<ImageUploadProvider>().reset();
              context.pop(state.event);
            }
            if (state is EventError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              setState(() => _isSubmitting = false);
              context.read<ImageUploadProvider>().setUploading(false);
            }
          },
          child: Consumer<ImageUploadProvider>(
            builder: (context, imageProvider, _) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildImagePickerSection(imageProvider),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Event Title *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description *',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SwitchListTile(
                            title: const Text('Online Event'),
                            value: _isOnline,
                            onChanged: (value) => setState(() => _isOnline = value),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: _isOnline ? 'Meeting Link *' : 'Location *',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _isOnline ? 'Enter meeting link' : 'Enter location';
                              }
                              if (_isOnline && !value.startsWith('http')) {
                                return 'Enter valid URL';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Category *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a category';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _capacityController,
                            decoration: const InputDecoration(
                              labelText: 'Capacity (optional)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Event Time *',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: DatePicker(
                                  initialDate: _startTime,
                                  onDateSelected: (date) => _updateDateTime(date, _startTime),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _selectTime(context, true),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      TimeOfDay.fromDateTime(_startTime).format(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: DatePicker(
                                  initialDate: _endTime,
                                  onDateSelected: (date) => _updateDateTime(date, _endTime),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _selectTime(context, false),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      TimeOfDay.fromDateTime(_endTime).format(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: (imageProvider.isUploading || _isSubmitting)
                                ? null
                                : () => _submitForm(imageProvider),
                            child: _isSubmitting
                                ? const CircularProgressIndicator()
                                : Text(widget.existingEvent != null ? 'UPDATE EVENT' : 'CREATE EVENT'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (imageProvider.isUploading) _buildUploadProgress(imageProvider),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection(ImageUploadProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Images (Max 5)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (provider.images.isNotEmpty || widget.existingEvent?.imageUrl.isNotEmpty == true)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.images.length + (widget.existingEvent?.imageUrl.length ?? 0),
              itemBuilder: (context, index) {
                if (index < provider.images.length) {
                  return _buildImageThumbnail(
                    image: provider.images[index],
                    isNew: true,
                    index: index,
                    provider: provider,
                  );
                } else {
                  final urlIndex = index - provider.images.length;
                  return _buildNetworkImageThumbnail(
                    url: widget.existingEvent!.imageUrl[urlIndex],
                  );
                }
              },
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: provider.images.length >= 5 ? null : () async {
            final images = await _pickAndCropImages();
            if (images.isNotEmpty) {
              provider.addImages(images);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_photo_alternate),
              SizedBox(width: 8),
              Text('Add Images'),
            ],
          ),
        ),
        if (provider.images.length >= 5)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Maximum 5 images allowed',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildImageThumbnail({
    required File image,
    required bool isNew,
    required int index,
    required ImageUploadProvider provider,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => provider.removeImage(index),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          if (isNew)
            const Positioned(
              bottom: 4,
              left: 4,
              child: Chip(
                label: Text('New'),
                backgroundColor: Colors.blue,
                labelStyle: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNetworkImageThumbnail({required String url}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            bottom: 4,
            left: 4,
            child: Chip(
              label: Text('Existing'),
              backgroundColor: Colors.green,
              labelStyle: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadProgress(ImageUploadProvider provider) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: provider.uploadProgress,
              strokeWidth: 4,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Uploading ${(provider.uploadProgress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStartTime ? _startTime : _endTime),
    );
    if (time != null) {
      setState(() {
        final date = isStartTime ? _startTime : _endTime;
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        if (isStartTime) {
          _startTime = newDateTime;
          if (_endTime.isBefore(_startTime)) {
            _endTime = _startTime.add(const Duration(hours: 1));
          }
        } else {
          _endTime = newDateTime;
        }
      });
    }
  }

  void _updateDateTime(DateTime newDate, DateTime originalTime) {
    setState(() {
      if (originalTime == _startTime) {
        _startTime = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          _startTime.hour,
          _startTime.minute,
        );
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1));
        }
      } else {
        _endTime = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          _endTime.hour,
          _endTime.minute,
        );
      }
    });
  }

  Future<void> _submitForm(ImageUploadProvider imageProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    imageProvider.setUploading(true);

    try {
      // Upload new images
      List<String> imageUrls = [];
      if (imageProvider.images.isNotEmpty) {
        imageUrls = await _uploadImages(imageProvider.images);
      }

      // Keep existing images if editing
      if (widget.existingEvent != null) {
        imageUrls.addAll([widget.existingEvent!.imageUrl]);
      }

      final event = Event(
        id: widget.existingEvent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        clubId: widget.clubId,
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: _startTime,
        endTime: _endTime,
        location: _locationController.text,
        category: _categoryController.text,
        capacity: _capacityController.text.isEmpty
            ? null
            : int.parse(_capacityController.text),
        participantIds: widget.existingEvent?.participantIds ?? const [],
        imageUrl: imageUrls.isNotEmpty ? imageUrls.first : '',
        coverImageUrl: imageUrls.isNotEmpty ? imageUrls.first : '',
      );

      if (widget.existingEvent != null) {
        context.read<EventCubit>().updateEvent(event);
      } else {
        context.read<EventCubit>().createEvent(event);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading images: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isSubmitting = false);
      imageProvider.setUploading(false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _categoryController.dispose();
    _capacityController.dispose();
    super.dispose();
  }
}