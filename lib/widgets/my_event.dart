import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEvent extends StatefulWidget {
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
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _initial();
  }

  Future<void> _initial() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool('isAdmin') ?? false
        ? setState(() => isAdmin = true)
        : setState(() => isAdmin = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Card(
              clipBehavior: Clip.hardEdge, // Clip content at card edges
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.network(
                widget.posterUrl,
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
                    widget.venue,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    const Text("Event: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.eventName),
                  ]),
                  Row(children: [
                    const Text("Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.date)
                  ]),
                  Row(children: [
                    const Text("time: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.time)
                  ]),
                  const SizedBox(
                    height: 13.0,
                  ),
                  isAdmin && (widget.status.toLowerCase() != 'accepted')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: const Size.fromWidth(100.0),
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                            ])
                      : (widget.status.toLowerCase() != 'accepted')
                          ? const Text(
                              'Status Pending ',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF0066FF)),
                            )
                          : const SizedBox(width: 0, height: 0),
                  //Text(isAdmin.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
