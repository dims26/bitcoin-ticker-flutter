import 'package:bitcoin_ticker/ticker_card.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:bitcoin_ticker/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownSelectedValue = 'USD';

  String btcTickerText = '1 BTC = ? USD';
  String ethTickerText = '1 ETH = ? USD';
  String ltcTickerText = '1 LTC = ? USD';

  DropdownButton<String> materialDropdown(List<String> stringList) {
    List<DropdownMenuItem<String>> itemList = stringList.map((element) {
      return DropdownMenuItem(
        child: Text(element),
        value: element,
      );
    }).toList();

    return DropdownButton<String>(
      dropdownColor: Colors.deepOrangeAccent,
      value: dropDownSelectedValue,
      items: itemList,
      onChanged: (value) {
        print(value);
        setState(() {
          dropDownSelectedValue = value;
          retrieveRates(value);
        });
      },
    );
  }

  CupertinoTheme iOSPicker(List<String> stringList) {
    List<Text> itemList = stringList.map((e) => Text(e)).toList();

    return CupertinoTheme(
      data: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
        pickerTextStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      )),
      child: CupertinoPicker(
        itemExtent: 28.0,
        onSelectedItemChanged: (index) {
          print(stringList[index]);
          setState(() {
            dropDownSelectedValue = stringList[index];
            retrieveRates(stringList[index]);
          });
        },
        children: itemList,
      ),
    );
  }

  void retrieveRates(String value) async {
    NetworkHelper networkHelper = NetworkHelper(baseUrl);
    String btcUrl = networkHelper.urlBuilder(
        levels: [cryptoList[0], value],
        params: <String, dynamic>{apiParam: apiKey});
    String ethUrl = networkHelper.urlBuilder(
        levels: [cryptoList[1], value],
        params: <String, dynamic>{apiParam: apiKey});
    String ltcUrl = networkHelper.urlBuilder(
        levels: [cryptoList[2], value],
        params: <String, dynamic>{apiParam: apiKey});

    List result = [
      await networkHelper.getConversion(url: btcUrl),
      await networkHelper.getConversion(url: ethUrl),
      await networkHelper.getConversion(url: ltcUrl)
    ];

    extractInfo(result);
  }

  void extractInfo(List<dynamic> result) {
    for (int i = 0; i < result.length; i++) {
      if (result[i] is int)
        updateFailed(i);
      else
        updateTicker(i, result[i]['rate']);
    }
  }

  void updateTicker(int index, double element) {
    setState(() {
      switch (index) {
        case 0:
          btcTickerText =
              "1 BTC = ${element.toStringAsFixed(3)} $dropDownSelectedValue";
          break;
        case 1:
          ethTickerText =
              "1 ETH = ${element.toStringAsFixed(3)} $dropDownSelectedValue";
          break;
        case 2:
          ltcTickerText =
              "1 LTC = ${element.toStringAsFixed(3)} $dropDownSelectedValue";
          break;
      }
    });
  }

  void updateFailed(int index) {
    setState(() {
      switch (index) {
        case 0:
          btcTickerText = "--";
          break;
        case 1:
          ethTickerText = "--";
          break;
        case 2:
          ltcTickerText = "--";
          break;
      }
    });
  }

  @override
  void initState() {
    retrieveRates(dropDownSelectedValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/crypto-background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TickerCard(btcTickerText, color: Colors.deepOrangeAccent),
                  TickerCard(ethTickerText, color: Colors.deepOrangeAccent),
                  TickerCard(ltcTickerText, color: Colors.deepOrangeAccent),
                ],
              ),
              Container(
                height: Platform.isIOS ? 96.0 : 56.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                color: Colors.deepOrange,
                child: Platform.isIOS
                    ? iOSPicker(currenciesList)
                    : materialDropdown(currenciesList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
