import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:campus_space/pages/venue_page.dart';

class VenueCard extends StatelessWidget {
  final String name;
  final String displayName;
  final String capacity;
  final List<String> imageUrl;
  final String details;
  final String location;

  const VenueCard({
    required this.displayName,
    required this.name,
    required this.capacity,
    required this.imageUrl,
    required this.details,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VenueDetailsPage(
                displayName: displayName,
                venuename: name,
                capacity: capacity,
                images: imageUrl,
                details: details,
                location: location,
              ),
            ));
          },
          child: SizedBox(
              width: double.infinity,
              child: Column(children: <Widget>[
                CachedNetworkImage(
                  imageUrl: imageUrl[0],
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    height: 190,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                // Image.network(
                //   imageUrl[0],
                //   width: double.infinity,
                //   height: 190,
                //   fit: BoxFit.cover,
                // ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            location,
                            style: const TextStyle(
                                color: Color(0xFF9E9E9E), height: 0.0),
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VenueDetailsPage(
                                        displayName: displayName,
                                        venuename: name,
                                        capacity: capacity,
                                        images: imageUrl,
                                        details: details,
                                        location: location)))
                              },
                          style: ElevatedButton.styleFrom(
                            shadowColor:
                                const Color.fromARGB(255, 0, 0, 0), // Shadow color
                            elevation: 10,
                            fixedSize: const Size.fromWidth(100.0),
                            backgroundColor: const Color(0xFF0066FF),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text("Book",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400))),
                    ],
                  ),
                )
              ])),
        ));
    /*return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: double.infinity,
        height: 190,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VenueDetailsPage(
                    displayName: displayName,
                    venuename: name,
                    capacity: capacity,
                    images: imageUrl,
                    details: details)));
          },
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Image.network(
                  imageUrl[0],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10.0,
                  left: 30.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 2.0,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_alt_rounded,
                            color: Colors.white,
                            size: 18.0,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 2.0,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                          Text(
                            ' Capacity: $capacity',
                            style: const TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}
