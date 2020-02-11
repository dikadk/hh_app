import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hn_app/src/hh_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hn_app/src/article.dart';

void main() {
  final hnBloc = HackerNewsBloc();
  runApp(MyApp(
    hnBloc: hnBloc,
  ));
}

class MyApp extends StatelessWidget {
  final HackerNewsBloc hnBloc;

  const MyApp({Key key, this.hnBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Hacker News',
        hnBloc: hnBloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HackerNewsBloc hnBloc;

  MyHomePage({Key key, this.title, this.hnBloc}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.hnBloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
            children: snapshot.data.map((f) => _buildItem(f)).toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
              title: Text("Top Stories"), icon: Icon(Icons.receipt)),
          BottomNavigationBarItem(
              title: Text("New Stories"), icon: Icon(Icons.fiber_new)),
        ],
        onTap: (index) {
          if (index == 0)
            widget.hnBloc.storiesType.add(StoriesType.topStories);
          else
            widget.hnBloc.storiesType.add(StoriesType.newStories);
        },
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.title,
          style: TextStyle(fontSize: 24),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("${article.type}"),
              IconButton(
                  onPressed: () async {
                    if (await canLaunch(article.url)) {
                      launch(Uri.encodeFull(article.url));
                    }
                  },
                  icon: Icon(Icons.launch))
            ],
          ),
        ],
      ),
    );
  }
}
