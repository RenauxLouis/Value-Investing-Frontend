import "package:http/http.dart" as http;
import "dart:convert";
import "dart:html";

abstract class TickerRepository {
  Future<File> fetchTicker(String tickerName);
}

class FakeTickerRepository implements TickerRepository {
  @override
  Future<File> fetchTicker(String tickerName) async {
    String upperCaseTickerName = tickerName.toUpperCase();
    http.Response response = await http.Client()
        .get(Uri.https("tickerdownload.com", "/params_web/", {
      "years": "2015-2020",
      "Income": "true",
      "Proxy": "true",
      "Balance": "true",
      "Cash": "true",
      "_10k": "true",
      "ticker": upperCaseTickerName
    }));

    final content = base64Encode(response.bodyBytes);
    final _ = AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", "$tickerName.zip")
      ..click();
  }
}

class NetworkException implements Exception {}
