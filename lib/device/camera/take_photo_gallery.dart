import 'package:image_picker/image_picker.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:ponte_glam/di/get_it_instance.dart';
import 'package:ponte_glam/l10n/app_localizations.dart';

Future<String> getImagePicker({
  ImageSource source = ImageSource.gallery,
  double maxWidth = maxWidthImage,
  double maxHeight = maxHeightImage,
  int imageQuality = imageQuality,
}) async {
  final XFile? pickedFile = await ImagePicker().pickImage(
    source: source,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
  );
  if (pickedFile == null) {
    throw ClientFailure(getIt<AppLocalizations>().failureImageNoSelected);
  }
  return pickedFile.path;
}
