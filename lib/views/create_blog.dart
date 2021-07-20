import 'dart:io';
import 'package:flutter_blog_app_ayham/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;




class CreateBlog extends StatefulWidget {


  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  String authorName, title, desc;

  File selectedImage;
  bool _isLoading = false;

  CrudMethods crudMethods = new CrudMethods();


  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image.path);
    });
  }

  uploadBlog()  async {
    if (selectedImage !=null ){
      setState(() {
        _isLoading = true;
      });

// uploading image to firebase storage

      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child("blogImage")
          .child("${randomAlphaNumeric(9)}.jpg");
      final firebase_storage.UploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl =  await (await task).ref.getDownloadURL();
      print("this is url $downloadUrl");
      Map<String , String> blogMap = {
        "imgUrl" :downloadUrl,
        "authorName" : authorName,
        "title" : title,
        "desc" : desc,
      };
      crudMethods.addData(blogMap).then((result) {
        Navigator.pop(context);
      });


    }else {

    }

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ayham",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Text(
              "Blog",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.file_upload),
            ),
          ),
        ],
      ),
      body:  _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ):Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: selectedImage != null
                  ? Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: Image.file(selectedImage, fit: BoxFit.cover,),
              )
                  : Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                height: 170,
                width: MediaQuery.of(context).size.width,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.black45,
                  size: 50,
                ),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Author Name",
                    ),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Description",
                    ),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
