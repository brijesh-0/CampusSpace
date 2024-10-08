import 'package:flutter/material.dart';

class VenueHistoryScreen extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchPastBookings;

  const VenueHistoryScreen({super.key, required this.fetchPastBookings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Venue ',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: 'History',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066FF),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchPastBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No past bookings found'));
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final dateTime = booking['dateTimeList'][0]; // Adjust as needed
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      _showPosterDialog(
                          context,
                          booking['poster_url'] ??
                              "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg");
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(booking['poster_url'] ??
                              "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(booking['eventName']),
                  subtitle: Text('Venue: ${booking['venuename']}\n'
                      'End Time: ${dateTime['date']} - ${dateTime['end-time']}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showPosterDialog(BuildContext context, String posterUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: Image.network(posterUrl),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
