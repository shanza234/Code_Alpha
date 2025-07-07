import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Widgets/quote_card.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map quote = {'isLoading': true};

  @override
  void initState() {
    getQuote();
    super.initState();
  }

  void getQuote() async {
    setState(() {
      quote['isLoading'] = true;
    });

    try {
      Response response = await get('https://api.quotable.io/random');
      Map body = jsonDecode(response.body);
      if (body['content'].length > 240) {
        getQuote();
      }
      setState(() {
        quote = body;
        quote['isLoading'] = false;
      });
    } catch (e) {
      print("Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Quote Generator')),
      backgroundColor: Colors.amberAccent,
      body: SafeArea(
          child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.45,
            child: QuoteCard(
                author: quote['author'],
                content: quote['content'],
                isLoading: quote['isLoading'])),
      )),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.refresh), onPressed: getQuote),
    );
  }
}
