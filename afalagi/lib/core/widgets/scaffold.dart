import 'package:afalagi/core/theme/theme.dart%20';
import 'package:afalagi/core/widgets/image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomScaffold {
  static AppBar appBar() {
    return AppBar(
      title: CustomImages.appLogo(height: 40),
      actions: [Icon(CupertinoIcons.bell), SizedBox(width: 20)],
    );
  }

  static BottomNavigationBar bottomNavigationBar(
    void Function(int) onTap,
    int currentIndex,
  ) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.primaryColor.withAlpha(150),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Clients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Viewings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
