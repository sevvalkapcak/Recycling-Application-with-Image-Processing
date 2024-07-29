import 'package:flutter/material.dart';
import 'package:boot1_project/data/news_service.dart';
import 'package:boot1_project/models/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:boot1_project/home_page.dart';

void main() {
  runApp(Haber());
}

class Haber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          errorColor: Colors.red, // errorColor burada tanımlandı
        ),
      ),
      home: MyHomePage(title: 'News'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Articles> articles = [];

  @override
  void initState() {
    NewsService.getNews().then((value) {
      setState(() {
        articles = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ucuncuSayfa()),
            );
          },
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [
                  Image.network(articles[index].urlToImage ??
                      'https://i0.wp.com/designermenus.com.au/wp-content/uploads/2016/02/icon-None.png?w=300&ssl=1'),
                  ListTile(
                    leading: Icon(Icons.arrow_drop_down_circle),
                    title: Text(articles[index].title ?? ''),
                    subtitle: Text(articles[index].author ?? ''),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(articles[index].description ?? ''),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await launch(articles[index].url ?? '');
                        },
                        child: Text('Read More'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
