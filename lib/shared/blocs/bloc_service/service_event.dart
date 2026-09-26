part of 'service_bloc.dart';

sealed class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class MakeCallServiceEvent extends ServiceEvent {
  const MakeCallServiceEvent({required this.phoneNumber});
  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class DoFilterServiceEvent extends ServiceEvent {
  final int? category;
  final int? city;
  final int? starts;
  final String? query;
  final bool onlyOffers;
  final bool onlyVerified;
  final bool nearMe;
  final int? minPrice;
  final int? maxPrice;
  final List<int> availableFor;

  const DoFilterServiceEvent(
      {this.city,
      this.starts,
      this.minPrice,
      this.maxPrice,
      this.category,
      this.query,
      this.availableFor = const [],
      this.onlyOffers = false,
      this.onlyVerified = false,
      this.nearMe = true});

  @override
  List<Object> get props => [
        city ?? 0,
        starts ?? 0,
        minPrice ?? 0,
        maxPrice ?? 0,
        category ?? 0,
        query ?? "",
        availableFor,
        onlyOffers,
        onlyVerified,
        nearMe
      ];
}

class DoResetServiceEvent extends ServiceEvent {
  const DoResetServiceEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilterEvent extends ServiceEvent {
  final FilterServiceModel filter;
  const UpdateFilterEvent(this.filter);

  @override
  List<Object> get props => [filter];
}
