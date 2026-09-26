import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/shared/model/notification_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:ponte_glam/core/navigation/notification_handler.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final bool isLoading;

  const NotificationItem(
      {super.key, required this.notification, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
        shade: isLoading,
        child: GestureDetector(
          onTap: isLoading
              ? null
              : () => NotificationHandler.handleNotificationTap(context, {
                    'go_to': notification.goTo,
                    'data': notification.data,
                    ...notification.data ?? {},
                  }),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                "$pathManagementIcons$iconNotification",
                colorFilter: ColorFilter.mode(
                    notification.isRead ? Colors.grey[700]! : primaryColorTheme,
                    BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              title: Skeleton.shade(
                child: Text(
                  isLoading ? "_" * 2 : notification.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: h4Size,
                      fontFamily: fontFamilyMontserrat),
                ),
              ),
              subtitle: Text(
                notification.body,
                style: const TextStyle(
                    color: grayTextColorTheme,
                    fontSize: h5Size + 2,
                    fontFamily: fontFamilyLora),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      isLoading
                          ? "_" * 2
                          : getIt<DateFormatUtil>()
                              .tFormatToHout(notification.createdAt),
                      style: TextStyle(
                          color: notification.isRead
                              ? grayTextColorTheme
                              : primaryColorTheme)),
                  if (!notification.isRead)
                    const Icon(Icons.circle, color: primaryColorTheme, size: 8),
                ],
              ),
            ),
          ),
        ));
  }
}
