import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blog_app_ayham/services/crud.dart';
import 'package:flutter_blog_app_ayham/views/create_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  Stream blogsStream;

  Widget BlogsList() {
    return Container(
      child: blogsStream !=null ?
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
            stream: FirebaseFirestore.instance.collection("blogs").snapshots(),
            builder: (context , snapshot) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlogsTile(
                      authorName: snapshot.data.docs[index].data()['authorName'],
                      title: snapshot.data.docs[index].data()['title'],
                      description: snapshot.data.docs[index].data()['desc'],
                      imgUrl: snapshot.data.docs[index].data()['imgUrl'],

                    );
                  });
            } , )
          ]
        ) ,
    ) :Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
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
      ),
      body: BlogsList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateBlog()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;

  BlogsTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.description,
      @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl : imgUrl,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.black54.withOpacity(0.3),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title,style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500

                ),),
                SizedBox(height: 4,),
                Text(description,style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400

                )),
                SizedBox(height: 4,),
                Text(authorName,
                    textAlign: TextAlign.center
                    ,style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500

                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
