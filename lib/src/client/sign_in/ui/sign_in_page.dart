import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/devices_size_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/src/client/confirmation_account/ui/confirmation_page.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/src/client/sign_in/ui/responsive/medium_mobile_page.dart';
import 'package:ponte_glam/src/client/sign_in/ui/responsive/small_mobile_page.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  static const String routeName = 'sign_in';
  final _formKey = GlobalKey<FormState>();
  final AlertManageUtil _alertManage = getIt<AlertManageUtil>();

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNodeEmail = FocusNode();
    final FocusNode focusNodePassword = FocusNode();
    final TextEditingController controllerEmail = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= smallMobileX) {
        return SmallMobileSignInPage(
            controllerEmail: controllerEmail,
            controllerPassword: controllerPassword,
            focusNodeEmail: focusNodeEmail,
            focusNodePassword: focusNodePassword,
            formKey: _formKey,
            listener: _singInListen,
            changeFocusNode: _changeFocusNode);
      } else {
        return MediumSignInMobilePage(
            controllerEmail: controllerEmail,
            controllerPassword: controllerPassword,
            focusNodeEmail: focusNodeEmail,
            focusNodePassword: focusNodePassword,
            formKey: _formKey,
            listener: _singInListen,
            changeFocusNode: _changeFocusNode);
      }
    });
  }

  bool _verifyForm() {
    return !_formKey.currentState!.validate();
  }

  void _changeFocusNode(String value, FocusNode unFocusNode,
      FocusNode focusNode, BuildContext context) {
    _verifyForm();
    unFocusNode.unfocus();
    FocusScope.of(context).requestFocus(focusNode);
  }

  void _singInListen(BuildContext context, SignInState state) {
    if (state is SignInIsLoading) {
      _alertManage.show(type: OverlayAlertType.load);
    } else if (state is SignInError) {
      _alertManage.hide(type: OverlayAlertType.load);
      PonteSnackBar.show(
        context,
        message: state.messageError,
        type: TypeAlert.error,
      );
      context.read<SignInCubit>().resetState();
    } else if (state is SignInGetLoaded) {
      if (state.user.emailVerified!) {
        final UserModel user =
            userModelFromJson(jsonEncode(state.user.toJson()));
        getIt<SettingBloc>().user = user;
        context.goNamed(HomePage.routeName);
      } else {
        context.pushReplacementNamed(ConfirmationAccountPage.routeName,
            extra: state.user,
            queryParameters: {
              'canSendCode': 'true',
            });
      }
      _alertManage.hide(type: OverlayAlertType.load);
      context.read<SignInCubit>().resetState();
    }
  }
}
