import 'package:hn_app/src/article.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

import 'package:http/http.dart' as http;

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  var _articles = <Article>[];

  HackerNewsBloc() {
    _updateArticles()
        .then((_) => {_articlesSubject.add(UnmodifiableListView(_articles))});
  }

  List<int> _ids = [
    22276184,
    22256872,
    22266173,
    22280753,
    22261612,
    22255914,
    22272966,
    22263721,
    22284232
  ];

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) return parseArticle(storyRes.body);
  }

  Future<Null> _updateArticles() async {
    final futureArticles = _ids.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
