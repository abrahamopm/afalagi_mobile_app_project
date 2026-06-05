import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/admin/data/models/admin_stats_model.dart';
import 'package:afalagi/features/admin/domain/repositories/admin_repository.dart';
import 'package:afalagi/features/admin/domain/usecases/get_admin_stats.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepository;
  late GetAdminStats usecase;

  final tStats = AdminStatsModel(
    userCount: 10,
    propertyCount: 25,
    viewingCount: 50,
    pendingUsers: 2,
    hiddenProperties: 1,
    recentActivity: const [],
  );

  setUp(() {
    mockRepository = MockAdminRepository();
    usecase = GetAdminStats(mockRepository);
  });

  group('GetAdminStats', () {
    test('should get admin stats from repository', () async {
      when(() => mockRepository.getStats()).thenAnswer((_) async => tStats);

      final result = await usecase(const NoParams());

      expect(result, equals(tStats));
      verify(() => mockRepository.getStats()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
