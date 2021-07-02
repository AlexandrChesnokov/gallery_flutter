import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:photos_from_api/model/photo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photos_from_api/api/api.dart';

import 'model/photo.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Photo>>? photos;

  @override
  void initState() {
    super.initState();
    photos = Api().fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: photos,
        builder: (BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  snapshot.data!.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => photoMax(index)));
                    },
                    child: Container(
                      child: Stack(fit: StackFit.expand, children: [
                        CachedNetworkImage(
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          imageUrl: snapshot.data!.elementAt(index).urlSmall,
                          placeholder: (context, url) =>
                              LinearProgressIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            snapshot.data!.elementAt(index).name != ''
                                ? Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.black,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        snapshot.data!.elementAt(index).name,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  )
                                : Text(''), //TODO
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.black,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  snapshot.data!.elementAt(index).author,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                ));
          }
          return Center(
            child: SpinKitDualRing(
              size: 100,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }

  Widget photoMax(index) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: FutureBuilder(
              future: photos,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl: snapshot.data!.elementAt(index).urlMax,
                      placeholder: (context, url) => LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                } else
                  return Center(
                    child: SpinKitDualRing(
                      size: 100,
                      color: Colors.black,
                    ),
                  );
              },
            ),
          ),
        ),
      ),
    );
  }
}
