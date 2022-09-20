import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_available_sharp, size: 25),
            const SizedBox(width: 4),
            Text(
              '+',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        onPressed: onClicked,
      );
}
