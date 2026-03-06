import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/retro_theme.dart';
import '../services/firebase_storage_service.dart';

/// Media Upload Demo Screen
///
/// Interactive demonstration of Firebase Storage media upload capabilities.
/// Allows users to pick images, upload them, view progress, and manage files.
class MediaUploadDemoScreen extends StatefulWidget {
  final String userId;

  const MediaUploadDemoScreen({
    Key? key,
    this.userId = 'demo-user-id',
  }) : super(key: key);

  @override
  State<MediaUploadDemoScreen> createState() => _MediaUploadDemoScreenState();
}

class _MediaUploadDemoScreenState extends State<MediaUploadDemoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  // State management
  File? _selectedImage;
  String? _uploadedImageUrl;
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  List<Map<String, String>> _uploadedFiles = [];
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUploadedFiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load previously uploaded files from Firebase Storage
  Future<void> _loadUploadedFiles() async {
    try {
      setState(() => _errorMessage = null);
      final files = await _storageService.listFilesWithUrls(widget.userId);
      setState(() => _uploadedFiles = files);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load files: $e');
    }
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _successMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to pick image: $e');
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _successMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to capture image: $e');
    }
  }

  /// Upload selected image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      setState(() => _errorMessage = 'Please select an image first');
      return;
    }

    // Validate file
    if (!_storageService.validateFile(_selectedImage!)) {
      setState(() => _errorMessage = 'File validation failed');
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
      _uploadProgress = 0.0;
    });

    try {
      final String downloadUrl = await _storageService.uploadImage(
        _selectedImage!,
        widget.userId,
        onProgressUpdate: (progress) {
          setState(() => _uploadProgress = progress);
        },
      );

      setState(() {
        _uploadedImageUrl = downloadUrl;
        _uploadProgress = 1.0;
        _isUploading = false;
        _successMessage = 'Image uploaded successfully!';
      });

      // Reload file list
      await _loadUploadedFiles();

      // Clear selection after a moment
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _selectedImage = null);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Upload failed: $e';
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  /// Delete a file from Firebase Storage
  Future<void> _deleteFile(String filePath, int index) async {
    try {
      await _storageService.deleteFile(filePath);
      setState(() => _uploadedFiles.removeAt(index));
      setState(() => _successMessage = 'File deleted successfully');
    } catch (e) {
      setState(() => _errorMessage = 'Failed to delete file: $e');
    }
  }

  /// Copy download URL to clipboard
  Future<void> _copyUrlToClipboard(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Build image picker section
  Widget _buildImagePickerTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status messages
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  border: Border.all(color: Colors.red.shade600, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            if (_successMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  border: Border.all(color: Colors.green.shade600, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _successMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 16),

            // Selected image preview
            if (_selectedImage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preview:',
                    style: TextStyle(
                      color: RetroColors.neonCyan,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: RetroColors.neonPurple,
                        width: 3,
                      ),
                    ),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'File: ${_selectedImage!.path.split('/').last}',
                    style: const TextStyle(color: RetroColors.neonGreen),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Size: ${(_selectedImage!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                    style: const TextStyle(color: RetroColors.neonGreen),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // Image picker buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.image),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.neonCyan,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImageFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.neonMagenta,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Upload progress
            if (_isUploading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uploading...',
                    style: TextStyle(
                      color: RetroColors.neonOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _uploadProgress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade700,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        RetroColors.neonOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: RetroColors.neonOrange),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Upload button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadImage,
                icon: const Icon(Icons.upload),
                label: Text(_isUploading ? 'Uploading...' : 'Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RetroColors.neonGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: Colors.grey.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Display uploaded image
            if (_uploadedImageUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: RetroColors.neonCyan, thickness: 2),
                  const SizedBox(height: 12),
                  const Text(
                    'Uploaded Successfully!',
                    style: TextStyle(
                      color: RetroColors.neonGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: RetroColors.neonGreen,
                        width: 3,
                      ),
                    ),
                    child: Image.network(
                      _uploadedImageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Download URL:',
                    style: TextStyle(
                      color: RetroColors.neonCyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      border: Border.all(color: RetroColors.neonCyan, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SelectableText(
                      _uploadedImageUrl!,
                      style: const TextStyle(
                        color: RetroColors.neonCyan,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _copyUrlToClipboard(_uploadedImageUrl!),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy URL'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.neonCyan,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Build file management tab
  Widget _buildFileManagementTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Files',
                style: TextStyle(
                  color: RetroColors.neonPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _loadUploadedFiles,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: RetroColors.neonCyan,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_uploadedFiles.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No files uploaded yet',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _uploadedFiles.length,
                itemBuilder: (context, index) {
                  final file = _uploadedFiles[index];
                  return _buildFileCard(file, index);
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Build individual file card
  Widget _buildFileCard(Map<String, String> file, int index) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File name
            Text(
              file['name'] ?? 'Unknown',
              style: const TextStyle(
                color: RetroColors.neonGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // File path
            Text(
              'Path: ${file['path']}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyUrlToClipboard(file['url'] ?? ''),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy URL', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RetroColors.neonCyan,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () =>
                      _deleteFile(file['path'] ?? '', index),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build advanced features tab
  Widget _buildAdvancedFeaturesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File size information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                border: Border.all(color: RetroColors.neonCyan, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Max File Size',
                    style: TextStyle(
                      color: RetroColors.neonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(_storageService.getMaxFileSizeBytes() / 1024 / 1024).toStringAsFixed(0)} MB',
                    style: const TextStyle(
                      color: RetroColors.neonGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Allowed file types
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade900,
                border: Border.all(color: RetroColors.neonMagenta, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Allowed File Types',
                    style: TextStyle(
                      color: RetroColors.neonMagenta,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        _storageService.getAllowedFileExtensions()
                            .map((ext) => Chip(
                          label: Text(ext.toUpperCase()),
                          backgroundColor: RetroColors.neonMagenta,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                            .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Upload tips
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade900,
                border: Border.all(color: RetroColors.neonOrange, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Tips',
                    style: TextStyle(
                      color: RetroColors.neonOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem('Use high quality images', 0),
                  _buildTipItem('Compress large files before upload', 1),
                  _buildTipItem('Check your internet connection', 2),
                  _buildTipItem('Images are auto-optimized', 3),
                  _buildTipItem('URLs are permanent and shareable', 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build tip item
  Widget _buildTipItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '${index + 1}. ',
            style: const TextStyle(
              color: RetroColors.neonOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  /// Build code examples tab
  Widget _buildCodeExamplesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodeExample(
              'Upload Image',
              '''final File imageFile = File(picker.path);
final String url = await storage.uploadImage(
  imageFile,
  userId,
  onProgressUpdate: (progress) {
    print('\${(progress * 100).toInt()}%');
  },
);''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'Get Download URL',
              '''final String url = await storage
    .getDownloadUrl('uploads/user/image.jpg');
print(url); // Use in Image.network()''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'List User Files',
              '''final List<Map<String, String>> files =
    await storage.listFilesWithUrls(userId);

for (var file in files) {
  print(file['name']); // file name
  print(file['url']);  // download url
}''',
            ),
            const SizedBox(height: 16),
            _buildCodeExample(
              'Validate Before Upload',
              '''final bool isValid = storage.validateFile(
  imageFile,
  maxSizeBytes: 50000000, // 50MB
  allowedExtensions: ['jpg', 'png'],
);

if (isValid) {
  // safe to upload
}''',
            ),
          ],
        ),
      ),
    );
  }

  /// Build code example widget
  Widget _buildCodeExample(String title, String code) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border.all(color: RetroColors.neonCyan, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1a1a1a),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: RetroColors.neonCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: RetroColors.neonGreen,
                fontSize: 12,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage Demo'),
        backgroundColor: Colors.black87,
        foregroundColor: RetroColors.neonCyan,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: RetroColors.neonCyan,
          unselectedLabelColor: Colors.grey,
          indicatorColor: RetroColors.neonMagenta,
          tabs: const [
            Tab(text: 'Upload', icon: Icon(Icons.upload)),
            Tab(text: 'Files', icon: Icon(Icons.folder)),
            Tab(text: 'Advanced', icon: Icon(Icons.settings)),
            Tab(text: 'Code', icon: Icon(Icons.code)),
          ],
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildImagePickerTab(),
            _buildFileManagementTab(),
            _buildAdvancedFeaturesTab(),
            _buildCodeExamplesTab(),
          ],
        ),
      ),
    );
  }
}
