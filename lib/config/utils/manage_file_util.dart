import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class ManageFilesUtil {
  ManageFilesUtil();

  Future<Directory> getImageFolder(String folderName) async {
    Directory directory = await getTemporaryDirectory();
    Directory folder = Directory('${directory.path}/$folderName');
    if (!(await folder.exists())) {
      folder = await folder.create(recursive: true);
    }
    return folder;
  }

  Future<String> saveFileLocally(
      {required String nameFile,
      required String folderName,
      required List<int> bytes}) async {
    String pathFolder = (await getImageFolder(folderName)).path;
    String absolutePath = '$pathFolder/$nameFile';
    File file = await File(absolutePath).writeAsBytes(bytes);
    return file.path;
  }

  String getImageNameFromUrl(String url) {
    List<String> parts = url.split('/');
    return parts.last;
  }

  Future<String> getDocumentPath() async {
    final applicationDirectory = await getApplicationDocumentsDirectory();
    return applicationDirectory.path;
  }

  Future<Uint8List> readFile({required String pathFile}) async {
    return await File(pathFile).readAsBytes();
  }
}
