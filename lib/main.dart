import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scrl/photo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Scroll',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Photo> photos = [];
  bool loading = false;
  int albumId = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPhotos(albumId);

    _scrollController.addListener(() {
      print(_scrollController.position.maxScrollExtent);
      print(_scrollController.position.pixels);

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        albumId++;
        getPhotos(albumId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getPhotos(int albumId) async {
    if (albumId > 50) {
      return;
    }

    final String url =
        'https://jsonplaceholder.typicode.com/photos?albumId=$albumId';

    try {
      if (albumId == 1) {
        setState(() => loading = true);
      }
      http.Response response = await http.get(url);
      if (albumId == 1) {
        setState(() => loading = false);
      }

      final items = json.decode(response.body);
      items.forEach((item) {
        photos.add(Photo.fromJson(item));
      });
      setState(() {});
    } catch (err) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            title: Text('Failure'),
            content: Text('Fail to get album data'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Scroll'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: photos.length + 1,
              itemBuilder: (ctx, i) {
                if (i == photos.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.network(
                          photos[i].url,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Text(photos[i].title)
                      ],
                    ),
                    Text(
                      '${i + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 60),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
