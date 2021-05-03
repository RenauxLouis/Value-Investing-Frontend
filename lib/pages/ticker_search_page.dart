import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_cubit_bloc_tutorial/cubit/ticker_cubit.dart";

class TickerSearchPage extends StatefulWidget {
  final List<dynamic> futureSECTickers;

  const TickerSearchPage({Key key, this.futureSECTickers}) : super(key: key);

  @override
  _TickerSearchPageState createState() => _TickerSearchPageState();
}

class _TickerSearchPageState extends State<TickerSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DILIGENCE",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child:
            BlocConsumer<TickerCubit, TickerState>(listener: (context, state) {
          if (state is TickerError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        }, builder: (context, state) {
          if (state is TickerInitial) {
            return buildInitialInput(widget.futureSECTickers);
          } else if (state is TickerLoading) {
            return buildLoading();
          } else if (state is TickerLoaded) {
            return buildColumnWithData(state.s3Urls, widget.futureSECTickers);
          } else {
            // (state is TickerError)
            return buildInitialInput(widget.futureSECTickers);
          }
        }),
      ),
    );
  }

  Widget buildInitialInput(futureSECTickers) {
    return Center(
      child: MyTickerInput(futureSECTickers: futureSECTickers),
    );
  }

  Widget buildLoading() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CircularProgressIndicator(),
      Text("Combining SEC files", style: TextStyle(fontSize: 20))
    ]);
  }

  Column buildColumnWithData(String s3Urls, List<dynamic> futureSECTickers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          s3Urls,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        MyTickerInput(futureSECTickers: futureSECTickers),
      ],
    );
  }
}

class MyTickerInput extends StatefulWidget {
  final List<dynamic> futureSECTickers;

  const MyTickerInput({Key key, this.futureSECTickers}) : super(key: key);

  @override
  TickerInputField createState() => new TickerInputField();
}

class TickerInputField extends State<MyTickerInput> {
  bool _inputError = false;
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (enteredTicker) {
          String cleanedEnteredTicker =
              enteredTicker.replaceAll(new RegExp(r"\s+"), "");
          bool isNotSECTicker = !widget.futureSECTickers
              .contains(cleanedEnteredTicker.toLowerCase());
          // bool filed10k = assertFiled10k(enteredTicker);

          setState(() {
            if (cleanedEnteredTicker == "") {
              _inputError = true;
              _errorMessage = "Please select a ticker";
            } else if (isNotSECTicker) {
              _inputError = true;
              _errorMessage = "Please select a ticker that files to the SEC";
              // } else if (filed10k) {
              //   _inputError = true;
              //   _errorMessage =
              //       "This ticker does not report 10K Forms to the SEC";
            } else {
              _inputError = false;
            }
          });
          if (!_inputError) {
            return submitTickerName(context, cleanedEnteredTicker);
          }
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a ticker (TSLA, AMZN...) and press ENTER",
          errorText: _inputError ? _errorMessage : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  submitTickerName(BuildContext context, String tickerName) {
    final tickerCubit = BlocProvider.of<TickerCubit>(context);
    tickerCubit.getTicker(tickerName);
  }
}
