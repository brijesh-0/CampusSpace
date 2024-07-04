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
        child: Row(
          children: [
            Card(
              clipBehavior: Clip.hardEdge, // Clip content at card edges
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.network(
                'https://www.collegebatch.com/static/clg-gallery/bms-college-of-engineering-bangalore-218122.jpg',
                height: 156,
                width: 114.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Auditorium 1',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Row(children: [
                      Text("Event: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('My Event'),
                    ]),
                    const Row(children: [
                      Text("Date: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('3:30pm, 5 June 2024')
                    ]),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(children: [
                      ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromARGB(
                                255, 0, 0, 0), // Shadow color
                            elevation: 10,
                            fixedSize: const Size.fromWidth(100.0),
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            "Reject",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          )),
                      ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromARGB(
                                255, 0, 0, 0), // Shadow color
                            elevation: 10,
                            fixedSize: const Size.fromWidth(100.0),
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          )),
                    ]),
                    const Text(
                      'Status Pending',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF0066FF)),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
