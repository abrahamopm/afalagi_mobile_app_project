import 'package:flutter_test/flutter_test.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';

void main() {
  const client = ClientEntity(
    id: '1',
    name: 'Dawit Mengistu',
    phone: '+251 911 000 000',
    priority: 'VIP',
    interest: 5,
    area: 'Bole',
    budget: '45M – 60M ETB',
    image: 'assets/images/avatar.png',
    tags: ['Penthouse', 'Luxury'],
  );

  group('ClientEntity Tests', () {
    test('supports value equality', () {
      const clientEquals = ClientEntity(
        id: '1',
        name: 'Dawit Mengistu',
        phone: '+251 911 000 000',
        priority: 'VIP',
        interest: 5,
        area: 'Bole',
        budget: '45M – 60M ETB',
        image: 'assets/images/avatar.png',
        tags: ['Penthouse', 'Luxury'],
      );

      expect(client, equals(clientEquals));
    });

    test('supports copyWith', () {
      final updated = client.copyWith(
        name: 'Updated Name',
        priority: 'HIGH',
        interest: 4,
      );

      expect(updated.id, '1');
      expect(updated.name, 'Updated Name');
      expect(updated.priority, 'HIGH');
      expect(updated.interest, 4);
      expect(updated.phone, '+251 911 000 000');
    });
  });
}
