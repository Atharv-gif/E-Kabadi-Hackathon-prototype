import '../models/scrap_item_model.dart';

abstract class AiService {
  Future<List<ScrapItemModel>> analyzeScrapImage(String imagePath);
}

class MockAiService implements AiService {
  @override
  Future<List<ScrapItemModel>> analyzeScrapImage(String imagePath) async {
    // Simulate AI network scan delay
    await Future.delayed(const Duration(seconds: 2));

    return [
      const ScrapItemModel(
        id: 'AI-101',
        category: 'Plastic',
        subType: 'PET Bottles & Containers',
        weightKg: 1.4,
        pricePerKg: 50.0,
        estimatedTotal: 70.0,
        confidenceScore: 0.94,
        notes: 'Clean transparent plastic bottles detected.',
      ),
      const ScrapItemModel(
        id: 'AI-102',
        category: 'Paper & Cardboard',
        subType: 'Corrugated Boxes',
        weightKg: 3.2,
        pricePerKg: 15.0,
        estimatedTotal: 48.0,
        confidenceScore: 0.91,
        notes: 'Dry cardboard packaging boxes detected.',
      ),
    ];
  }
}
