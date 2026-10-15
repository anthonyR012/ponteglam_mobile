import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/devices_size_constant.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/confirmation_account/ui/confirmation_page.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/src/client/sign_up/ui/responsive/big_mobile_page.dart';
import 'package:ponte_glam/src/client/sign_up/ui/responsive/small_mobile_page.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String routeName = 'sign_up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final OverlayAlertType _alertType = OverlayAlertType.load;
  final AlertManageUtil _alertManage = getIt<AlertManageUtil>();

  @override
  void dispose() {
    _focusNodeName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide SignInCubit so that Google sign-up can be handled here.
    return BlocProvider.value(
      value: getIt<SignInCubit>(),
      child: Builder(builder: (innerCtx) {
        return BlocListener<SignInCubit, SignInState>(
          listener: _listenerGoogle,
          child: LayoutBuilder(builder: (ctx, constraints) {
            if (constraints.maxWidth <= mediumMobileX) {
              return SmallMobilePersonalInformationPage(
                focusNodeName: _focusNodeName,
                focusNodeEmail: _focusNodeEmail,
                focusNodePassword: _focusNodePassword,
                controllerName: _controllerName,
                controllerEmail: _controllerEmail,
                controllerPassword: _controllerPassword,
                formKey: _formKey,
                signUp: _signUp,
                signUpWithGoogle: _signUpWithGoogle,
                listener: _listenerProvider,
                changeFocusNode: _changeFocusNode,
              );
            } else {
              return BigMobilePersonalInformationPage(
                focusNodeName: _focusNodeName,
                focusNodeEmail: _focusNodeEmail,
                focusNodePassword: _focusNodePassword,
                controllerName: _controllerName,
                controllerEmail: _controllerEmail,
                controllerPassword: _controllerPassword,
                formKey: _formKey,
                listener: _listenerProvider,
                signUp: _signUp,
                signUpWithGoogle: _signUpWithGoogle,
                changeFocusNode: _changeFocusNode,
              );
            }
          }),
        );
      }),
    );
  }

  void _changeFocusNode(
      String value, FocusNode unFocusNode, FocusNode focusNode) {
    _verifyForm();
    unFocusNode.unfocus();
    FocusScope.of(context).requestFocus(focusNode);
  }

  bool _verifyForm() {
    return !_formKey.currentState!.validate();
  }

  // ─── Sign up with email / password ───────────────────────────────────────

  void _listenerProvider(BuildContext context, SignUpState state) {
    if (state is SignUpIsLoading) {
      _alertManage.show(type: _alertType);
    } else if (state is SignUpError) {
      _alertManage.hide(type: _alertType);
      PonteSnackBar.show(
        context,
        message: state.messageError,
        type: TypeAlert.error,
      );
      context.read<SignUpCubit>().resetState();
    } else if (state is SignUpGetLoaded) {
      _alertManage.hide(type: _alertType);
      context.pushReplacementNamed(
        ConfirmationAccountPage.routeName,
        extra: state.user,
        queryParameters: {'canSendCode': 'true'},
      );
      context.read<SignUpCubit>().resetState();
    }
  }

  void _signUp() async {
    if (_verifyForm()) return;
    final UserModel user = UserModel(
        password: _controllerPassword.text,
        username: _controllerEmail.text,
        email: _controllerEmail.text,
        fullName: _controllerName.text,
        picture: getIt<SignUpCubit>().imageUpload,
        token: null,
        id: null);
    context.read<SignUpCubit>().doSignUp(user: user);
    await Future.delayed(Durations.short1);
  }

  // ─── Sign up with Google ─────────────────────────────────────────────────

  void _signUpWithGoogle(bool acceptedTerms) {
    context.read<SignInCubit>().doSignIn(
        repository: Repository.firebase, acceptedTerms: acceptedTerms);
  }

  void _listenerGoogle(BuildContext context, SignInState state) {
    if (state is SignInIsLoading) {
      _alertManage.show(type: _alertType);
    } else if (state is SignInError) {
      _alertManage.hide(type: _alertType);
      PonteSnackBar.show(
        context,
        message: state.messageError,
        type: TypeAlert.error,
      );
      getIt<SignInCubit>().resetState();
    } else if (state is SignInGetLoaded) {
      _alertManage.hide(type: _alertType);
      if (state.user.emailVerified == true) {
        final UserModel user =
            userModelFromJson(jsonEncode(state.user.toJson()));
        getIt<SettingBloc>().user = user;
        context.goNamed(HomePage.routeName);
      } else {
        final UserModel user =
            userModelFromJson(jsonEncode(state.user.toJson()));
        context.pushReplacementNamed(
          ConfirmationAccountPage.routeName,
          extra: user,
          queryParameters: {'canSendCode': 'true'},
        );
      }
      getIt<SignInCubit>().resetState();
    }
  }
}
