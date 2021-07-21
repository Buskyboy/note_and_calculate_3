import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class Fileutils {
  Future<bool> saveMyFile(String contents, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory() as Directory;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/NoteAndCalculate";
          directory = Directory(newPath);
          print("directory is :   $directory");
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      print("savefile $saveFile");

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        print("directory exists");
        File saveFile = File(directory.path + "/$fileName");
        print("savefile $saveFile");
        saveFile.writeAsString(contents);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> readMyFile(String fileName) async {
    Directory directory;
    String text;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory() as Directory;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/NoteAndCalculate";
          directory = Directory(newPath);
          print("directory is :   $directory");
        } else {
          return '';
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return "no permission";
        }
      }

      print("directory exists");
      final readFile = File(directory.path + "/$fileName");
      print("readfile $readFile");
      text = await readFile.readAsString(encoding: utf8);
      print("text ;   $text");
    } catch (e) {
      print(e);
      return '';
    }
    return text;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
