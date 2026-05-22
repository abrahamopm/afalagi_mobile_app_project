import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/features/property/data/models/property_model.dart';

void main() {
  group('PropertyModel Tests', () {
    test('should parse correctly from json', () {
      final json = {
        'id': '1',
        'title': 'Luxury Villa',
        'description': 'A beautiful luxury villa by the beach',
        'location': 'Miami, FL',
        'imageUrl': 'assets/images/villa.png',
        'price': 1200000.0,
        'beds': 4,
        'baths': 3,
        'sqft': 3500,
        'isAvailable': true,
        'tags': ['Beachfront', 'Pool'],
      };

      final model = PropertyModel.fromJson(json);

      expect(model.id, '1');
      expect(model.title, 'Luxury Villa');
      expect(model.price, 1200000.0);
      expect(model.tags.length, 2);
      expect(model.formattedPrice, '1,200,000');
    });
  });
}
