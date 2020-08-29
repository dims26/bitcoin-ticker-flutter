import 'package:bitcoin_ticker/utils.dart';
import 'package:flutter/material.dart';

class TickerCard extends StatelessWidget {
  TickerCard(this.text,
      {@required this.color,
      this.cornerRadius = 10.0,
      this.padding = 18.0,
      this.textStyle = kCardTextStyle,
      this.textPaddingVertical = 15.0,
      this.textPaddingHorizontal = 28.0});
  final String text;
  final Color color;
  final double cornerRadius;
  final double padding;
  final TextStyle textStyle;
  final double textPaddingVertical;
  final double textPaddingHorizontal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Card(
        color: color,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: textPaddingVertical, horizontal: textPaddingHorizontal),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
