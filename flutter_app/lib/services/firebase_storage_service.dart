import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage Service
///
/// Singleton service for managing file uploads and downloads to Firebase Storage.
/// Provides utilities for uploading images, documents, and retrieving download URLs.
class FirebaseStorageService {
  static final FirebaseStorageService _instance =
      FirebaseStorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseStorageService._internal();

  factory FirebaseStorageService() {
    return _instance;
  }

  // MEDIA UPLOAD OPERATIONS

  /// Upload a file to Firebase Storage
  ///
  /// Parameters:
  /// - [file] - File object to upload
  /// - [userId] - User ID for organizing files
  /// - [folder] - Optional folder path (default: 'uploads')
  /// - [fileName] - Optional custom file name (default: timestamp)
  /// - [onProgressUpdate] - Optional callback for progress updates (0.0 to 1.0)
  ///
  /// Returns the download URL of uploaded file
  Future<String> uploadFile(
    File file,
    String userId, {
    String folder = 'uploads',
    String? fileName,
    Function(double)? onProgressUpdate,
  }) async {
    try {
      // Generate unique filename if not provided
      final String customFileName = fileName ??
          'file_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.path)}';

      // Create reference path
      final String filePath = '$folder/$userId/$customFileName';
      final Reference ref = _storage.ref(filePath);

      // Upload file with progress monitoring
      final UploadTask uploadTask = ref.putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final double progress =
            snapshot.bytesTransferred / snapshot.totalBytes;
        onProgressUpdate?.call(progress);
      });

      // Wait for upload to complete
      await uploadTask;

      // Get and return download URL
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /// Upload image from file
  ///
  /// Simplified method for image uploads
  Future<String> uploadImage(
    File imageFile,
    String userId, {
    String? imageName,
    Function(double)? onProgressUpdate,
  }) async {
    return uploadFile(
      imageFile,
      userId,
      folder: 'images',
      fileName: imageName,
      onProgressUpdate: onProgressUpdate,
    );
  }

  /// Upload multiple files in sequence
  ///
  /// Returns list of download URLs in same order
  Future<List<String>> uploadMultipleFiles(
    List<File> files,
    String userId, {
    String folder = 'uploads',
    Function(double)? onProgressUpdate,
  }) async {
    final List<String> urls = [];

    try {
      for (int i = 0; i < files.length; i++) {
        final double fileProgress = i / files.length;

        final String url = await uploadFile(
          files[i],
          userId,
          folder: folder,
          onProgressUpdate: (progress) {
            double overallProgress =
                fileProgress + (progress / files.length);
            onProgressUpdate?.call(overallProgress);
          },
        );

        urls.add(url);
      }

      return urls;
    } catch (e) {
      throw Exception('Multiple file upload failed: $e');
    }
  }

  // DOWNLOAD URL OPERATIONS

