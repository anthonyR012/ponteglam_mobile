import 'package:dartz/dartz.dart';
import 'package:ponte_glam/core/errors/failure.dart';
import 'package:url_launcher/url_launcher.dart';

class DoMakeCall {
  DoMakeCall();

  Future<Either<Failure, bool>> call({required String phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      final result = await launchUrl(launchUri);
      return Right(result);
    } else {
      return Left(WentWrongFailure("Could not launch $phoneNumber"));
    }
  }
}
