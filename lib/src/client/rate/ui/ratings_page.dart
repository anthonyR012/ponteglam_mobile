import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/service_model.dart';
import 'package:ponte_glam/src/client/rate/domain/use_case/do_reply_rating.dart';
import 'package:ponte_glam/src/client/rate/ui/widgets/create_rating_form_widget.dart';
import 'package:ponte_glam/src/client/rate/ui/widgets/rating_card_widget.dart';
import 'package:ponte_glam/shared/widgets/modern_form_elements.dart';
import 'package:ponte_glam/shared/widgets/ponte_alert_dialog.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({
    super.key,
    required this.serviceId,
    required this.serviceName,
    this.appointmentId,
    this.canReview = false,
    this.isSupplierMode = false,
    this.myRating,
  });

  static const String routeName = 'ratings';

  final int serviceId;
  final String serviceName;

  /// Needed when showing the create-rating form.
  final int? appointmentId;

  /// Whether the authenticated user is eligible to submit a new rating.
  final bool canReview;

  /// Whether the user is viewing this page as a supplier.
  final bool isSupplierMode;

  /// Previous rating to allow editing
  final MyRatingModel? myRating;

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  late RatingCubit _cubit;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<RatingCubit>();
    _cubit.loadRatings(widget.serviceId);
  }

  bool get _showForm =>
      widget.canReview && (widget.myRating == null || _isEditing);
  bool get _showEditButton =>
      widget.canReview && widget.myRating != null && !_isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: backgroundColorTheme,
        appBar: AppBar(
          backgroundColor: appBarColorTheme,
          title: Text(
            getIt<AppLocalizations>().titleRatings,
            style: const TextStyle(color: whiteColorTheme),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: whiteColorTheme),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocListener<RatingCubit, RatingState>(
          listener: (context, state) {
            if (state.submitStatus == RatingSubmitStatus.success) {
              setState(() => _isEditing = false);
            }
          },
          child: BlocBuilder<RatingCubit, RatingState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  if (_showEditButton)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: _EditRatingButton(
                          onPressed: () => setState(() => _isEditing = true),
                        ),
                      ),
                    ),
                  if (_showForm)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: CreateRatingFormWidget(
                          serviceId: widget.serviceId,
                          appointmentId: widget.appointmentId ?? 0,
                          cubit: _cubit,
                          myRating: widget.myRating,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        getIt<AppLocalizations>().titleRatings,
                        style: const TextStyle(
                          fontFamily: fontFamilyMontserrat,
                          fontWeight: FontWeight.bold,
                          fontSize: h3Size,
                          color: blackColorTheme,
                        ),
                      ),
                    ),
                  ),
                  _buildRatingsList(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRatingsList(RatingState state) {
    if (state.status == RatingStatus.loading ||
        state.status == RatingStatus.initial) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(color: primaryColorTheme),
        ),
      );
    }

    if (state.status == RatingStatus.failure) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: cancelColorTheme, size: 40),
              const SizedBox(height: 12),
              Text(
                state.errorMessage ?? 'Error al cargar reseñas',
                textAlign: TextAlign.center,
                style: const TextStyle(color: grayTextColorTheme),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _cubit.loadRatings(widget.serviceId),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColorTheme),
                child: Text(
                  getIt<AppLocalizations>().titleRetry,
                  style: const TextStyle(color: whiteColorTheme),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.ratings.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_outline_rounded,
                    size: 60, color: grayTextColorTheme.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  getIt<AppLocalizations>().ratingEmpty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: grayTextColorTheme,
                    fontSize: bodySize,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final rating = state.ratings[index];
            return RatingCardWidget(
              rating: rating,
              isSupplierMode: widget.isSupplierMode,
              onReply: () => _showReplyDialog(context, rating),
            );
          },
          childCount: state.ratings.length,
        ),
      ),
    );
  }

  void _showReplyDialog(BuildContext context, RatingModel rating) {
    final TextEditingController replyController = TextEditingController();
    PonteAlertDialog.show(
      context,
      title: 'Responder a la reseña',
      confirmText: 'Enviar',
      content: SizedBox(
        width: double.maxFinite,
        child: ModernTextField(
          controller: replyController,
          label: "Respuesta",
          hint: 'Escribe tu respuesta aquí...',
          maxLines: 3,
        ),
      ),
      onConfirm: () {
        final reply = replyController.text.trim();
        if (reply.isNotEmpty) {
          _cubit.submitReply(ParamsDoReplyRating(
            ratingId: rating.id,
            reply: reply,
          ));
        }
      },
    );
  }
}

class _EditRatingButton extends StatelessWidget {
  const _EditRatingButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColorTheme.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getIt<AppLocalizations>().ratingSuccess,
                  style: const TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: bodySize,
                    color: blackColorTheme,
                  ),
                ),
                const Text(
                  'Puedes editar tu reseña en cualquier momento.',
                  style: TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    fontSize: minimalMonserratSize,
                    color: grayTextColorTheme,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColorTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text(
              'Editar',
              style: TextStyle(
                color: whiteColorTheme,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
