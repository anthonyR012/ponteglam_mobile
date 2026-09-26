import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/circle_image_profile_widget.dart';
import 'package:ponte_glam/device/camera/take_photo_gallery.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class TopProfileAppBar extends StatelessWidget {
  const TopProfileAppBar({super.key, this.controller});
  final FancyDrawerController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.action == ProfileAction.uploadPicture) {
          if (state.status == ProfileStatus.failure) {
            getIt<AlertManageUtil>().hide(type: OverlayAlertType.load);
            PonteSnackBar.show(
              context,
              message: 'Error al subir foto: ${state.errorMessage}',
              type: TypeAlert.error,
            );
          } else if (state.status == ProfileStatus.success &&
              state.updatedUser != null) {
            getIt<AlertManageUtil>().hide(type: OverlayAlertType.load);
            final currentUser = getIt<SettingBloc>().user!;
            getIt<SettingBloc>().add(DoUpdateUserInfoEvent(
                currentUser.copyWith(picture: state.updatedUser!.picture)));
          }
        }
      },
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          final user = getIt<SettingBloc>().user ?? UserModel.empty();
          final width = MediaQuery.of(context).size.width;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      final path = await getImagePicker();
                      if (context.mounted) {
                        getIt<AlertManageUtil>()
                            .show(type: OverlayAlertType.load);
                        context.read<ProfileCubit>().uploadPicture(path);
                      }
                    } catch (_) {}
                  },
                  child: CircleImageProfile(
                      size: width * 0.2,
                      imageMain: user.picture,
                      colorBottomIcon: whiteColorTheme,
                      typeSourceImage:
                          (user.picture?.startsWith('http') == true ||
                                  user.picture?.startsWith('/media') == true ||
                                  user.picture?.startsWith('media') == true)
                              ? TypeSourceImage.network
                              : (user.picture?.isNotEmpty == true
                                  ? TypeSourceImage.file
                                  : TypeSourceImage.asset),
                      backgroundBottonIcon: secondaryColorTheme,
                      showSubIcon: true),
                ),
                const SizedBox(height: 10),
                Text(
                  user.fullName ?? '',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: fontFamilyMontserrat),
                ),
                Text(
                  '@${user.username}',
                  style: const TextStyle(
                      fontSize: minimalMonserratSize + 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
