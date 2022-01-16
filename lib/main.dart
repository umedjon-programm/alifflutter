import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_alif/dbguides.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Alif TEST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var postJSon = [];
  DBGuides db_guides = DBGuides();
  bool lc = true;
  String? url, startDate, endDate, name, icon;
  int a = 3;
  void fetchPost() async {
    try {
      var response = await http
          .get(Uri.parse('https://guidebook.com/service/v2/upcomingGuides'));
      var jsonData = json.decode(response.body)["data"] as List;

      setState(() {
        postJSon = jsonData;
      });
    } catch (err) {}
  }

  Widget view() {
    if (lc) {
      return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: postJSon.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (context, i) {
            final post = postJSon[i];
            db_guides.insetdata(post["url"], post["startDate"], post["endDate"],
                post["name"], post["icon"]);

            return ListTile(
              title: Text("${post["name"]}", style: TextStyle(fontSize: 24)),
              subtitle:
                  Text("${post["endDate"]}", style: TextStyle(fontSize: 12)),
              leading: Image.network(post["icon"]),
              onTap: () {
                url = post["url"];
                startDate = post["startDate"];
                endDate = post["endDate"];
                name = post["name"];
                icon = post["icon"];
                setState(() {
                  lc = false;
                });
              },
            );
          });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(icon!),
        Text("URL: $url"),
        Text("Start Date: $startDate"),
        Text("End Date: $endDate"),
        Text("Name: $name"),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [],
      appBar: AppBar(
        title: Text(widget.title),
        leading: lc? null: BackButton(onPressed: () {
          setState(() {
            lc = true;
          });
        }),
      ),
      body: Center(child: view()),
    );
  }
}
