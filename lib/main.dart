import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hn_app/src/hh_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hn_app/src/article.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        primarySwatch: Colors.orange,
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
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: LoadingInfo(
          widget.hnBloc.isLoading,
        ),
      ),
      body: StreamBuilder<UnmodifiableListView<Article>>(
        stream: widget.hnBloc.articles,
        initialData: UnmodifiableListView<Article>([]),
        builder: (context, snapshot) => ListView(
            children: snapshot.data.map((f) => _buildItem(f)).toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
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
          setState(() {
            _currentNavIndex = index;
          });
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

class LoadingInfo extends StatefulWidget {
  Stream<bool> _isLoading;
  LoadingInfo(this._isLoading);

  @override
  createState() => LoadingInfoState();
}

class LoadingInfoState extends State<LoadingInfo>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: widget._isLoading,
        initialData: false,
        builder: (context, snapshot) {
          //if (snapshot.hasData && snapshot.data) {
          _controller.forward().then((value) => _controller.reverse());
          return Padding(
              padding: const EdgeInsets.all(14),
              child: FadeTransition(
                  opacity: Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(
                      curve: Curves.easeIn, parent: _controller)),
                  child: FaIcon(FontAwesomeIcons.hackerNewsSquare)));
          //} else {
          //_controller.reverse();
          //return Container();
        }
        //},
        );
  }
}
