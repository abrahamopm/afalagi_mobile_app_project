import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/features/tags/domain/repositories/tag_repository.dart';
import 'package:afalagi/features/tags/domain/usecases/delete_tag.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepository;
  late DeleteTag useCase;

  setUp(() {
    mockRepository = MockTagRepository();
    useCase = DeleteTag(mockRepository);
  });

  test('should delete tag via repository', () async {
    when(() => mockRepository.delete('1')).thenAnswer((_) async => {});

    await useCase('1');

    verify(() => mockRepository.delete('1')).called(1);
  });
}
