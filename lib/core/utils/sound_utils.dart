import 'package:audioplayers/audioplayers.dart';

class SoundUtil {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playNotificationSound() async {
    try {
      await _player.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      // ignore: avoid_print
      print('Error playing sound: $e');
    }
  }
}
