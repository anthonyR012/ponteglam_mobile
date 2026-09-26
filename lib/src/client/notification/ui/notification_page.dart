import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/shared/widgets/custom_main_app_bar_widget.dart';
import 'package:ponte_glam/shared/widgets/notification_list_body.dart';

class NotificationPage extends StatelessWidget {
  static const routeName = 'notification';

  const NotificationPage({super.key, this.controllerMenu});

  /// Puede ser null cuando se navega desde una push notification (sin drawer activo).
  final FancyDrawerController? controllerMenu;

  @override
  Widget build(BuildContext context) {
    final user = getIt<SettingBloc>().user ?? UserModel.empty();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: CustomMainAppBar(
          iconMenu: controllerMenu != null,
          controllerMenu: controllerMenu,
          leftContent: 40,
          top: 20,
          textAppBar: getIt<AppLocalizations>().titleNotification,
          subtitleAppBar: user.fullName!,
          trailingAppBar: CircleImageProfile(
            size: MediaQuery.of(context).size.width * 0.13,
            showSubIcon: false,
            typeSourceImage: TypeSourceImage.network,
            imageMain: user.picture,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(const DoGetNotificationEvent(null, true));
        },
        child: const CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: NotificationListBody(resetBadgeOnLoad: true),
            ),
          ],
        ),
      ),
    );
  }
}
