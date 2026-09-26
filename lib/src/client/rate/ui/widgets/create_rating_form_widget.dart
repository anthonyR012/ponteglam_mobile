import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/src/client/rate/ui/widgets/star_display_widget.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';

class CreateRatingFormWidget extends StatefulWidget {
  const CreateRatingFormWidget({
    super.key,
    required this.serviceId,
    required this.appointmentId,
    required this.cubit,
    this.myRating,
  });

  final int serviceId;
  final int appointmentId;
  final RatingCubit cubit;
  final MyRatingModel? myRating;

  @override
  State<CreateRatingFormWidget> createState() => _CreateRatingFormWidgetState();
}

class _CreateRatingFormWidgetState extends State<CreateRatingFormWidget> {
  late int _selectedRating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.myRating?.rating ?? 5;
    _commentController =
        TextEditingController(text: widget.myRating?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.cubit.submitRating(CreateRatingParams(
      serviceId: widget.serviceId,
      appointmentId: widget.appointmentId,
      rating: _selectedRating,
      comment: _commentController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingCubit, RatingState>(
      bloc: widget.cubit,
      listenWhen: (prev, curr) => curr.submitStatus != prev.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == RatingSubmitStatus.success) {
          PonteSnackBar.show(
            context,
            message: getIt<AppLocalizations>().ratingSuccess,
            type: TypeAlert.success,
          );
          widget.cubit.resetSubmitStatus();
        }
      },
      buildWhen: (prev, curr) =>
          curr.submitStatus != prev.submitStatus ||
          curr.submitErrorMessage != prev.submitErrorMessage,
      builder: (context, state) {
        final isLoading = state.submitStatus == RatingSubmitStatus.loading;
        final isSubmitted = state.submitStatus == RatingSubmitStatus.success;

        if (isSubmitted) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: spaceBetween30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: whiteColorTheme,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColorTheme.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: primaryColorTheme.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getIt<AppLocalizations>().ratingWriteTitle,
                style: const TextStyle(
                  fontFamily: fontFamilyMontserrat,
                  fontWeight: FontWeight.bold,
                  fontSize: h3Size,
                  color: blackColorTheme,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: StarSelectorWidget(
                  rating: _selectedRating,
                  onChanged: (val) => setState(() => _selectedRating = val),
                ),
              ),
              const SizedBox(height: 16),
              ModernTextField(
                  controller: _commentController,
                  maxLines: 3,
                  label: getIt<AppLocalizations>().ratingComment),
              if (state.submitErrorMessage != null) ...[
                const SizedBox(height: spaceBetween10),
                Text(
                  state.submitErrorMessage!,
                  style: const TextStyle(
                      color: cancelColorTheme, fontSize: minimalMonserratSize),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColorTheme,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: whiteColorTheme,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          getIt<AppLocalizations>().ratingSend,
                          style: const TextStyle(
                            color: whiteColorTheme,
                            fontFamily: fontFamilyMontserrat,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
