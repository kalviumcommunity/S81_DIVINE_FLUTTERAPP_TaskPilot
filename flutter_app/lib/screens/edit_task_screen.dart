import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';
import '../utils/input_validator.dart';
import '../constants/retro_theme.dart';

///
/// EditTaskScreen - UI form to update existing tasks in Firestore
///
/// Features:
/// - Load existing task with FutureBuilder
/// - Edit title, description, status, priority
/// - Update due date
/// - Track actual hours worked
/// - Form validation on all fields
/// - Secure updates to Firestore
/// - Delete option (soft delete)
///
class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _actualHoursController;

  String _selectedStatus = 'pending';
  String _selectedPriority = 'medium';
  late DateTime _selectedDueDate;
  bool _isLoading = false;
  TaskModel? _loadedTask;

  final List<String> _statusOptions = ['pending', 'in_progress', 'on_hold', 'completed'];
  final List<String> _priorityOptions = ['low', 'medium', 'high', 'urgent'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _actualHoursController = TextEditingController();
    _selectedDueDate = DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _actualHoursController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updates = <String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': _selectedStatus,
        'priority': _selectedPriority,
        'dueDate': _selectedDueDate.toIso8601String(),
        'actualHours': int.tryParse(_actualHoursController.text) ?? 0,
      };

      final success =
          await _firestoreService.updateTask(widget.taskId, updates);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Task updated successfully'),
            backgroundColor: Colors.green[700],
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✗ Failed to update task'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✗ Error: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text(
          'This task will be marked as deleted. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _firestoreService.deleteTask(widget.taskId);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Task deleted'),
              backgroundColor: Colors.green[700],
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop(true);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✗ Failed to delete task'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✗ Error: $e'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _populateForm(TaskModel task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _actualHoursController.text = task.actualHours.toString();
    _selectedStatus = task.status;
    _selectedPriority = task.priority;
    _selectedDueDate = task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✏️ Edit Task'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: RetroColors.neonPink),
            onPressed: _isLoading ? null : _deleteTask,
            tooltip: 'Delete task',
          ),
        ],
      ),
      body: FutureBuilder<TaskModel?>(
        future: _firestoreService.getTaskById(widget.taskId),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(RetroColors.neonCyan),
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Not found
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Task not found'),
            );
          }

          final task = snapshot.data!;
          if (_loadedTask == null) {
            _populateForm(task);
            _loadedTask = task;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  _buildLabel('Task Title'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: _buildInputDecoration('Enter task title'),
                    validator: InputValidator.validateTaskTitle,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  _buildLabel('Description'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: _buildInputDecoration('Enter task description'),
                    maxLines: 4,
                    validator: InputValidator.validateTaskDescription,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Status and Priority
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Status'),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration:
                                  _buildInputDecoration('Select status'),
                              items: _statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.replaceAll('_', ' ')),
                                );
                              }).toList(),
                              onChanged: _isLoading
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedStatus = value;
                                        });
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Priority'),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedPriority,
                              decoration:
                                  _buildInputDecoration('Select priority'),
                              items: _priorityOptions.map((priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                );
                              }).toList(),
                              onChanged: _isLoading
                                  ? null
                                  : (value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedPriority = value;
                                        });
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Due date
                  _buildLabel('Due Date'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _isLoading ? null : _selectDueDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[700]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDueDate.day}/${_selectedDueDate.month}/${_selectedDueDate.year}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: RetroColors.neonCyan,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Actual hours
                  _buildLabel('Actual Hours Worked'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _actualHoursController,
                    decoration: _buildInputDecoration('Enter hours'),
                    keyboardType: TextInputType.number,
                    validator: InputValidator.validateHours,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Update button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RetroColors.neonGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.black),
                              ),
                            )
                          : const Text(
                              'Update Task',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: RetroColors.neonCyan.withOpacity(0.1),
                      border: Border.all(
                        color: RetroColors.neonCyan,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: RetroColors.neonCyan,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Changes are saved instantly to Firestore',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: RetroColors.neonCyan,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: RetroColors.neonCyan,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: RetroColors.neonCyan, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[900],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      errorStyle: const TextStyle(color: RetroColors.neonPink),
    );
  }
}
