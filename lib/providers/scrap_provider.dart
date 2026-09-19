import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scrap_item_model.dart';
import '../services/ai_service.dart';
import '../services/camera_service.dart';
import '../repositories/scrap_repository.dart';

final aiServiceProvider = Provider<AiService>((ref) {
  return MockAiService();
});

final scrapRepositoryProvider = Provider<ScrapRepository>((ref) {
  return MockScrapRepository();
});

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});

class ScrapScanState {
  final bool isAnalyzing;
  final String? imagePath;
  final List<ScrapItemModel> analyzedItems;
  final String? selectedCategory;
  final String? error;

  /// True when the photo came from the real device camera (vs gallery/asset).
  final bool isFromCamera;

  const ScrapScanState({
    this.isAnalyzing = false,
    this.imagePath,
    this.analyzedItems = const [],
    this.selectedCategory,
    this.error,
    this.isFromCamera = false,
  });

  ScrapScanState copyWith({
    bool? isAnalyzing,
    String? imagePath,
    List<ScrapItemModel>? analyzedItems,
    String? selectedCategory,
    String? error,
    bool? isFromCamera,
  }) {
    return ScrapScanState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      imagePath: imagePath ?? this.imagePath,
      analyzedItems: analyzedItems ?? this.analyzedItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
      isFromCamera: isFromCamera ?? this.isFromCamera,
    );
  }
}

class ScrapScanNotifier extends StateNotifier<ScrapScanState> {
  final AiService _aiService;

  ScrapScanNotifier(this._aiService) : super(const ScrapScanState());

  /// Stores the REAL device-camera photo and starts AI material detection.
  /// The captured image is shown in the preview; weights remain manual.
  Future<void> analyzeCameraPhoto(String path) async {
    state = state.copyWith(
      isAnalyzing: true,
      imagePath: path,
      isFromCamera: true,
      error: null,
    );
    try {
      final items = await _aiService.analyzeScrapImage(path);
      state = state.copyWith(isAnalyzing: false, analyzedItems: items);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: 'Failed to analyze scrap image: $e');
    }
  }

  /// Legacy gallery/asset flow kept for compatibility.
  Future<void> analyzeImage(String path) async {
    state = state.copyWith(
      isAnalyzing: true,
      imagePath: path,
      isFromCamera: false,
      error: null,
    );
    try {
      final items = await _aiService.analyzeScrapImage(path);
      state = state.copyWith(isAnalyzing: false, analyzedItems: items);
    } catch (e) {
      state = state.copyWith(isAnalyzing: false, error: 'Failed to analyze scrap image: $e');
    }
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void addItem(ScrapItemModel item) {
    final updated = List<ScrapItemModel>.from(state.analyzedItems)..add(item);
    state = state.copyWith(analyzedItems: updated);
  }

  void removeItem(String id) {
    final updated = state.analyzedItems.where((i) => i.id != id).toList();
    state = state.copyWith(analyzedItems: updated);
  }

  /// Applies the citizen's MANUALLY ENTERED approximate weights.
  /// Weights are never auto-generated — they come only from user input.
  void applyManualWeights(Map<String, double> weightsById) {
    final updated = state.analyzedItems.map((item) {
      final w = weightsById[item.id];
      if (w == null) return item;
      return ScrapItemModel(
        id: item.id,
        category: item.category,
        subType: item.subType,
        weightKg: w,
        pricePerKg: item.pricePerKg,
        estimatedTotal: w * item.pricePerKg,
        confidenceScore: item.confidenceScore,
        notes: item.notes,
      );
    }).toList();
    state = state.copyWith(analyzedItems: updated);
  }

  void reset() {
    state = const ScrapScanState();
  }
}

final scrapScanProvider = StateNotifierProvider<ScrapScanNotifier, ScrapScanState>((ref) {
  final ai = ref.watch(aiServiceProvider);
  return ScrapScanNotifier(ai);
});

final categoryPricesProvider = FutureProvider<List<CategoryPriceInfo>>((ref) {
  final repo = ref.watch(scrapRepositoryProvider);
  return repo.getCategoryPrices();
});

/// Resolves the preview image for the AI analysis screen: a real captured
/// photo file when available, otherwise falls back to the bundled asset.
File? previewFileOf(ScrapScanState state) {
  final path = state.imagePath;
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('assets/') || path.startsWith('http')) return null;
  final file = File(path);
  return file.existsSync() ? file : null;
}
