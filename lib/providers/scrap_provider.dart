import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scrap_item_model.dart';
import '../services/ai_service.dart';
import '../repositories/scrap_repository.dart';

final aiServiceProvider = Provider<AiService>((ref) {
  return MockAiService();
});

final scrapRepositoryProvider = Provider<ScrapRepository>((ref) {
  return MockScrapRepository();
});

class ScrapScanState {
  final bool isAnalyzing;
  final String? imagePath;
  final List<ScrapItemModel> analyzedItems;
  final String? selectedCategory;
  final String? error;

  const ScrapScanState({
    this.isAnalyzing = false,
    this.imagePath,
    this.analyzedItems = const [],
    this.selectedCategory,
    this.error,
  });

  ScrapScanState copyWith({
    bool? isAnalyzing,
    String? imagePath,
    List<ScrapItemModel>? analyzedItems,
    String? selectedCategory,
    String? error,
  }) {
    return ScrapScanState(
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      imagePath: imagePath ?? this.imagePath,
      analyzedItems: analyzedItems ?? this.analyzedItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      error: error,
    );
  }
}

class ScrapScanNotifier extends StateNotifier<ScrapScanState> {
  final AiService _aiService;

  ScrapScanNotifier(this._aiService) : super(const ScrapScanState());

  Future<void> analyzeImage(String path) async {
    state = state.copyWith(isAnalyzing: true, imagePath: path, error: null);
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
