import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyEvent extends StatelessWidget {
  final String eventName;
  final String venue;
  final String status;
  final String time;
  final String date;
  final String posterUrl;

  const MyEvent({
    super.key,
    required this.eventName,
    required this.venue,
    required this.status,
    required this.time,
    required this.date,
    required this.posterUrl,
  });

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
                posterUrl,
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
                  Text(
                    venue,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    Text("Event: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(eventName),
                  ]),
                  Row(children: [
                    Text("Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(date)
                  ]),
                  Row(children: [
                    Text("time: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(time)
                  ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
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
                        const SizedBox(width: 5),
                        ElevatedButton(
                            onPressed: () => {},
                            style: ElevatedButton.styleFrom(
                              elevation: 00,
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
                        fontStyle: FontStyle.italic, color: Color(0xFF0066FF)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
