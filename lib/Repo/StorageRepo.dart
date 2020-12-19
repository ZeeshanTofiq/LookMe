import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:look_me/Repo/AuthRepo.dart';
import 'package:path/path.dart';

class StorageRepo {
  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://lookme-295f9.appspot.com');

  Future uploadProfileImg(File file) async {
    final currentUser = await AuthRepo().getCurrent();
    StorageReference storageRef =
        this._storage.ref().child('lookMe/ProfileImages/${currentUser.uid}');
    StorageUploadTask uploadTask = storageRef.putFile(file);
    final completeTask = await uploadTask.onComplete;
    return await completeTask.ref.getDownloadURL();
  }

  Future uploadDocFile(File file) async {
    final currentUser = await AuthRepo().getCurrent();
    final currentDate = DateTime.now();
    final storageRef = this
        ._storage
        .ref()
        .child('/lookMe/Documents/doc-${currentUser.uid}-$currentDate');
    final uploadTask = storageRef.putFile(file);
    final completeTask = await uploadTask.onComplete;
    return await completeTask.ref.getDownloadURL();
  }

  Future<void> deleteFile(String fileUrl) async {
    String filePath = Uri.decodeFull(basename(fileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');
    await this._storage.ref().child(filePath).delete();
  }

  Future<StorageUploadTask> uploadFileStream(File largeFile,Function progressIndicator) async {

    final currentUser = await AuthRepo().getCurrent();
    final currentDate = DateTime.now();

    StorageUploadTask task =  this._storage.ref().child('/lookMe/Documents/doc-${currentUser.uid}-$currentDate').putFile(largeFile);
    task.events.listen((StorageTaskEvent event) {
      final val =
          (event.snapshot.bytesTransferred / event.snapshot.totalByteCount)*100;
      print('Task state: ${event.type}');
      print('Progress: $val %');
      progressIndicator(val);
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.lastSnapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });
    return task;
  }
}
