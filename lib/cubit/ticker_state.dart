part of "ticker_cubit.dart";

@immutable
abstract class TickerState {
  const TickerState();
}

class TickerInitial extends TickerState {
  const TickerInitial();
}

class TickerLoading extends TickerState {
  const TickerLoading();
}

class TickerLoaded extends TickerState {
  final String s3Urls;
  const TickerLoaded(this.s3Urls);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TickerLoaded && o.s3Urls == s3Urls;
  }

  @override
  int get hashCode => s3Urls.hashCode;
}

class TickerError extends TickerState {
  final String message;
  const TickerError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TickerError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
