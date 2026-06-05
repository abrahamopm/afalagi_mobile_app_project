import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/get_tag_by_id.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepository;
  late GetTagById useCase;

  const tTag = TagEntity(id: '1', name: 'Luxury', color: '#1B385E');

  setUp(() {
    mockRepository = MockTagRepository();
    useCase = GetTagById(mockRepository);
  });

  test('should get tag by id from repository', () async {
    when(() => mockRepository.getById('1')).thenAnswer((_) async => tTag);

    final result = await useCase('1');

    expect(result, tTag);
    verify(() => mockRepository.getById('1')).called(1);
  });
}
