import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/firestore_service.dart';
import '../utils/input_validator.dart';
import '../constants/retro_theme.dart';

///
/// AddProjectScreen - UI form to create new projects in Firestore
///
/// Features:
/// - Project name and description input
/// - Client selection (from dropdown)
/// - Budget input with validation
/// - Start and end date pickers
/// - Input validation on all fields
/// - Secure write to Firestore
/// - Success/error feedback
///
class AddProjectScreen extends StatefulWidget {
  final String userId;
  final String clientId;

  const AddProjectScreen({
    Key? key,
    required this.userId,
    required this.clientId,
  }) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;

  String _selectedStatus = 'not_started';
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;

  final List<String> _statusOptions = ['not_started', 'in_progress', 'on_hold'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _budgetController = TextEditingController();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  Future<void> _addProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newProject = ProjectModel(
        id: '',
        userId: widget.userId,
        clientId: widget.clientId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        budget: double.tryParse(_budgetController.text) ?? 0.0,
        status: _selectedStatus,
        startDate: _startDate,
        endDate: _endDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        taskCount: 0,
        completedCount: 0,
      );

      final projectId = await _firestoreService.createProject(newProject);

      if (projectId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Project created successfully'),
            backgroundColor: Colors.green[700],
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✗ Failed to create project'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('➕ Add New Project'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project name
              _buildLabel('Project Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Enter project name'),
                validator: InputValidator.validateProjectName,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Description
              _buildLabel('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: _buildInputDecoration('Enter project description'),
                maxLines: 3,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Budget
              _buildLabel('Budget'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _budgetController,
                decoration: _buildInputDecoration('Enter budget amount'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: InputValidator.validateBudget,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Status
              _buildLabel('Status'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: _buildInputDecoration('Select status'),
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
              const SizedBox(height: 16),

              // Start and End dates
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Start Date'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _isLoading ? null : _selectStartDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey[700]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: RetroColors.neonCyan,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('End Date'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _isLoading ? null : _selectEndDate,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey[700]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: RetroColors.neonCyan,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RetroColors.neonCyan,
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
                          'Create Project',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
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
