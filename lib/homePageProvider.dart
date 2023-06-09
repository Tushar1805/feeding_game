import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class HomePageProvider extends ChangeNotifier {
  bool loading = false;
  List<String> animals = ["Cat", "Mice"];
  List<DropdownMenuItem> animalList = [];
  String selectedAnimal = "cat";
  String _mediaLink = '';
  bool _isImageUploading = false;

  double animalSize = 1;

  HomePageProvider() {
    loading = true;
    notifyListeners();
    getDropdownItems();
    getSize(selectedAnimal);
    loading = false;
    notifyListeners();
  }

  void getDropdownItems() {
    for (var i = 0; i < animals.length; i++) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Text(animals[i].toString()),
        value: animals[i].toLowerCase().toString(),
      );
      animalList.add(item);
    }
  }

  void selectAnimal(animal) {
    selectedAnimal = animal;
    print(selectedAnimal);
    getSize(animal);
    notifyListeners();
  }

  void setIsImageUploading(value) {
    _isImageUploading = value;
    notifyListeners();
  }

  String get mediaLink => _mediaLink;
  bool get isImageUploading => _isImageUploading;

  void addMedia(String url) {
    _mediaLink = url;
    notifyListeners();
  }

  Future chooseFile() async {
    ImagePicker picker = ImagePicker();

    String path = (await picker.getImage(source: ImageSource.camera)).path;

    uploadFile(File(path));
  }

  Future uploadFile(File image) async {
    setIsImageUploading(true);
    try {
      String url = await upload(image);
      addMedia(url);
      setIsImageUploading(false);
    } catch (e) {
      print("ERROR: Uploading Images");
    }
  }

  Future<String> upload(File image) async {
    try {
      String name = 'AnimalImages/' + DateTime.now().toIso8601String();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('$name/${path.basename(image.path)}');

      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask;
      String url = await storageReference.getDownloadURL();
      print("Image Link: ${url.toString()}");
      return url;
    } catch (e) {
      print('upload(): error: ${e.toString()}');
      throw (e.toString());
    }
  }

  Future<void> submit(animal) async {
    try {
      animalSize += 0.4;
      notifyListeners();
      await FirebaseFirestore.instance.collection(animal).doc(animal).set({
        'size': animalSize,
      }, SetOptions(merge: true));
      _mediaLink = '';
      notifyListeners();
    } catch (e) {
      print("ERROR: Uploading data: ${e.toString()}");
    }
  }

  Future<void> getSize(animal) async {
    try {
      print("Animal current: $animal");
      await FirebaseFirestore.instance
          .collection(animal)
          .doc(animal)
          .get()
          .then((value) => animalSize = value.data()["size"].toDouble());
      notifyListeners();
    } catch (e) {
      print("ERROR: Fetching Data : ${e.toString()}");
    }
  }
}
