import "package:meta/meta.dart";

class CTicker {
  final String tickerName;

  CTicker({
    @required this.tickerName,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CTicker && o.tickerName == tickerName;
  }

  @override
  int get hashCode => tickerName.hashCode;
}
