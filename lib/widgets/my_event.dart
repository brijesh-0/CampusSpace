import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyEvent extends StatelessWidget {
  const MyEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: double.infinity,
        child: const Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'My Event 1',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('3:30pm, 5 June 2024'),
                Text('Auditorium 1'),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Status Pending',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                      color: Color(0xFF0066FF)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
