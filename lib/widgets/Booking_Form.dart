import 'package:flutter/material.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  String? _clubName,
      _eventName,
      _eventDescription,
      _contactPerson,
      _contactEmail,
      _contactPhone;
  int? _numAttendees;
  bool _agreedToTerms = false;
  //calendar.EventDateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 248, 251, 255),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Club Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the club name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _clubName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventDescription = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Person Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact person name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactPerson = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactEmail = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactPhone = value;
                },
              ),
              const Row(
                children: [
                  /*Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: _selectedDateTime == null
                            ? 'Date and Time'
                            : 'Date and Time: ${_selectedDateTime!.dateTime}',
                      ),
                      onTap: _selectDateTime,
                      validator: (value) {
                        if (_selectedDateTime == null) {
                          return 'Please select the event date and time';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.event),
                      onPressed:  //_fetchAndShowEvents
                      ),*/
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Attendees'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of attendees';
                  }
                  return null;
                },
                onSaved: (value) {
                  _numAttendees = int.tryParse(value ?? '');
                },
              ),
              CheckboxListTile(
                title: Text('I agree to the Terms and Conditions'),
                activeColor: const Color(0xFF0066FF),
                value: _agreedToTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {} //_submitBooking,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
