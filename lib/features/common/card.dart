import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Card extends StatefulWidget {
  final Widget? child;

  const Card(this.child);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> {
  late Widget? child;

  @override
  void initState() {
    child = widget.child;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: provider.isDarkMode ? Colors.black : Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blueAccent,
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: child,
    );
  }
}
