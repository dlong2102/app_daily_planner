import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_info.json');
  }

  Future<void> saveUserInfo(User user) async {
    try {
      final file = await _localFile;
      final filePath = file.path;
      print('Saving user info to: $filePath');

      final jsonString = json.encode(user.toJson());
      await file.writeAsString(jsonString);

      print('User info saved successfully');

      // Verify if the file was created and contains data
      if (await file.exists()) {
        final contents = await file.readAsString();
        print('File contents: $contents');
      } else {
        print('File does not exist after saving');
      }
    } catch (e) {
      print('Error saving user info: $e');
    }
  }

  Future<User?> getUserInfo() async {
    try {
      final file = await _localFile;
      final filePath = file.path;
      print('Reading user info from: $filePath');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        print('File contents: $jsonString');
        return User.fromJson(json.decode(jsonString));
      } else {
        print('User info file does not exist');
      }
    } catch (e) {
      print('Error reading user info: $e');
    }
    return null;
  }
}