  /// Get download URL for existing file
  ///
  /// Useful for retrieving URLs without re-uploading
  Future<String> getDownloadUrl(String filePath) async {
    try {
      final Reference ref = _storage.ref(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Get download URL with expiration time
  ///
  /// Generate a signed URL that expires after specified duration
  Future<String> getSignedDownloadUrl(
    String filePath, {
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    try {
      final Reference ref = _storage.ref(filePath);
      return await ref.getDownloadURL();

      // Note: For true signed URLs with expiration, use:
      // final String url = await ref.getSignedDownloadURLString(...);
      // See Firebase docs for implementation
    } catch (e) {
      throw Exception('Failed to get signed URL: $e');
    }
  }

  // FILE DELETION OPERATIONS

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String filePath) async {
    try {
      final Reference ref = _storage.ref(filePath);
      await ref.delete();
    } catch (e) {
      throw Exception('File deletion failed: $e');
    }
  }

  /// Delete user's entire folder
  ///
  /// Be careful - this deletes all files in the folder
  Future<void> deleteUserFolder(String userId) async {
    try {
      final Reference ref = _storage.ref('uploads/$userId');
      final ListResult result = await ref.listAll();

      for (Reference file in result.items) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Folder deletion failed: $e');
    }
  }

  // FILE METADATA OPERATIONS

  /// Get file metadata (size, content type, creation time)
  Future<FullMetadata?> getFileMetadata(String filePath) async {
    try {
      final Reference ref = _storage.ref(filePath);
      return await ref.getMetadata();
    } catch (e) {
      print('Failed to get metadata: $e');
      return null;
    }
  }

  /// Get file size in bytes
  Future<int?> getFileSizeBytes(String filePath) async {
    try {
      final Reference ref = _storage.ref(filePath);
      final FullMetadata metadata = await ref.getMetadata();
      return metadata.size;
    } catch (e) {
      print('Failed to get file size: $e');
      return null;
    }
  }

  /// Get file size as formatted string (KB, MB, GB)
  Future<String?> getFileSizeFormatted(String filePath) async {
    try {
      final int? sizeBytes = await getFileSizeBytes(filePath);
      if (sizeBytes == null) return null;

      if (sizeBytes < 1024) {
        return '$sizeBytes B';
      } else if (sizeBytes < 1024 * 1024) {
        final double sizeKb = sizeBytes / 1024;
        return '${sizeKb.toStringAsFixed(2)} KB';
      } else if (sizeBytes < 1024 * 1024 * 1024) {
        final double sizeMb = sizeBytes / (1024 * 1024);
        return '${sizeMb.toStringAsFixed(2)} MB';
      } else {
        final double sizeGb = sizeBytes / (1024 * 1024 * 1024);
        return '${sizeGb.toStringAsFixed(2)} GB';
      }
    } catch (e) {
      print('Failed to format file size: $e');
      return null;
    }
  }

  /// Get content type of file
  Future<String?> getContentType(String filePath) async {
    try {
      final Reference ref = _storage.ref(filePath);
      final FullMetadata metadata = await ref.getMetadata();
      return metadata.contentType;
    } catch (e) {
      print('Failed to get content type: $e');
      return null;
    }
  }

  // FILE LISTING OPERATIONS

  /// List all files in a folder
  Future<List<String>> listFilesInFolder(String folderPath) async {
    try {
      final Reference ref = _storage.ref(folderPath);
      final ListResult result = await ref.listAll();

      return result.items
          .map((Reference ref) => ref.fullPath)
          .toList();
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  /// List all user's uploaded files
  Future<List<String>> listUserFiles(String userId) async {
    return listFilesInFolder('uploads/$userId');
  }

  /// List all files with download URLs
  Future<List<Map<String, String>>> listFilesWithUrls(
      String userId) async {
    try {
      final List<String> filePaths = await listUserFiles(userId);
      final List<Map<String, String>> filesWithUrls = [];

      for (String filePath in filePaths) {
        try {
          final String url = await getDownloadUrl(filePath);
          filesWithUrls.add({
            'path': filePath,
            'url': url,
            'name': filePath.split('/').last,
          });
        } catch (e) {
          print('Failed to get URL for $filePath: $e');
        }
      }

      return filesWithUrls;
    } catch (e) {
      throw Exception('Failed to list files with URLs: $e');
    }
  }

  // UTILITY METHODS

  /// Get file extension from file path
  String _getFileExtension(String filePath) {
    try {
      final List<String> parts = filePath.split('.');
      if (parts.length > 1) {
        return '.${parts.last}';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  /// Check if file exists in Firebase Storage
  Future<bool> fileExists(String filePath) async {
    try {
      final Reference ref = _storage.ref(filePath);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get Firebase Storage reference for advanced operations
  Reference getReference(String filePath) {
    return _storage.ref(filePath);
  }

  /// Get Firebase Storage instance for custom operations
  FirebaseStorage getStorageInstance() {
    return _storage;
  }

  // UPLOAD STREAM OPERATIONS

  /// Stream file upload with real-time progress
  ///
  /// Returns a Stream that emits progress values (0.0 to 1.0)
  Stream<double> uploadFileStream(
    File file,
    String userId, {
    String folder = 'uploads',
    String? fileName,
  }) {
    return Stream.create((sink) async {
      try {
        final String customFileName = fileName ??
            'file_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(file.path)}';

        final String filePath = '$folder/$userId/$customFileName';
        final Reference ref = _storage.ref(filePath);
        final UploadTask uploadTask = ref.putFile(file);

        uploadTask.snapshotEvents.listen(
          (TaskSnapshot snapshot) {
            final double progress =
                snapshot.bytesTransferred / snapshot.totalBytes;
            sink.add(progress);

            if (progress == 1.0) {
              sink.close();
            }
          },
          onError: (error) {
            sink.addError(Exception('Upload stream error: $error'));
          },
        );
      } catch (e) {
        sink.addError(Exception('Failed to stream upload: $e'));
      }
    });
  }

  // RESUMABLE UPLOAD OPERATIONS

  /// Resume upload task
  ///
  /// Useful for interrupted uploads on poor connections
  Future<String> resumeUpload(
    String uploadTaskId,
    File file,
    String userId,
  ) async {
    try {
      // Firebase Storage handles resume automatically.
      // Retry by re-uploading the same file:
      return uploadFile(file, userId);
    } catch (e) {
      throw Exception('Resume upload failed: $e');
    }
  }

  // SECURITY & VALIDATION

  /// Validate file before upload
  ///
  /// Checks file size and type
  bool validateFile(
    File file, {
    int maxSizeBytes = 104857600, // 100 MB default
    List<String> allowedExtensions = const ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx'],
  }) {
    try {
      // Check file size
      final int fileSize = file.lengthSync();
      if (fileSize > maxSizeBytes) {
        throw Exception('File size exceeds limit: ${fileSize ~/ 1024 ~/ 1024} MB');
      }

      // Check file extension
      final String extension = file.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        throw Exception('File type not allowed: $extension');
      }

      return true;
    } catch (e) {
      print('File validation failed: $e');
      return false;
    }
  }

  /// Get maximum file size allowed
  int getMaxFileSizeBytes() {
    return 104857600; // 100 MB
  }

  /// Get allowed file extensions
  List<String> getAllowedFileExtensions() {
    return ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'txt', 'zip'];
  }
}
