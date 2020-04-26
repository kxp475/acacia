import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localUsernameFile async {
  final path = await _localPath;
  return File('$path/username.txt');
}

Future<File> get _localPasswordFile async {
  final path = await _localPath;
  return File('$path/password.txt');
}

Future<String> readUsername(String name) async {
  try {
    final file = await _localUsernameFile;
    // Read the file
    String contents = await file.readAsString();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return 'Error!';
  }
}

Future<String> readPassword(String name) async {
  try {
    final file = await _localPasswordFile;
    // Read the file
    String contents = await file.readAsString();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return 'Error!';
  }
}

Future<File> writeUsername(String username) async {
  print("writing some content");
  final file1 = await _localUsernameFile;
  // Write the file
  return file1.writeAsString(username);
}

Future<File> writePassword(String password) async {
  print("writing some content");
  final file1 = await _localPasswordFile;
  // Write the file
  return file1.writeAsString(password);
}
