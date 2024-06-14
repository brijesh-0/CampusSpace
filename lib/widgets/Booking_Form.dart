import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class BookingForm extends StatefulWidget {
  final String userName;
  final String venuename;
  final String capacity;

  const BookingForm(
      {required this.venuename,
      required this.capacity,
      required this.userName,
      super.key});
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _selectedImageFile;
  DateTime? _selectedDate;
  TimeOfDay? _selectedEndTime;
  TimeOfDay? _selectedStartTime;
  String? _uploadedImageUrl;
  String? _eventName,
      _eventDescription,
      _contactPerson,
      _contactEmail,
      _contactPhone;
  int? _numAttendees;
  bool _agreedToTerms = false;
  bool _isUploadingImage = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  // End time picker function
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImageFile == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    /*try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('event_posters').child(fileName);
      UploadTask uploadTask = ref.putFile(_selectedImageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      _uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }*/
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      _formKey.currentState!.save();
      await _uploadImage();

      // Combine selected date and time into a DateTime object
      DateTime date = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      // Format date time if needed
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String formattedStartTime = _selectedStartTime!.format(context);
      String formattedEndTime = _selectedEndTime!.format(context);

      // Push booking information to Firestore
      await _firestore.collection('bookings').add({
        'clubName': widget.userName,
        'eventName': _eventName,
        'eventDescription': _eventDescription,
        'venuename': widget.venuename,
        'contactPerson': _contactPerson,
        'contactEmail': _contactEmail,
        'contactPhone': _contactPhone,
        'date': formattedDate,
        'start_time': formattedStartTime,
        'end_time': formattedEndTime,
        'attendee_no': _numAttendees,
        'poster_url':
            _uploadedImageUrl, // Store date and time as a string or timestamp
      });

      // Optionally, navigate back to previous screen or show a success message
      Navigator.pop(context);
    } else {
      if (!_agreedToTerms) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Error'),
                content: Text(
                    'You must agree to the terms and conditions to submit the form.'),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color(0xFF0066FF)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 248, 251, 255),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Club Name TextFormField (example)
              TextFormField(
                readOnly: true,
                initialValue: widget.userName,
                decoration: InputDecoration(hintText: 'Club Name'),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                readOnly: true,
                initialValue: widget.venuename,
                decoration: const InputDecoration(hintText: 'Venue Name'),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Event Name'),
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
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Event Description'),
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

              const SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Contact Person Name'),
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
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Contact Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact email';
                  }
                  if (!value.endsWith('@bmsce.ac.in')) {
                    return 'Enter valid college mail ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactEmail = value;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Contact Phone Number'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact phone number';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be exactly 10 digits';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactPhone = value;
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              // Event Date Picker
              /*ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                onTap: () => _selectDate(context),
              ),*/
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          hintText: _selectedDate == null
                              ? 'Select Date'
                              : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (_selectedDate == null) {
                          return 'Please select the event date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Start and End Time Pickers
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.access_time),
                          hintText: _selectedStartTime == null
                              ? 'Select Start Time'
                              : 'Start Time: ${_selectedStartTime!.format(context)}'),
                      onTap: () => _selectStartTime(context),
                      validator: (value) {
                        if (_selectedStartTime == null) {
                          return 'Please select the event start time';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.access_time),
                          hintText: _selectedEndTime == null
                              ? 'Select End Time'
                              : 'End Time: ${_selectedEndTime!.format(context)}'),
                      onTap: () => _selectEndTime(context),
                      validator: (value) {
                        if (_selectedEndTime == null) {
                          return 'Please select the event end  time';
                        }
                        if (_selectedStartTime != null &&
                            _selectedEndTime != null) {
                          final startMinutes = _selectedStartTime!.hour * 60 +
                              _selectedStartTime!.minute;
                          final endMinutes = _selectedEndTime!.hour * 60 +
                              _selectedEndTime!.minute;
                          if (endMinutes < startMinutes) {
                            return 'End time cannot be earlier than start time';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              // Number of Attendees TextFormField
              TextFormField(
                decoration: InputDecoration(hintText: 'Number of Attendees'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of attendees';
                  }
                  if (num.parse(value) > num.parse(widget.capacity)) {
                    return "Attendees beyond capacity";
                  }
                  return null;
                },
                onSaved: (value) {
                  _numAttendees = int.tryParse(value ?? '');
                },
              ),
              const SizedBox(height: 8.0),
              // Image picker and upload (example)
              Row(
                children: [
                  const Text("Event Poster:"),
                  if (_selectedImageFile != null)
                    Image.file(
                      _selectedImageFile!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.image,
                      size: 25.0,
                    ),
                    onPressed: _selectImage,
                  ),
                ],
              ),
              const SizedBox(height: 6.0),

              // Terms and Conditions Checkbox (example)
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
              const SizedBox(height: 1.0),

              // Submit Button (example)
              ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
