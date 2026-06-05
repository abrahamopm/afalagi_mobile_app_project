import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/tags/domain/entities/tag_entity.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/create_tag.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepository;
  late CreateTag useCase;

  const tTag = TagEntity(id: '1', name: 'Luxury', color: '#1B385E');
  final tBody = {'name': 'Luxury', 'color': '#1B385E'};

  setUp(() {
    mockRepository = MockTagRepository();
    useCase = CreateTag(mockRepository);
    registerFallbackValue(tBody);
  });

  test('should create tag via repository', () async {
    when(() => mockRepository.create(any())).thenAnswer((_) async => tTag);

    final result = await useCase(tBody);

    expect(result, tTag);
    verify(() => mockRepository.create(tBody)).called(1);
  });
}
