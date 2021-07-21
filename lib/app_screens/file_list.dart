import 'package:flutter/material.dart';
import 'dart:io';
import "package:file_manager/file_manager.dart";
import '/app_screens/main_calculator%20_screen.dart';
import 'global_variables.dart';
import 'file_utils.dart';

class LoadFileList extends StatefulWidget {
  @override
  _LoadFileListState createState() => _LoadFileListState();
}

class _LoadFileListState extends State<LoadFileList> {
  final FileManagerController controller = FileManagerController();

  final myDir = Directory('/storage/emulated/0/NoteAndCalculate/');

  final Fileutils fileutils = new Fileutils();

  var fileName = '';

  printFile(String fName) async {
    //replace the trailin ' with nothing
    fName = fName.replaceAll("'", "");
    print("fName = $fName");
    content = await fileutils.readMyFile(fName);

    print("content is ; $content");

    //call setstate to update content variabl in global

    set();
    return;
  }

  set() {
    setState(() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainCalculatorScreen(content)));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Creates a widget that registers a callback to veto attempts by the user to dismiss the enclosing
    // or controllers the system's back button
    return WillPopScope(
      onWillPop: () async {
        if (await controller.isRootDirectory()) {
          return true;
        } else {
          controller.goToParentDirectory();
          return false;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: my_color,
            actions: [],
            title: ValueListenableBuilder<String>(
              valueListenable: controller.titleNotifier,
              builder: (context, title, _) => Text("select a file"),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            child: FileManager(
              controller: controller,
              builder: (context, snapshot) {
                final List<FileSystemEntity> entities =
                    myDir.listSync(recursive: false).toList();
                return ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    FileSystemEntity entity = entities[index];
                    return Card(
                      child: ListTile(
                        leading: FileManager.isFile(entity)
                            ? Icon(Icons.feed_outlined)
                            : Icon(Icons.folder),
                        title: Text(FileManager.basename(entity)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          color: my_color,
                          onPressed: () async {
                            //delete a file
                            await entity.delete();

                            ///reload page to update the list
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoadFileList()));
                          },
                        ),
                        onTap: () async {
                          if (FileManager.isDirectory(entity)) {
                            // open the folder
                            //controller.openDirectory(entity);

                            // delete a folder
                            // await entity.delete(recursive: true);

                            // rename a folder
                            // await entity.rename("newPath");

                            // Check weather folder exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;
                          } else {
                            print("tapped file is $entity");
                            fileName = entity.toString();
                            fileName = fileName.split("/").last;

                            print(fileName);
                            printFile(fileName);
                            // print("content should print here $content");

                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             LoadFileList()));

                            // rename a file
                            // await entity.rename("newPath");

                            // Check weather file exists
                            // entity.exists();

                            // get date of file
                            // DateTime date = (await entity.stat()).modified;

                            // get the size of the file
                            // int size = (await entity.stat()).size;
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )),
    );
  }
}
