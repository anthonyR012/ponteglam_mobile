import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/shared/widgets/image_load_widget.dart';
import 'package:ponte_glam/src/client/rate/data/model/rating_model.dart';
import 'package:ponte_glam/src/client/rate/ui/widgets/star_display_widget.dart';

class RatingCardWidget extends StatelessWidget {
  const RatingCardWidget({
    super.key,
    required this.rating,
    this.isSupplierMode = false,
    this.onReply,
  });

  final RatingModel rating;
  final bool isSupplierMode;
  final VoidCallback? onReply;

  String get _formattedDate {
    final dt = rating.createdAt;
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColorTheme,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: blackColorTheme.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _UserAvatar(
                name: rating.userName,
                pictureUrl: rating.userPicture,
              ),
              const SizedBox(width: spaceBetween10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.userName,
                      style: const TextStyle(
                        fontFamily: fontFamilyMontserrat,
                        fontWeight: FontWeight.w600,
                        fontSize: bodySize,
                        color: blackColorTheme,
                      ),
                    ),
                    const SizedBox(height: 2),
                    StarDisplayWidget(rating: rating.rating),
                  ],
                ),
              ),
              Text(
                _formattedDate,
                style: const TextStyle(
                  fontSize: minimalMonserratSize,
                  color: grayTextColorTheme,
                ),
              ),
            ],
          ),
          if (rating.comment.isNotEmpty) ...[
            const SizedBox(height: spaceBetween10),
            Text(
              rating.comment,
              style: const TextStyle(
                fontSize: minimalMonserratSize,
                color: blackColorTheme,
                height: 1.4,
              ),
            ),
          ],
          if (rating.response != null) ...[
            const SizedBox(height: 12),
            _SupplierReplyBubble(reply: rating.response!),
          ] else if (isSupplierMode) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onReply,
                icon: const Icon(Icons.reply, size: 16, color: primaryColorTheme),
                label: const Text(
                  "Responder",
                  style: TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    color: primaryColorTheme,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name, this.pictureUrl});

  final String name;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: ImageLoadWidget(
          image: pictureUrl!,
          width: 42,
          height: 42,
          typeSourceImage: TypeSourceImage.network,
        ),
      );
    }
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: glamGradientTheme,
      ),
      child: Center(
        child: SvgPicture.asset(
          '$pathManagementIcons$iconProfile',
          colorFilter: const ColorFilter.mode(
            whiteColorTheme,
            BlendMode.srcIn,
          ),
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}

class _SupplierReplyBubble extends StatelessWidget {
  const _SupplierReplyBubble({required this.reply});

  final SupplierReplyModel reply;

  String get _formattedDate {
    if (reply.repliedAt == null) return '';
    final dt = reply.repliedAt!;
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (reply.headquarterImage != null && reply.headquarterImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: ImageLoadWidget(
                    image: reply.headquarterImage!,
                    width: 24,
                    height: 24,
                    typeSourceImage: TypeSourceImage.network,
                  ),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: primaryColorTheme,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.store, size: 14, color: whiteColorTheme),
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reply.headquarterName,
                  style: const TextStyle(
                    fontFamily: fontFamilyMontserrat,
                    fontWeight: FontWeight.bold,
                    fontSize: minimalMonserratSize,
                    color: secondaryColorTheme,
                  ),
                ),
              ),
              if (reply.repliedAt != null)
                Text(
                  _formattedDate,
                  style: const TextStyle(
                    fontSize: 10,
                    color: grayTextColorTheme,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reply.message,
            style: const TextStyle(
              fontSize: minimalMonserratSize,
              color: blackColorTheme,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
