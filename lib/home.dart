import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:upload_file/storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  UploadTask? task;




  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }



  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final location = 'files/$fileName';
    task = Storage.uploadTask(location, file!);
    setState(() {});
    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    // ignore: avoid_print
    print("This is Image   $url");
  }



  Widget uploadStatus(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;
            final uploadPresent = (progress * 100);
            return Text("$uploadPresent%");
          } else {
            return Container();
          }
        });}



  @override
  Widget build(BuildContext context) {
    final filename = file != null ? basename(file!.path) : "No FILE SELECTED";
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          "Upload Files",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        selectFile();
                      },
                      child: const Text("Select File")),
                  Text(filename),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        uploadFile();
                        // ignore: avoid_print
                        print("File Uploaded Successfully");
                      },
                      child: const Text("Upload File")),
                  // ignore: unnecessary_null_comparison
                  task != null ? uploadStatus(task!) : Container()
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
