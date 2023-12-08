import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as htmlDom;

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<String> paragraphs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final response = await Dio().get('https://www.imsafe.app/blog');
      if (response.statusCode == 200) {
        setState(() {
          paragraphs = parseParagraphs(response.data);
        });
      } else {
        print('Failed to load blog data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching blog data: $e');
    }
  }

  List<String> parseParagraphs(String htmlString) {
    final document = htmlParser.parse(htmlString);
    final elements = document.querySelectorAll('p');
    return elements.map((element) => element.text).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
      ),
      body: ListView.builder(
        itemCount: paragraphs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(paragraphs[index]),
          );
        },
      ),
    );
  }
}
