import '../models/scrap_item_model.dart';

class CategoryPriceInfo {
  final String category;
  final String priceRange;
  final String iconName;
  final List<String> popularItems;

  const CategoryPriceInfo({
    required this.category,
    required this.priceRange,
    required this.iconName,
    required this.popularItems,
  });
}

abstract class ScrapRepository {
  Future<List<CategoryPriceInfo>> getCategoryPrices();
  Future<List<ScrapItemModel>> getPopularItems();
}

class MockScrapRepository implements ScrapRepository {
  @override
  Future<List<CategoryPriceInfo>> getCategoryPrices() async {
    return const [
      CategoryPriceInfo(
        category: 'Plastic',
        priceRange: '₹35 - ₹60 / kg',
        iconName: 'bottle',
        popularItems: ['PET Bottles', 'Hard Plastic Containers', 'Milk Covers'],
      ),
      CategoryPriceInfo(
        category: 'Paper & Cardboard',
        priceRange: '₹14 - ₹22 / kg',
        iconName: 'file-text',
        popularItems: ['Newspapers', 'Corrugated Boxes', 'Books & Notebooks'],
      ),
      CategoryPriceInfo(
        category: 'Metal & Aluminium',
        priceRange: '₹45 - ₹220 / kg',
        iconName: 'anvil',
        popularItems: ['Beverage Cans', 'Iron Rods', 'Copper Wire'],
      ),
      CategoryPriceInfo(
        category: 'E-Waste',
        priceRange: '₹80 - ₹450 / unit',
        iconName: 'cpu',
        popularItems: ['Old Smartphones', 'Motherboards', 'Laptops'],
      ),
      CategoryPriceInfo(
        category: 'Electronics',
        priceRange: '₹150 - ₹900 / unit',
        iconName: 'tv',
        popularItems: ['Microwaves', 'Washing Machines', 'Refrigerators'],
      ),
      CategoryPriceInfo(
        category: 'Appliances',
        priceRange: '₹200 - ₹1200 / unit',
        iconName: 'sparkles',
        popularItems: ['Air Conditioners', 'Inverter Batteries', 'Motors'],
      ),
    ];
  }

  @override
  Future<List<ScrapItemModel>> getPopularItems() async {
    return const [
      ScrapItemModel(
        id: 'POP-1',
        category: 'Plastic',
        subType: 'PET Bottles',
        weightKg: 1.0,
        pricePerKg: 50.0,
        estimatedTotal: 50.0,
        confidenceScore: 0.95,
      ),
      ScrapItemModel(
        id: 'POP-2',
        category: 'Paper & Cardboard',
        subType: 'Old Newspapers',
        weightKg: 5.0,
        pricePerKg: 18.0,
        estimatedTotal: 90.0,
        confidenceScore: 0.98,
      ),
      ScrapItemModel(
        id: 'POP-3',
        category: 'E-Waste',
        subType: 'Old Smartphone',
        weightKg: 0.3,
        pricePerKg: 850.0,
        estimatedTotal: 850.0,
        confidenceScore: 0.90,
      ),
    ];
  }
}
