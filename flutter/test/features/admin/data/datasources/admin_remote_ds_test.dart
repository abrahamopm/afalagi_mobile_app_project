import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:afalagi/core/constants/constants.dart';
import 'package:afalagi/core/errors/exceptions.dart';
import 'package:afalagi/features/admin/data/datasources/admin_remote_ds.dart';
import 'package:afalagi/features/admin/data/models/admin_user_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AdminRemoteDS dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AdminRemoteDS(mockDio);
  });

  group('AdminRemoteDS getStats', () {
    test('should return AdminStatsModel when response is successful', () async {
      final responsePayload = {
        'success': true,
        'data': {
          'userCount': 10,
          'propertyCount': 25,
          'viewingCount': 50,
          'pendingUsers': 2,
          'hiddenProperties': 1,
          'recentActivity': [
            {
              'id': '1',
              'type': 'user',
              'title': 'New User',
              'description': 'Agent joined',
              'time': '2h ago',
            },
          ],
        },
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.adminStats),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      final result = await dataSource.getStats();

      expect(result.userCount, 10);
      expect(result.propertyCount, 25);
      expect(result.viewingCount, 50);
      expect(result.pendingUsers, 2);
      expect(result.hiddenProperties, 1);
      expect(result.recentActivity, hasLength(1));
      expect(result.recentActivity.first.title, 'New User');
      verify(() => mockDio.get(AppConstants.adminStats)).called(1);
    });

    test('should throw ServerException when getStats success is false', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.adminStats),
          data: {'success': false, 'error': 'Forbidden'},
          statusCode: 403,
        ),
      );

      expect(() => dataSource.getStats(), throwsA(isA<ServerException>()));
    });
  });

  group('AdminRemoteDS getUsers', () {
    test('should return list of AdminUserModel when response is successful', () async {
      final responsePayload = {
        'success': true,
        'data': [
          {
            'id': '1',
            'name': 'Agent One',
            'email': 'agent1@example.com',
            'role': 'user',
            'agencyName': 'Agency A',
            'isVerified': true,
            'isActive': true,
          },
        ],
      };

      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.adminUsers),
          data: responsePayload,
          statusCode: 200,
        ),
      );

      final result = await dataSource.getUsers();

      expect(result, hasLength(1));
      expect(result.first, isA<AdminUserModel>());
      expect(result.first.name, 'Agent One');
      verify(() => mockDio.get(AppConstants.adminUsers)).called(1);
    });

    test('should throw ServerException when getUsers success is false', () async {
      when(() => mockDio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: AppConstants.adminUsers),
          data: {'success': false, 'error': 'Server Error'},
          statusCode: 500,
        ),
      );

      expect(() => dataSource.getUsers(), throwsA(isA<ServerException>()));
    });

    test('should throw ServerException when DioException occurs', () async {
      when(() => mockDio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: AppConstants.adminUsers),
          response: Response(
            requestOptions: RequestOptions(path: AppConstants.adminUsers),
            statusCode: 500,
            data: {'error': 'Server error'},
          ),
        ),
      );

      expect(() => dataSource.getUsers(), throwsA(isA<ServerException>()));
    });
  });
}
