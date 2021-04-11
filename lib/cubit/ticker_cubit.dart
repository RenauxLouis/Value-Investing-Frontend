import "package:bloc/bloc.dart";
import "package:meta/meta.dart";
import "../data/ticker_repository.dart";
part "ticker_state.dart";

class TickerCubit extends Cubit<TickerState> {
  final TickerRepository _tickerRepository;

  TickerCubit(this._tickerRepository) : super(TickerInitial());

  Future<void> getTicker(String tickerName) async {
    try {
      emit(TickerLoading());
      await _tickerRepository.fetchTicker(tickerName);
      print("DONE");
      emit((TickerLoaded("DONE")));
    } on Exception {
      emit(TickerError(
          "Error combining the SEC files. A notification has been sent to the developpers to fix the issue"));
    }
  }
}
