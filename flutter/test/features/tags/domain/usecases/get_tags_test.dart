import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/usecases/usecase.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/get_tags.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepository;
  late GetTags useCase;

  const tTags = [TagEntity(id: '1', name: 'Luxury', color: '#1B385E')];

  setUp(() {
    mockRepository = MockTagRepository();
    useCase = GetTags(mockRepository);
  });

  test('should get tags from repository', () async {
    when(() => mockRepository.getAll()).thenAnswer((_) async => tTags);

    final result = await useCase(const NoParams());

    expect(result, tTags);
    verify(() => mockRepository.getAll()).called(1);
  });
}
