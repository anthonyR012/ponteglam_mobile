import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';

class NotificationTabBar extends StatelessWidget {
  const NotificationTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColorTheme,
      child: const TabBar(
        labelColor: secondaryColorTheme,
        unselectedLabelColor: Colors.white70,
        indicatorColor: secondaryColorTheme,
        tabs: [
          Tab(text: 'All'),
          Tab(text: 'Unread'),
        ],
      ),
    );
  }
}
