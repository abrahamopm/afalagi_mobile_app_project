import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/features/client/domain/entities/client_entity.dart';
import 'package:afalagi/features/client/domain/repositories/client_repository.dart';
import 'package:afalagi/features/client/domain/usecases/get_clients.dart';
import 'package:afalagi/features/client/providers/client_provider.dart';
import 'package:afalagi/features/client/screens/client_list_screen.dart';

class DummyClientRepository implements ClientRepository {
  final List<ClientEntity> list;

  DummyClientRepository(this.list);

  @override
  Future<List<ClientEntity>> getAll() async => list;

  @override
  Future<ClientEntity> getById(String id) async => throw UnimplementedError();

  @override
  Future<ClientEntity> create(Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<ClientEntity> update(String id, Map<String, dynamic> body) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}

void main() {
  testWidgets('ClientListScreen displays clients from provider', (
    WidgetTester tester,
  ) async {
    const tClient = ClientEntity(
      id: '1',
      name: 'Dawit Mengistu',
      phone: '+251 911 000 000',
      priority: 'MODERATE',
      interest: 4,
      area: 'Bole',
      budget: '45M ETB',
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: ClientListScreen()),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getClientsUseCaseProvider.overrideWithValue(
            GetClients(DummyClientRepository([tClient])),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dawit Mengistu'), findsOneWidget);
    expect(find.text('New Acquisition'), findsOneWidget);
    expect(find.text('+251 911 000 000'), findsOneWidget);
  });

  testWidgets('ClientListScreen shows empty state when no clients', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: ClientListScreen()),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getClientsUseCaseProvider.overrideWithValue(
            GetClients(DummyClientRepository(const [])),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No clients yet. Add your first acquisition.'),
      findsOneWidget,
    );
  });
}
