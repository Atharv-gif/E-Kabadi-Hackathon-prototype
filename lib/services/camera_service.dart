import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Result of a device-camera capture attempt.
sealed class CameraCaptureResult {
  const CameraCaptureResult();
}

/// User captured a photo — [filePath] points to the captured image.
class CameraCaptureSuccess extends CameraCaptureResult {
  final String filePath;
  const CameraCaptureSuccess(this.filePath);
}

/// User cancelled the camera or closed it without capturing.
class CameraCaptureCancelled extends CameraCaptureResult {
  const CameraCaptureCancelled();
}

/// Camera could not be opened (no camera app, plugin error, etc.).
class CameraCaptureFailure extends CameraCaptureResult {
  final String message;
  const CameraCaptureFailure(this.message);
}

/// Thin, testable wrapper around the device camera via `image_picker`.
///
/// Uses the REAL Android system camera (ACTION_IMAGE_CAPTURE through the
/// image_picker plugin) — not a simulated in-app camera UI.
class CameraService {
  final ImagePicker _picker;

  CameraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  /// Opens the REAL device camera. Never throws — always returns a typed
  /// result so callers can handle cancellation and failure gracefully.
  Future<CameraCaptureResult> capturePhoto({
    CameraDevice device = CameraDevice.rear,
  }) async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: device,
        maxWidth: 1920,
        imageQuality: 85,
      );
      if (xFile == null) {
        return const CameraCaptureCancelled();
      }
      // Sanity check: the captured file should exist.
      final file = File(xFile.path);
      if (!await file.exists()) {
        return const CameraCaptureFailure('Captured image file is missing.');
      }
      return CameraCaptureSuccess(xFile.path);
    } catch (e) {
      return const CameraCaptureFailure(
          'Could not open the camera. Please try again.');
    }
  }

  /// Opens the device gallery. Same graceful error contract as [capturePhoto].
  Future<CameraCaptureResult> captureFromGallery() async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        imageQuality: 85,
      );
      if (xFile == null) {
        return const CameraCaptureCancelled();
      }
      final file = File(xFile.path);
      if (!await file.exists()) {
        return const CameraCaptureFailure('Selected image file is missing.');
      }
      return CameraCaptureSuccess(xFile.path);
    } catch (e) {
      return const CameraCaptureFailure(
          'Could not open the gallery. Please try again.');
    }
  }
}
