import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskBottomSheet({super.key, required this.onAddTask});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.medium;
  String _selectedCategory = 'Work';

  final List<String> _categories = ['Work', 'Personal', 'Shopping', 'Health', 'Finance'];

  void _submitTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty) {
      return;
    }

    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description.isEmpty ? null : description,
      priority: _selectedPriority,
      category: _selectedCategory,
    );

    widget.onAddTask(newTask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create New Task',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Task Title Field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'What needs to be done?',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          // Task Description Field
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'Add some details...',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          // Priority Selection
          const Text(
            'Priority',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: TaskPriority.values.map((priority) {
              final isSelected = _selectedPriority == priority;
              Color color;
              switch (priority) {
                case TaskPriority.high:
                  color = Colors.redAccent;
                  break;
                case TaskPriority.medium:
                  color = Colors.orangeAccent;
                  break;
                case TaskPriority.low:
                  color = Colors.blueAccent;
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    priority.name.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: color,
                  backgroundColor: color.withValues(alpha: 0.1),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Category Selection
          const Text(
            'Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _submitTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
