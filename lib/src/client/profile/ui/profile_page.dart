import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/shared/widgets/custom_main_app_bar_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/profile_widgets/profile_list_widget.dart';
import 'package:ponte_glam/src/client/profile/ui/widgets/profile_widgets/top_profile_app_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.controllerMenu});
  static const String routeName = 'profile';
  final FancyDrawerController? controllerMenu;

  @override
  Widget build(BuildContext context) {
    return _Profile(controllerMenu);
  }
}

class _Profile extends StatelessWidget {
  const _Profile(this.controller);
  final FancyDrawerController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: CustomMainAppBar(
            iconMenu: true,
            controllerMenu: controller,
            customWidget: const TopProfileAppBar()),
      ),
      body: const ProfileList(),
    );
  }
}
