import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dsync_meetup_app/logic/event/event_cubit.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EventForm extends StatefulWidget {
  final String clubId;
  final Event? existingEvent;

  const EventForm({
    required this.clubId,
    this.existingEvent,
    super.key,
  });

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _locationController;
  late DateTimeRange _dateTimeRange;
  String? _category;
  int? _capacity;

  final List<String> _categories = [
    'Workshop',
    'Social',
    'Lecture',
    'Networking',
    'Hackathon'
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existingEvent;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _descController = TextEditingController(text: existing?.description ?? '');
    _locationController = TextEditingController(text: existing?.location ?? '');
    _dateTimeRange = existing != null
        ? DateTimeRange(start: existing.startTime, end: existing.endTime)
        : DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(hours: 2)),
          );
    _category = existing?.category;
    _capacity = existing?.capacity;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? startDate = await showDatePicker(
      context: context,
      initialDate: _dateTimeRange.start,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (startDate == null) return;
    if (!mounted) return;

    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTimeRange.start),
    );

    if (startTime == null) return;
    if (!mounted) return;

    final DateTime? endDate = await showDatePicker(
      context: context,
      initialDate: _dateTimeRange.end,
      firstDate: startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (endDate == null) return;
    if (!mounted) return;

    final TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTimeRange.end),
    );

    if (endTime == null) return;
    if (!mounted) return;

    setState(() {
      _dateTimeRange = DateTimeRange(
        start: DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          startTime.hour,
          startTime.minute,
        ),
        end: DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          endTime.hour,
          endTime.minute,
        ),
      );
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _category != null) {
      final event = Event(
        id: widget.existingEvent?.id ?? const Uuid().v4(),
        clubId: widget.clubId,
        title: _titleController.text,
        description: _descController.text,
        startTime: _dateTimeRange.start,
        endTime: _dateTimeRange.end,
        location: _locationController.text,
        category: _category!,
        capacity: _capacity,
        participantIds: widget.existingEvent?.participantIds ?? const [],
      imageUrl: widget.existingEvent?.imageUrl ?? '', // Add default empty string or placeholder
      );

      final cubit = context.read<EventCubit>();
      if (widget.existingEvent != null) {
        cubit.updateEvent(event);
      } else {
        cubit.createEvent(event);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventCubit, EventState>(
      listener: (context, state) {
        if (state is EventCreatedSuccessfully || state is EventUpdatedSuccessfully) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Event ${widget.existingEvent != null ? 'updated' : 'created'} successfully',
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.existingEvent != null ? 'Edit Event' : 'Create Event'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title*'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location*'),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value),
                  decoration: const InputDecoration(labelText: 'Category*'),
                  validator: (value) => value == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date & Time*'),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(_dateTimeRange.start)}, '
                    '${DateFormat.jm().format(_dateTimeRange.start)} - '
                    '${DateFormat.jm().format(_dateTimeRange.end)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDateTime(context),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Capacity (optional)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final num = int.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Enter a valid number';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) => _capacity = int.tryParse(value),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Save Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
