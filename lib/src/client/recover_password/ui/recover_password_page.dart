import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/src/client/recover_password/ui/responsive/small_mobile_page.dart';
import 'package:ponte_glam/src/client/recover_password/ui/widgets/code_content_widget.dart';
import 'package:ponte_glam/src/client/recover_password/ui/widgets/email_content_widget.dart';
import 'package:ponte_glam/src/client/recover_password/ui/widgets/password_content_widget.dart';
import 'package:ponte_glam/src/client/sign_up/ui/sign_up_page.dart';
import 'package:ponte_glam/shared/widgets/text_option_widget.dart';
import 'package:ponte_glam/shared/widgets/timer_widget.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  static const String routeName = 'recover_password';
  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  RecoverState _lastState = RecoverInitial();
  double width = 0;
  double height = 0;
  final _controllerEmail = TextEditingController();
  final _controllerCode1 = TextEditingController();
  final _controllerCode2 = TextEditingController();
  final _controllerCode3 = TextEditingController();
  final _controllerCode4 = TextEditingController();
  final _controllerCode5 = TextEditingController();
  final _controllerPassword1 = TextEditingController();
  final _controllerPassword2 = TextEditingController();
  final _focusNodeCode1 = FocusNode();
  final _focusNodeCode2 = FocusNode();
  final _focusNodeCode3 = FocusNode();
  final _focusNodeCode4 = FocusNode();
  final _focusNodeCode5 = FocusNode();
  final _focusNodePassword1 = FocusNode();
  final _focusNodePassword2 = FocusNode();
  final OverlayAlertType _alertType = OverlayAlertType.load;
  final AlertManageUtil _alertManage = getIt<AlertManageUtil>();
  UserModel? _gettingUser;
  int _secondsRemaining = 60 * 15;
  bool _isButtonDisabled = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SmallMobilePageRecoverPage(
              height: height,
              width: width,
              controllerEmail: _controllerEmail,
              formKey: _formKey,
              goToSingUp: _goToSingUp,
              builderRecover: _builderRecover,
              listenerRecover: _listenerRecover);
        },
      ),
    );
  }

  void _goToSingUp() {
    context.pushReplacementNamed(SignUpPage.routeName);
  }

  bool _verifyForm() {
    return !_formKey.currentState!.validate();
  }

  void _changeFocusNode(String value, FocusNode unFocusNode,
      FocusNode focusNode, BuildContext context) {
    if (value.isEmpty) return;
    unFocusNode.unfocus();
    FocusScope.of(context).requestFocus(focusNode);
  }

  void _listenerRecover(BuildContext context, state) {
    if (state is RecoverIsLoading) {
      _alertManage.show(type: _alertType);
    } else if (state is RecoverError) {
      _alertManage.hide(type: _alertType);
      PonteSnackBar.show(
        context,
        message: state.message,
        type: TypeAlert.error,
      );
    } else if (state is EmailSended || state is CodeVerified) {
      _alertManage.hide(type: _alertType);
    } else if (state is RecoverPassGetLoaded) {
      _saveUser().then((value) {
        _goToHome(value);
      }).onError((error, stackTrace) {
        catchError(error.toString(), stackTrace.toString());
      });
    }
  }

  Widget _getResendProvider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TimerCustomWidget(
          secondsRemaining: _secondsRemaining,
          callbackTimer: (timer) {
            if (_secondsRemaining > 0) {
              setState(() {
                _secondsRemaining--;
              });
            } else if (_isButtonDisabled) {
              _allowResend();
            }
          },
          reloadTimer: _isButtonDisabled,
          colorNumber: _isButtonDisabled ? whiteColorTheme : grayTextColorTheme,
        ),
        InkWell(
          onTap: _isButtonDisabled ? null : _resendEmail,
          child: TextOptionField(
            text: getIt<AppLocalizations>().titleSendCodeAgain,
            colorText: _isButtonDisabled
                ? secondaryColorTheme.withValues(alpha: 0.7)
                : secondaryColorTheme,
          ),
        )
      ],
    );
  }

  Widget _builderRecover(
      BuildContext context, RecoverState state, TypeSizeScreenDevice device) {
    if (state is RecoverError) {
      context.read<RecoverCubit>().setState(_lastState);
    } else if (state is EmailSended) {
      _lastState = EmailSended(state.sucess);
      return ContentRecoverPassConfirmationWidet(
          sizeScreen: device,
          width: width,
          titlePage: getIt<AppLocalizations>().sentenceDigitCodeSended,
          controllerCode1: _controllerCode1,
          controllerCode2: _controllerCode2,
          controllerCode3: _controllerCode3,
          controllerCode4: _controllerCode4,
          focusNodeCode1: _focusNodeCode1,
          focusNodeCode2: _focusNodeCode2,
          focusNodeCode3: _focusNodeCode3,
          focusNodeCode4: _focusNodeCode4,
          controllerCode5: _controllerCode5,
          focusNodeCode5: _focusNodeCode5,
          changeFocusNode: _changeFocusNode,
          getResendProvider: _getResendProvider,
          verifyEmail: _verifyEmail);
    } else if (state is CodeVerified) {
      _lastState = CodeVerified(state.user);
      _gettingUser = state.user;
      return PasswordContentWidget(
          controllerPassword1: _controllerPassword1,
          controllerPassword2: _controllerPassword2,
          focusPassword1: _focusNodePassword1,
          focusPassword2: _focusNodePassword2,
          width: width,
          titlePage: getIt<AppLocalizations>().sentenceDigitNewPassword,
          updatePassword: _updatePassword,
          changeFocusNode: _changeFocusNode);
    } else if (state is RecoverInitial) {
      return EmailContentRecoverWidget(
        controllerEmail: _controllerEmail,
        sendEmailVerification: _sendEmailVerification,
        width: width,
        titlePage: getIt<AppLocalizations>().titleRecover,
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Future<UserModel> _saveUser() async {
    ParamsDoSaveUser params = ParamsDoSaveUser(
        prefs: getIt<SharedPreferences>(),
        storage: getIt<IStorage>(),
        user: _gettingUser!,
        dataFrom: Repository.local);
    await context.read<SignInCubit>().saveUserCall(params: params);
    return _gettingUser!;
  }

  void _goToHome(UserModel user) {
    getIt<SettingBloc>().user = user;
    context.goNamed(HomePage.routeName);
  }

  void _sendEmailVerification() {
    if (_verifyForm()) return;
    context.read<RecoverCubit>().doSendEmail(email: _controllerEmail.text);
  }

  void _resendEmail() async {
    _secondsRemaining = 60 * 15;
    _allowResend();
    await context
        .read<RecoverCubit>()
        .recoverSendEmailCall(email: _controllerEmail.text);
  }

  void _allowResend() {
    setState(() {
      _isButtonDisabled = !_isButtonDisabled;
    });
  }

  void _verifyEmail() async {
    if (_verifyForm()) return;
    String char1 = _controllerCode1.text;
    String char2 = _controllerCode2.text;
    String char3 = _controllerCode3.text;
    String char4 = _controllerCode4.text;
    String char5 = _controllerCode5.text;
    String code = "$char1$char2$char3$char4$char5";
    context
        .read<RecoverCubit>()
        .doVerifyCode(code: code, email: _controllerEmail.text);
  }

  void _updatePassword() {
    if (_verifyForm()) return;
    String newPassword = _controllerPassword1.text;
    final newUser = _gettingUser!.copyWith(password: newPassword);
    context.read<RecoverCubit>().doUpdatePassword(user: newUser);
  }
}
