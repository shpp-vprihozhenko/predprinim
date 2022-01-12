    import 'dart:convert';
    import 'package:http/http.dart' as http;
    import 'package:flutter/material.dart';

    class Test2 extends StatefulWidget {
      const Test2({Key? key}) : super(key: key);

      @override
      _Test2State createState() => _Test2State();
    }

    class Article {
      String header='';
    }

    class _Test2State extends State<Test2> {
      Future <List<Article>>? futureWords;

      @override
      void initState() {
        super.initState();
        _getNews();
      }

      _getNews() async {
        var response = await http.get(Uri.parse(
            "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=aa20aef042a14de5b99a7f7d32952504"));
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          List<dynamic> body = json['articles'];
          //List<Article> articles = body.map((e) => Article.fromJson(e)).toList();
          List<Article> articles = [];
          for (var el in body) {
            Article article = Article();
            article.header = el['title'];
            articles.add(article);
          }
          articles.shuffle();
          setState(() {
            futureWords = Future.value(articles);
          });
        } else {
          throw ("cant get the articles. statusCode ${response.statusCode}");
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: FutureBuilder<List<Article>>(
              future: futureWords,
              builder: (context, AsyncSnapshot<List<Article>> snap) {
                if (snap.hasData) {
                  List<Article> articles = snap.data!;
                  return
                    RefreshIndicator(
                      onRefresh: () {
                        _getNews();
                        return futureWords!;
                      },
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ListTile(title: Text(articles[index].header));
                        }),
                    );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        );
      }
    }