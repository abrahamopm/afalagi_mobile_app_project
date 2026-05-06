import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:afalagi/core/widgets/scaffold.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/properties')) return 1;
    if (location.startsWith('/clients')) return 2;
    if (location.startsWith('/viewing-history')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/dashboard'); break;
      case 1: context.go('/properties'); break;
      case 2: context.go('/clients'); break;
      case 3: context.go('/viewing-history'); break;
      case 4: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomScaffold.appBar(),
      body: child,
      bottomNavigationBar: CustomScaffold.bottomNavigationBar(
        (index) => _onItemTapped(index, context),
        _getCurrentIndex(context),
      ),
    );
  }
}
