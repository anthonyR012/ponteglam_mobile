import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/client/rate/domain/use_case/do_reply_rating.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit({
    required this.doListRatings,
    required this.doCreateRating,
    required this.doReplyRating,
  }) : super(const RatingState());

  final DoListRatings doListRatings;
  final DoCreateRating doCreateRating;
  final DoReplyRating doReplyRating;

  Future<void> loadRatings(int serviceId) async {
    emit(state.copyWith(status: RatingStatus.loading, errorMessage: null));
    final result = await doListRatings(serviceId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: RatingStatus.failure,
        errorMessage: failure.message,
      )),
      (ratings) => emit(state.copyWith(
        status: RatingStatus.success,
        ratings: ratings,
      )),
    );
  }

  Future<void> submitRating(CreateRatingParams params) async {
    emit(state.copyWith(
      submitStatus: RatingSubmitStatus.loading,
      clearSubmitError: true,
    ));
    final result = await doCreateRating(params);
    result.fold(
      (failure) => emit(state.copyWith(
        submitStatus: RatingSubmitStatus.failure,
        submitErrorMessage: failure.message,
      )),
      (newRating) {
        final currentRatings = List<RatingModel>.from(state.ratings);
        final index = currentRatings.indexWhere((r) => r.id == newRating.id);

        if (index != -1) {
          currentRatings[index] = newRating;
        } else {
          currentRatings.insert(0, newRating);
        }

        emit(state.copyWith(
          submitStatus: RatingSubmitStatus.success,
          ratings: currentRatings,
        ));
      },
    );
  }

  Future<void> submitReply(ParamsDoReplyRating params) async {
    emit(state.copyWith(
      submitStatus: RatingSubmitStatus.loading,
      clearSubmitError: true,
    ));
    final result = await doReplyRating(params);
    result.fold(
      (failure) => emit(state.copyWith(
        submitStatus: RatingSubmitStatus.failure,
        submitErrorMessage: failure.message,
      )),
      (updatedRating) {
        final currentRatings = List<RatingModel>.from(state.ratings);
        final index =
            currentRatings.indexWhere((r) => r.id == updatedRating.id);

        if (index != -1) {
          currentRatings[index] = updatedRating;
        }

        emit(state.copyWith(
          submitStatus: RatingSubmitStatus.success,
          ratings: currentRatings,
        ));
      },
    );
  }

  void resetSubmitStatus() {
    emit(state.copyWith(
      submitStatus: RatingSubmitStatus.idle,
      clearSubmitError: true,
    ));
  }
}
