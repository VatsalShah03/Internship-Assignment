// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internship_assignment/add_widget_page.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  final bool? textWidget;
  final bool? selectImageWidget;
  final bool? saveButtonWidget;
  const HomePage({
    Key? key,
    this.textWidget = false,
    this.selectImageWidget = false,
    this.saveButtonWidget = false,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();
  File? image;
  var ref;

  pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imgTemp = File(image.path);
      setState(() {
        this.image = imgTemp;
      });
    } on PlatformException catch (e) {
      print("Failed to click image: $e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  Future uploadImage() async {
    ref = FirebaseStorage.instance.ref().child('${basename(image!.path)}');
    if (image != null && textController.text.isNotEmpty) {
      await ref.putFile(File(image!.path)).whenComplete(() async {
        await ref.getDownloadURL().then((value) async {
          final docRef = FirebaseFirestore.instance.collection("Data").doc();
          await docRef.set({
            "ImageUrl": value,
            "Text": textController.text.trim(),
            "Id": docRef.id
          });
        });
      });
    }
    if (image == null && textController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("Data")
          .add({"Text": textController.text.trim()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      widget.textWidget == true
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                    hintText: "Enter Text",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                              ),
                            )
                          : Container(),
                      image == null
                          ? SizedBox(
                              height: 20,
                            )
                          : Container(
                              margin: EdgeInsets.all(20),
                              width: 300,
                              height: 300,
                              child: Image.file(
                                image!,
                                fit: BoxFit.fill,
                              ),
                            ),
                      widget.selectImageWidget == true
                          ? ElevatedButton(
                              onPressed: () {
                                pickImage();
                              },
                              child: Text("Pick an Image"))
                          : Container(),
                      widget.saveButtonWidget == true
                          ? ElevatedButton(
                              onPressed: () {
                                if (widget.selectImageWidget == false &&
                                    widget.textWidget == false) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 30),
                                              child: Text(
                                                  "Add atleast 1 field to submit"),
                                            ));
                                      });
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                          child: CircularProgressIndicator(),
                                        ));
                                uploadImage().whenComplete(() {
                                  Navigator.pop(context);
                                  final snackBar = SnackBar(
                                    duration: Duration(seconds: 6),
                                    content: Text('Successfully uploaded'),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                });
                              },
                              child: Text("Submit"))
                          : Container()
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddWidgetspage()));
                    },
                    child: Text("Add Widgets"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
