import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/config/utils/navigation_util.dart';
import 'package:ponte_glam/src/client/home/ui/responsive/small_mobile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = "home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late FancyDrawerController _controllerMenu;
  final NotifierNav _notifierNav = NotifierNav(routeName: HomePage.routeName);

  @override
  void initState() {
    super.initState();
    _controllerMenu = FancyDrawerController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controllerMenu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SmallMobileHomePage(
            controllerMenu: _controllerMenu,
            notifierNav: _notifierNav,
          );
        },
      ),
    );
  }
}
