import 'package:flutter/material.dart';
import 'package:internship_assignment/home_page.dart';

class AddWidgetspage extends StatefulWidget {
  const AddWidgetspage({super.key});

  @override
  State<AddWidgetspage> createState() => _AddWidgetspageState();
}

class _AddWidgetspageState extends State<AddWidgetspage> {
  bool? addtext = false;
  bool? addImage = false;
  bool? addSubmit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.blue[200], borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Checkbox(
                        value: addtext,
                        onChanged: ((value) {
                          setState(() {
                            addtext = value;
                          });
                        }),
                      ),
                      title: Text("Add Text Widget"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Checkbox(
                        value: addImage,
                        onChanged: ((value) {
                          setState(() {
                            addImage = value;
                          });
                        }),
                      ),
                      title: Text("Add Image Widget"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Checkbox(
                        value: addSubmit,
                        onChanged: ((value) {
                          setState(() {
                            addSubmit = value;
                          });
                        }),
                      ),
                      title: Text("Add Submit Button"),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                textWidget: addtext,
                                selectImageWidget: addImage,
                                saveButtonWidget: addSubmit,
                              )));
                },
                child: Text("Submit"))
          ],
        ),
      ),
    ));
  }
}
