import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/keys_constant.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/shared/blocs/cubit_splash/splash_cubit.dart';
import 'package:ponte_glam/src/client/splash/ui/widgets/explain_view.dart';
import 'package:ponte_glam/src/client/splash/ui/widgets/center_next_button.dart';
import 'package:ponte_glam/src/client/splash/ui/widgets/key_vew.dart';
import 'package:ponte_glam/src/client/splash/ui/widgets/relax_view.dart';
import 'package:ponte_glam/src/client/splash/ui/widgets/top_back_skip_view.dart';
import 'package:ponte_glam/src/client/splash/ui/widgets/welcome_view.dart';
import 'package:ponte_glam/src/client/sign_up/ui/sign_up_page.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/splash_view.dart';

class IntroductionAnimationPage extends StatefulWidget {
  const IntroductionAnimationPage({super.key});
  static const String routeName = 'introduction_animation';

  @override
  State<IntroductionAnimationPage> createState() =>
      _IntroductionAnimationPageState();
}

class _IntroductionAnimationPageState extends State<IntroductionAnimationPage>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  String messageIsolate = "";

  @override
  void initState() {
    _createIsolate();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColorTheme,
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
            ),
            RelaxView(
              animationController: _animationController!,
            ),
            ExplainView(
              animationController: _animationController!,
            ),
            KeyVew(
              animationController: _animationController!,
            ),
            WelcomeView(
              animationController: _animationController!,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
              onTapAlreadyRegistered: _alreadyRegisterClick,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    _animationController?.animateTo(0.8,
        duration: const Duration(milliseconds: 1200));
  }

  void _alreadyRegisterClick() async {
    if (messageIsolate.isEmpty) {
      await _initApp();
      if (mounted) {
        context.read<SplashCubit>().doInitApp(context: context);
        Navigator.pop(context);
      }
    } else {
      PonteSnackBar.show(
        context,
        message: messageIsolate,
        type: TypeAlert.info,
      );
    }
  }

  Future<void> _initApp() async {
    await getIt<SharedPreferences>().setBool(keyInitApp, false);
  }

  void _createIsolate() async {
    messageIsolate = "";
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  void _onNextClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() async {
    if (messageIsolate.isEmpty) {
      await _initApp();
      if (mounted) {
        context.pushReplacementNamed(SignUpPage.routeName);
      }
    } else {
      PonteSnackBar.show(
        context,
        message: messageIsolate,
        type: TypeAlert.info,
      );
    }
  }
}
