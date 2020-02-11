import 'package:hn_app/src/article.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

import 'package:http/http.dart' as http;

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;
  final _storiesTypeController = StreamController<StoriesType>();

  var _articles = <Article>[];

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topIds);

    _storiesTypeController.stream.listen((storiesType) {
      if (storiesType == StoriesType.newStories)
        _getArticlesAndUpdate(_newIds);
      else
        _getArticlesAndUpdate(_topIds);
    });
  }

  static List<int> _newIds = [22255914, 22272966, 22263721, 22284232];

  static List<int> _topIds = [
    22276184,
    22256872,
    22266173,
    22280753,
    22261612,
  ];

  Future<Article> _getArticle(int id) async {
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) return parseArticle(storyRes.body);
  }

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }

  void _getArticlesAndUpdate(List<int> ids) {
    _updateArticles(ids)
        .then((_) => {_articlesSubject.add(UnmodifiableListView(_articles))});
  }
}
