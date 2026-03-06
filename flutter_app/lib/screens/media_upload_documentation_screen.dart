import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

/// Media Upload Documentation Screen
///
/// Comprehensive educational guide for Firebase Storage media uploads.
/// Covers concepts, best practices, security, and implementation patterns.
class MediaUploadDocumentationScreen extends StatefulWidget {
  const MediaUploadDocumentationScreen({Key? key}) : super(key: key);

  @override
  State<MediaUploadDocumentationScreen> createState() =>
      _MediaUploadDocumentationScreenState();
}

class _MediaUploadDocumentationScreenState
    extends State<MediaUploadDocumentationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Upload Guide'),
        backgroundColor: Colors.black87,
        foregroundColor: RetroColors.neonCyan,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black87,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Why Media Upload?
              _buildSection(
                title: 'Why Media Upload?',
                color: const Color(0xFF003D82),
                borderColor: RetroColors.neonCyan,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint(
                        'Store images, documents, and media in the cloud'),
                    _buildBulletPoint(
                        'Offload storage from app to scalable Firebase infrastructure'),
                    _buildBulletPoint(
                        'Generate shareable download URLs for media content'),
                    _buildBulletPoint('Track and manage user-uploaded files'),
                    _buildBulletPoint(
                        'Integrate with profiles, portfolios, and galleries'),
                    _buildBulletPoint(
                        'Build modern apps that handle user-generated content'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Upload Flow
              _buildSection(
                title: 'The Upload Flow',
                color: const Color(0xFF1a5f3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '5 Steps to Upload Media:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildNumberedStep('1', 'User picks file from device',
                        'Using ImagePicker or file picker'),
                    const SizedBox(height: 8),
                    _buildNumberedStep('2', 'Validate file',
                        'Check size, type, permissions'),
                    const SizedBox(height: 8),
                    _buildNumberedStep('3', 'Upload to Firebase Storage',
                        'Show progress, handle network issues'),
                    const SizedBox(height: 8),
                    _buildNumberedStep('4', 'Get download URL',
                        'Retrieve public shareable link'),
                    const SizedBox(height: 8),
                    _buildNumberedStep('5', 'Store in Firestore (optional)',
                        'Save URL reference with metadata'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Picking Files
              _buildSection(
                title: 'Picking Files from Device',
                color: const Color(0xFF4a2c5e),
                borderColor: RetroColors.neonMagenta,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Using ImagePicker Package:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCodeBlock(
                        '''final ImagePicker picker = ImagePicker();
final XFile? file = await picker.pickImage(
  source: ImageSource.gallery,
  imageQuality: 85, // compress
);

if (file != null) {
  File imageFile = File(file.path);
  // Ready to upload
}'''),
                    const SizedBox(height: 12),
                    const Text(
                      'ImageSource Options:',
                      style: TextStyle(
                        color: RetroColors.neonMagenta,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint('ImageSource.gallery - Browse device photos'),
                    _buildBulletPoint('ImageSource.camera - Take new photo'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Uploading Files
              _buildSection(
                title: 'Uploading to Firebase Storage',
                color: const Color(0xFF5c3a00),
                borderColor: RetroColors.neonOrange,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Upload:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCodeBlock('''final File imageFile = File(path);
final String fileName = 
  'image_\${DateTime.now().millisecondsSinceEpoch}.jpg';

await FirebaseStorage.instance
  .ref('uploads/userId/\$fileName')
  .putFile(imageFile);'''),
                    const SizedBox(height: 12),
                    const Text(
                      'With Progress Monitoring:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCodeBlock('''final UploadTask task =
  ref.putFile(imageFile);

task.snapshotEvents.listen((snapshot) {
  double progress = snapshot.bytesTransferred /
                    snapshot.totalBytes;
  setState(() => _uploadProgress = progress);
});

await task;'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Getting Download URL
              _buildSection(
                title: 'Getting Download URL',
                color: const Color(0xFF003d6b),
                borderColor: RetroColors.neonCyan,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCodeBlock('''// After upload completes
final String downloadUrl = 
  await ref.getDownloadURL();

// Use in Image.network()
Image.network(downloadUrl)

// Or store in Firestore
await firestore
  .collection('images')
  .doc(docId)
  .update({'url': downloadUrl});'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // File Organization
              _buildSection(
                title: 'File Organization Strategy',
                color: const Color(0xFF1a4d3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Structure:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCodeBlock('''uploads/
├── userId1/
│   ├── profile_pic.jpg
│   ├── document_1.pdf
│   └── gallery_001.jpg
├── userId2/
│   ├── profile_pic.jpg
│   └── ...
└── ...

Benefits:
- Easy to delete all user files
- Clear ownership and permissions
- Better performance with rules
- Organized by user isolation'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Security Rules
              _buildSection(
                title: 'Firestore Storage Rules',
                color: const Color(0xFF5c3a00),
                borderColor: RetroColors.neonOrange,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Rules:\n',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildCodeBlock('''rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload/read only their files
    match /uploads/{userId}/{allPaths=**} {
      allow write: if request.auth.uid == userId;
      allow read: if request.auth.uid == userId;
    }
  }
}'''),
                    const SizedBox(height: 12),
                    const Text(
                      'Security Best Practices:',
                      style: TextStyle(
                        color: RetroColors.neonOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Authenticate users before upload'),
                    _buildBulletPoint(
                        'Validate file types server-side'),
                    _buildBulletPoint('Set file size limits'),
                    _buildBulletPoint(
                        'Use user ID in file path'),
                    _buildBulletPoint(
                        'Restrict who can read/write files'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // File Size Management
              _buildSection(
                title: 'File Size & Optimization',
                color: const Color(0xFF4a2c5e),
                borderColor: RetroColors.neonMagenta,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint(
                        'Max file size: ~100MB (reasonable limit)'),
                    _buildBulletPoint(
                        'Compress images to 85% quality before upload'),
                    _buildBulletPoint(
                        'Cloud Storage costs: \$0.18 per GB/month'),
                    _buildBulletPoint(
                        'Downloads: \$0.12 per GB'),
                    const SizedBox(height: 12),
                    const Text(
                      'Cost Example:',
                      style: TextStyle(
                        color: RetroColors.neonMagenta,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(
                        '1000 images @ 2 MB each = 2GB = \$0.36/month'),
                    _buildBulletPoint(
                        '10,000 downloads/mo @ 2MB = 20GB = \$2.40'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Common Use Cases
              _buildSection(
                title: 'Common Use Cases',
                color: const Color(0xFF003d6b),
                borderColor: RetroColors.neonCyan,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUseCase('Profile Pictures', 'Store user avatars'),
                    _buildUseCase('Portfolio Images', 'Freelancer portfolio'),
                    _buildUseCase('Documents', 'PDFs, invoices, contracts'),
                    _buildUseCase('Media Gallery', 'Multiple images per item'),
                    _buildUseCase('Thumbnails', 'Smaller preview images'),
                    _buildUseCase(
                        'Temporary Files', 'User-generated content'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Error Handling
              _buildSection(
                title: 'Error Handling',
                color: const Color(0xFF5c2020),
                borderColor: Colors.red,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCodeBlock('''try {
  final String url = await storage.uploadImage(
    imageFile,
    userId,
  );
  print('Success: \$url');
} on FirebaseException catch (e) {
  if (e.code == 'object-not-found') {
    // File deleted during upload
  } else if (e.code == 'unauthorized') {
    // User not authenticated
  } else if (e.code == 'canceled') {
    // User cancelled upload
  }
  print('Upload failed: \${e.message}');
} catch (e) {
  print('Unexpected error: \$e');
}'''),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Best Practices
              _buildSection(
                title: 'Best Practices',
                color: const Color(0xFF1a4d3a),
                borderColor: RetroColors.neonGreen,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBulletPoint('Always validate files before upload'),
                    _buildBulletPoint('Show upload progress to users'),
                    _buildBulletPoint('Handle network interruptions'),
                    _buildBulletPoint('Cache download URLs locally'),
                    _buildBulletPoint(
                        'Delete old files to manage costs'),
                    _buildBulletPoint(
                        'Use user IDs in file paths for security'),
                    _buildBulletPoint(
                        'Compress images before uploading'),
                    _buildBulletPoint(
                        'Use appropriate folder structures'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Common Mistakes
              _buildSection(
                title: 'Common Mistakes to Avoid',
                color: const Color(0xFF5c3a00),
                borderColor: RetroColors.neonOrange,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMistakeItem(
                      'Uploading uncompressed images',
                      'Always compress images to 80-85% quality',
                    ),
                    _buildMistakeItem(
                      'No progress indication',
                      'Show upload progress to prevent user frustration',
                    ),
                    _buildMistakeItem(
                      'Weak security rules',
                      'Restrict access to own files with auth.uid check',
                    ),
                    _buildMistakeItem(
                      'No file validation',
                      'Check file size, type, and format before upload',
                    ),
                    _buildMistakeItem(
                      'Not handling errors',
                      'Use try-catch and show friendly error messages',
                    ),
                    _buildMistakeItem(
                      'Storing full paths in database',
                      'Store URLs or generate paths on demand',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bottom spacing
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Build section with colored background
  Widget _buildSection({
    required String title,
    required Color color,
    required Color borderColor,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: content,
          ),
        ],
      ),
    );
  }

  /// Build bullet point
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Colors.white70,
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

  /// Build numbered step
  Widget _buildNumberedStep(String number, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              number,
              style: const TextStyle(
                color: RetroColors.neonGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  /// Build code block
  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0a0a0a),
        border: Border.all(color: Colors.grey.shade700, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          color: RetroColors.neonGreen,
          fontSize: 11,
          fontFamily: 'monospace',
          height: 1.5,
        ),
      ),
    );
  }

  /// Build use case item
  Widget _buildUseCase(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: RetroColors.neonGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build mistake item
  Widget _buildMistakeItem(String mistake, String solution) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.close_circle,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mistake,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              solution,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
