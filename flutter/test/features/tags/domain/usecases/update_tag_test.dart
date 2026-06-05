import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/update_tag.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepository;
  late UpdateTag useCase;

  const tTag = TagEntity(id: '1', name: 'Premium', color: '#2E6B4F');
  final tBody = {'name': 'Premium', 'color': '#2E6B4F'};

  setUp(() {
    mockRepository = MockTagRepository();
    useCase = UpdateTag(mockRepository);
    registerFallbackValue(tBody);
  });

  test('should update tag via repository', () async {
    when(() => mockRepository.update(any(), any())).thenAnswer((_) async => tTag);

    final result = await useCase(UpdateTagParams(id: '1', body: tBody));

    expect(result, tTag);
    verify(() => mockRepository.update('1', tBody)).called(1);
  });
}
