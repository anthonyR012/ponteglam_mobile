import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/headquarter_model.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/shared/widgets/custom_main_app_bar_widget.dart';
import 'package:ponte_glam/shared/widgets/notification_list_body.dart';

class SupplierNotificationPage extends StatelessWidget {
  static const routeName = 'supplier_notifications';

  final int? companyId;
  final FancyDrawerController? controllerMenu;
  final HeadquarterModel? headquarter;

  const SupplierNotificationPage({super.key, this.companyId, this.controllerMenu, this.headquarter});

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
          subtitleAppBar: headquarter?.name ?? user.fullName ?? '',
          trailingAppBar: CircleImageProfile(
            size: MediaQuery.of(context).size.width * 0.13,
            showSubIcon: false,
            typeSourceImage: TypeSourceImage.network,
            imageMain: headquarter?.imageUrl ?? user.picture,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(
                DoGetNotificationEvent(null, true, companyId),
              );
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: NotificationListBody(
                companyId: companyId,
                resetBadgeOnLoad: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
