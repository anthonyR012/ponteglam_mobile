import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/devices_size_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/user_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:ponte_glam/src/client/confirmation_account/ui/responsive/big_mobile_page.dart';
import 'package:ponte_glam/src/client/confirmation_account/ui/responsive/small_mobile_page.dart';
import 'package:ponte_glam/src/client/home/ui/home_page.dart';
import 'package:ponte_glam/shared/widgets/text_option_widget.dart';
import 'package:ponte_glam/shared/widgets/timer_widget.dart';

class ConfirmationAccountPage extends StatefulWidget {
  const ConfirmationAccountPage(
      {super.key, required this.user, this.canSendCode = false});
  final UserModel user;
  final bool canSendCode;
  static const String routeName = 'confirmation_account';
  @override
  State<ConfirmationAccountPage> createState() =>
      _ConfirmationAccountPageState();
}

class _ConfirmationAccountPageState extends State<ConfirmationAccountPage> {
  final TextEditingController _controllerCode1 = TextEditingController();
  final TextEditingController _controllerCode2 = TextEditingController();
  final TextEditingController _controllerCode3 = TextEditingController();
  final TextEditingController _controllerCode4 = TextEditingController();
  final TextEditingController _controllerCode5 = TextEditingController();
  final FocusNode _focusNodeCode1 = FocusNode();
  final FocusNode _focusNodeCode2 = FocusNode();
  final FocusNode _focusNodeCode3 = FocusNode();
  final FocusNode _focusNodeCode4 = FocusNode();
  final FocusNode _focusNodeCode5 = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonDisabled = true;
  int _secondsRemaining = 60 * 15;
  final OverlayAlertType _alertType = OverlayAlertType.load;
  final AlertManageUtil _alertManage = getIt<AlertManageUtil>();

  @override
  void initState() {
    if (widget.canSendCode) {
      _sendCodeVerify();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= mediumMobileX) {
            return SmallMobileConfirmationAccountPage(
                controllerCode1: _controllerCode1,
                controllerCode2: _controllerCode2,
                controllerCode3: _controllerCode3,
                controllerCode4: _controllerCode4,
                controllerCode5: _controllerCode5,
                user: widget.user,
                focusNodeCode1: _focusNodeCode1,
                focusNodeCode2: _focusNodeCode2,
                focusNodeCode3: _focusNodeCode3,
                focusNodeCode4: _focusNodeCode4,
                focusNodeCode5: _focusNodeCode5,
                formKey: _formKey,
                isButtonDisabled: _isButtonDisabled,
                resendCode: _resendCode,
                changeFocusNode: _changeFocusNode,
                onTapTimerEnd: _allowResend,
                listener: _listenerProvider,
                getResendProvider: _getResendProvider,
                verifyEmail: _verifyEmail);
          } else {
            return BigMobileConfirmationAccountPage(
                controllerCode1: _controllerCode1,
                controllerCode2: _controllerCode2,
                controllerCode3: _controllerCode3,
                controllerCode4: _controllerCode4,
                controllerCode5: _controllerCode5,
                focusNodeCode1: _focusNodeCode1,
                focusNodeCode2: _focusNodeCode2,
                focusNodeCode3: _focusNodeCode3,
                focusNodeCode4: _focusNodeCode4,
                focusNodeCode5: _focusNodeCode5,
                isButtonDisabled: _isButtonDisabled,
                user: widget.user,
                formKey: _formKey,
                listener: _listenerProvider,
                resendCode: _resendCode,
                onTapTimerEnd: _allowResend,
                changeFocusNode: _changeFocusNode,
                getResendProvider: _getResendProvider,
                verifyEmail: _verifyEmail);
          }
        },
      ),
    );
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
          onTap: _isButtonDisabled ? null : _resendCode,
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

  void _listenerProvider(BuildContext context, ConfirmationState state) {
    if (state is ConfirmationIsLoading) {
      _alertManage.show(type: _alertType);
    } else if (state is ConfirmationError) {
      _alertManage.hide(type: _alertType);
      PonteSnackBar.show(
        context,
        message: state.message,
        type: TypeAlert.error,
      );
      context.read<ConfirmationCubit>().resetState();
    } else if (state is ConfirmationGetLoaded) {
      _alertManage.hide(type: _alertType);
      PonteSnackBar.show(
        context,
        message: state.successMessage,
        type: TypeAlert.success,
      );
      context.goNamed(HomePage.routeName);
      getIt<SettingBloc>().user = widget.user;
      context.read<ConfirmationCubit>().resetState();
    }
  }

  void _verifyEmail() async {
    if (_verifyForm()) return;
    FocusScope.of(context).unfocus();
    String char1 = _controllerCode1.text;
    String char2 = _controllerCode2.text;
    String char3 = _controllerCode3.text;
    String char4 = _controllerCode4.text;
    String char5 = _controllerCode5.text;
    String code = "$char1$char2$char3$char4$char5";
    context
        .read<ConfirmationCubit>()
        .doVerifyEmail(code: code, user: widget.user);
    await Future.delayed(Durations.extralong2);
  }

  void _changeFocusNode(String value, FocusNode unFocusNode,
      FocusNode focusNode, BuildContext context) {
    if (value.isEmpty) {
      unFocusNode.previousFocus();
      return;
    }
    unFocusNode.unfocus();
    FocusScope.of(context).requestFocus(focusNode);
  }

  bool _verifyForm() {
    return !_formKey.currentState!.validate();
  }

  void _resendCode() async {
    _secondsRemaining = 60 * 15;
    _allowResend();
    await _sendCodeVerify();
  }

  void _allowResend() {
    setState(() {
      _isButtonDisabled = !_isButtonDisabled;
    });
  }

  Future<void> _sendCodeVerify() async {
    final state = await context
        .read<ConfirmationCubit>()
        .resendEmailCall(authToken: widget.user.token ?? "");
    if (state.isLeft()) {
      state.foldLeft(null, (previous, r) {
        var trace = StackTrace.current;
        catchError(r, trace.toString());
      });
    }
  }
}
