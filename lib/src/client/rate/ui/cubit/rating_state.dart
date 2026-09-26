import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';

enum RatingStatus { initial, loading, success, failure }

enum RatingSubmitStatus { idle, loading, success, failure }

class RatingState {
  final RatingStatus status;
  final List<RatingModel> ratings;
  final String? errorMessage;
  final RatingSubmitStatus submitStatus;
  final String? submitErrorMessage;

  const RatingState({
    this.status = RatingStatus.initial,
    this.ratings = const [],
    this.errorMessage,
    this.submitStatus = RatingSubmitStatus.idle,
    this.submitErrorMessage,
  });

  RatingState copyWith({
    RatingStatus? status,
    List<RatingModel>? ratings,
    String? errorMessage,
    RatingSubmitStatus? submitStatus,
    String? submitErrorMessage,
    bool clearSubmitError = false,
  }) =>
      RatingState(
        status: status ?? this.status,
        ratings: ratings ?? this.ratings,
        errorMessage: errorMessage ?? this.errorMessage,
        submitStatus: submitStatus ?? this.submitStatus,
        submitErrorMessage: clearSubmitError
            ? null
            : submitErrorMessage ?? this.submitErrorMessage,
      );
}
