import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_cubit_bloc_tutorial/pages/ticker_search_page.dart";
import "package:http/http.dart" as http;

import "cubit/ticker_cubit.dart";
import "data/ticker_repository.dart";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<dynamic>> futureSECTickers;

  @override
  void initState() {
    super.initState();
    futureSECTickers = getListSECTickers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Material App",
        theme: ThemeData(
            primarySwatch: Colors.orange,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: BlocProvider(
          create: (context) => TickerCubit(FakeTickerRepository()),
          child: FutureBuilder<List<dynamic>>(
              future: futureSECTickers,
              builder: (context, snapshot) {
                print(snapshot.hasData);
                if (snapshot.hasData) {
                  return TickerSearchPage(futureSECTickers: snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                    child: Container(
                        child: CircularProgressIndicator(),
                        width: 48.0,
                        height: 48.0));
              }),
        ));
  }
}

Future<List<dynamic>> getListSECTickers() async {
  print("Get list SEC Tickers");
  http.Response response =
      await http.Client().get(Uri.https("tickerdownload.com", "/list_sec/"));
  Map<String, dynamic> parsedBody = jsonDecode(response.body);
  List<dynamic> listSECTickers = parsedBody["tickers"];

  return listSECTickers;
}
