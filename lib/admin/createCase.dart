import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ihssan_app/database.dart';
import 'package:ihssan_app/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  String name, description, phone, state, image;

  final _imagePicker = ImagePicker();

  File _imageFile;

  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  Future pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
    uploadFile();

    Navigator.pop(context);
  }

  uploadFile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage
        .ref()
        .child('cases/${Path.basename(_imageFile.path)}}');
    UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() {
      image = storageReference.getDownloadURL().toString();
    });
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        image = fileURL;
      });
    });
  }

  void pickImageModal(BuildContext context){
    showModalBottomSheet(context: context,
        builder: (BuildContext context){
      return Container(
        height: 400.0,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text("Pick an Image"),
            SizedBox(height: 10,),
            MaterialButton(
              color: Colors.orangeAccent,
              child: Text("Use Camera"),
                onPressed: () {
                  pickImage(context, ImageSource.camera);
                }
            ),
            SizedBox(height: 10,),
            MaterialButton(
                color: Colors.orangeAccent,
              child: Text("Choose from Gallery"),
                onPressed: () {
                  pickImage(context, ImageSource.gallery);
                })
          ],
        ),
      );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        appBar: AppBar(title: Text('New Case',
          style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.orangeAccent,),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: ClipOval(
                      child: InkWell(
                        onTap: () {
                          pickImageModal(context);
                        },
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child:
                          _imageFile != null ?
                              Image.file(_imageFile, fit: BoxFit.fill,)
                          :
                              Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.orangeAccent,
                                ),
                              )
                        ),
                      ),
                    ),
                  )
                ),
                // Add TextFormFields and ElevatedButton here.
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'name',
                        border: UnderlineInputBorder(),
                        labelText: 'Enter case name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      name = value;
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'description',
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your case description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      description = value;
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(

                        border: OutlineInputBorder(),
                        labelText: 'case phone number',
                        hintText: '  phone number'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else if (value.length < 8) {
                        return "PHONE should be at least 8 numbers";
                      } else if (value.length > 13) {
                        return "Phone Number should not be greater than 13 numbers";
                      } else
                        phone = value;
                        return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'state',
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your case state'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter state';
                      }
                      state = value;
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent, // background
                    onPrimary: Colors.black, // foreground
                  ),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Database.addCase(name: name, description: description, tel: phone, state: state, image: image, status: "New");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data ....')));
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
