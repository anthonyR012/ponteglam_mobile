import 'package:flutter/material.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';
import 'package:ponte_glam/shared/widgets/title_banner_label_widget.dart';
import 'package:ponte_glam/shared/widgets/unavailable_widget.dart';
import 'package:ponte_glam/src/client/notification/ui/widgets/notification_item_widget.dart';
import 'package:ponte_glam/core/utils/date_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Lista de notificaciones reutilizable para el contexto de cliente y proveedor.
///
/// - [companyId] null → notificaciones de cliente; int → notificaciones de proveedor.
/// - [resetBadgeOnLoad] cuando es true, limpia el contador de no-leídas al entrar.
class NotificationListBody extends StatefulWidget {
  final int? companyId;
  final bool resetBadgeOnLoad;

  const NotificationListBody({
    super.key,
    this.companyId,
    this.resetBadgeOnLoad = false,
  });

  @override
  State<NotificationListBody> createState() => _NotificationListBodyState();
}

class _NotificationListBodyState extends State<NotificationListBody> {
  final ScrollController _scrollController = ScrollController();
  late final HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.notifications.clear();
    homeBloc.nextNotificationUrl = null;
    homeBloc.add(DoGetNotificationEvent(null, true, widget.companyId));

    if (widget.resetBadgeOnLoad) {
      homeBloc.unreadCount = 0;
      homeBloc.add(const SetStateHomeEvent(UnreadCountUpdated(0)));
    }

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final nextUrl = homeBloc.nextNotificationUrl;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        nextUrl != null) {
      homeBloc.add(DoGetNotificationEvent(nextUrl, false, widget.companyId));
    }
  }

  @override
  void dispose() {
    if (widget.resetBadgeOnLoad) {
      for (int i = 0; i < homeBloc.notifications.length; i++) {
        final n = homeBloc.notifications[i];
        if (!n.isRead) homeBloc.notifications[i] = n.copyWith(isRead: true);
      }
    }
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: homeBloc,
      builder: (context, state) {
        final bool isLoading = state is HomeIsLoading;

        if (state is HomeError) {
          return Center(
            child: UnavailableWidget(
              textDescription: state.messageError,
              image: imageNoNotification,
              context: context,
            ),
          );
        }

        if (!isLoading && homeBloc.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none_outlined,
                  size: 64,
                  color: greyBlockColorTheme,
                ),
                const SizedBox(height: 16),
                Text(
                  getIt<AppLocalizations>().noNotificationsYet,
                  style: const TextStyle(
                    color: grayTextColorTheme,
                    fontFamily: fontFamilyMontserrat,
                    fontSize: h5Size + 2,
                  ),
                ),
              ],
            ),
          );
        }

        final hasMore = homeBloc.nextNotificationUrl != null;
        final grouped = _groupByDate(homeBloc.notifications);

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8.0),
          itemCount: isLoading ? 10 : grouped.length + (hasMore ? 2 : 0),
          itemBuilder: (context, index) {
            if (isLoading || index >= grouped.length) {
              return Skeletonizer(
                enabled: true,
                child: NotificationItem(
                  notification: NotificationModel.empty(),
                  isLoading: true,
                ),
              );
            }

            final entry = grouped[index];
            if (entry is _DateHeader) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GetBannerTitleLabel(title: entry.label),
              );
            }
            if (entry is NotificationModel) {
              return NotificationItem(
                notification: entry,
                isLoading: false,
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  List<dynamic> _groupByDate(List<NotificationModel> notifications) {
    final grouped = <dynamic>[];
    final now = AppDateUtils.now();
    String? lastHeader;

    for (final n in notifications) {
      final date = AppDateUtils.fromUtc(DateTime.parse(n.createdAt));
      final label = getIt<DateFormatUtil>().getDateLabelNotification(date, now);
      if (lastHeader != label) {
        grouped.add(_DateHeader(label));
        lastHeader = label;
      }
      grouped.add(n);
    }
    return grouped;
  }
}

class _DateHeader {
  final String label;
  _DateHeader(this.label);
}
