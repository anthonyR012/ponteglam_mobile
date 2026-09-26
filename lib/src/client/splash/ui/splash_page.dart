import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/title_label_widget.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/src/client/sign_in/ui/sign_in_page.dart';
import 'package:ponte_glam/src/client/splash/ui/introduction_animation_page.dart';
import 'package:ponte_glam/shared/widgets/icon_center_animation_widget.dart';
import 'package:ponte_glam/src/supplier/home/ui/home_supplier_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const String routeName = "/";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().doInitApp(context: context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preChacheImage();
  }

  void _preChacheImage() async {
    await precacheImage(
        const AssetImage("$pathManagementImages$imagePonteGradient"), context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashInitCompleted) {
              _goToSignIn();
            } else if (state is AlreadyLogin) {
              _goToHome(state.user);
            } else if (state is FistTimeInit) {
              _goToGettingStarted();
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconCenterAnimationSplash(
                  size: width * 0.8,
                ),
                TextLabelWidget(
                  text: "PonteGlam",
                  styleTextItem: StyleTextItem(
                    gradientText: glamGradientTheme,
                    fontSize: h1Size + 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToHome(UserModel user) {
    getIt<SettingBloc>().user = user;

    final savedPlaceId = getIt<SharedPreferences>().getInt(keyPlace);
    if (savedPlaceId != null && savedPlaceId != -1) {
      context.goNamed(HomePageSupplier.routeName);
    } else {
      context.goNamed(HomePage.routeName);
    }
  }

  void _goToGettingStarted() {
    context.pushNamed(IntroductionAnimationPage.routeName);
  }

  void _goToSignIn() {
    context.goNamed(SignInPage.routeName);
  }
}
