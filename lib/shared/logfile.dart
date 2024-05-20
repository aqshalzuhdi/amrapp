part of 'shared.dart';

String parentPath = 'AMR - Automatic Mobile Robotic';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<void> prepareDir(String folder) async {
  try {
    final path = await localPath +
        Platform.pathSeparator +
        parentPath +
        Platform.pathSeparator +
        folder;

    // print(path);
    final tempDir = Directory(path);
    bool hasExisted = await tempDir.exists();
    if (!hasExisted) {
      await tempDir.create(recursive: true);
    } else {
      // print(hasExisted);
      // print(path);
    }
  } catch (e) {
    print(("prepareDir cannot created directory: ") + e.toString());
  }
}

Future<File> _localFile(String fileName, String folder) async {
  await prepareDir(folder);

  final path = await localPath;
  return File(path +
      Platform.pathSeparator +
      parentPath +
      Platform.pathSeparator +
      folder +
      Platform.pathSeparator +
      fileName);
}

Future<File> writeLogFile(String fileName, String folder, String data) async {
  final file = await _localFile(fileName, folder);
  // Write the file
  return file.writeAsString('$data\n', mode: FileMode.append);
}

Future<File> writeExcelSettingsFile(String id, String data) async {
  final file = await _localFile(('excel') + id, '');
  // Write the file
  return file.writeAsString(data);
}

Future<String> readExcelSettingsFile(String id) async {
  return await readLogFile(('excel') + id, '');
}

Future<String> readLogFile(String fileName, String folder) async {
  try {
    final file = await _localFile(fileName, folder);
    // Read the file
    final contents = await file.readAsString();
    return contents;
  } catch (e) {
    return 'encountering an error';
  }
}
