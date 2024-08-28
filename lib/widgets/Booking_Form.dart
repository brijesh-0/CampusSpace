import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:campus_space/models/bookingsmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class BookingForm extends StatefulWidget {
  final String userName;
  final String clubEmail;
  final String venuename;
  final String capacity;
  final List<Booking> bookings;
  final Map faculty;

  const BookingForm(
      {required this.venuename,
      required this.capacity,
      required this.userName,
      required this.clubEmail,
      required this.bookings,
      required this.faculty,
      super.key});
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImageFile;
  final List<DateTime?> _selectedDates = [null];
  final List<TimeOfDay?> _selectedStartTimes = [null];
  final List<TimeOfDay?> _selectedEndTimes = [null];
  int _numberOfDays = 1;
  String? _uploadedImageUrl;
  String? _eventName,
      _eventDescription,
      _contactPerson,
      _contactEmail,
      _contactPhone;
  int? _numAttendees;
  bool _agreedToTerms = false;
  bool _isUploadingImage = false;

  void _addDateTimeFields() {
    setState(() {
      _selectedDates.add(null);
      _selectedStartTimes.add(null);
      _selectedEndTimes.add(null);
    });
  }

  void _removeDateTimeFields(int index) {
    setState(() {
      _selectedDates.removeAt(index);
      _selectedStartTimes.removeAt(index);
      _selectedEndTimes.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDates[index] ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != _selectedDates[index]) {
      setState(() {
        _selectedDates[index] = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTimes[index] ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedStartTimes[index]) {
      setState(() {
        _selectedStartTimes[index] = picked;
      });
    }
  }

  // End time picker function
  Future<void> _selectEndTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTimes[index] ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedEndTimes[index]) {
      setState(() {
        _selectedEndTimes[index] = picked;
      });
    }
  }

  bool _checkDateTimeClash(int index) {
    if (_selectedDates[index] != null &&
        _selectedStartTimes[index] != null &&
        _selectedEndTimes[index] != null) {
      DateTime selectedDate = _selectedDates[index]!;
      TimeOfDay selectedStartTime = _selectedStartTimes[index]!;
      TimeOfDay selectedEndTime = _selectedEndTimes[index]!;

      DateTime selectedStartDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedStartTime.hour,
        selectedStartTime.minute,
      );

      DateTime selectedEndDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedEndTime.hour,
        selectedEndTime.minute,
      );

      if (selectedStartDateTime.isAfter(selectedEndDateTime)) {
        return false;
      }

      DateTimeRange selectedRange = DateTimeRange(
        start: selectedStartDateTime,
        end: selectedEndDateTime,
      );

      for (var booking in widget.bookings) {
        for (var range in booking.dateTimeRanges) {
          if (_isOverlap(range, selectedRange)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  bool _isOverlap(DateTimeRange range1, DateTimeRange range2) {
    return range1.start.isBefore(range2.end) &&
        range2.start.isBefore(range1.end);
  }

  bool _validateEndTime(int index) {
    if (_selectedStartTimes[index] != null &&
        _selectedEndTimes[index] != null) {
      final startMinutes = _selectedStartTimes[index]!.hour * 60 +
          _selectedStartTimes[index]!.minute;
      final endMinutes = _selectedEndTimes[index]!.hour * 60 +
          _selectedEndTimes[index]!.minute;
      return endMinutes >= startMinutes;
    }
    return true;
  }

  /*Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }*/

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImageFile = pickedImage;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImageFile == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      String fileName =
          _eventName! + DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('Event_posters/').child(fileName);
      print(ref);
      UploadTask uploadTask = ref.putFile(File(_selectedImageFile!.path));
      print(uploadTask);
      TaskSnapshot taskSnapshot = await uploadTask!.whenComplete(() {});

      _uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      print("called");
      _formKey.currentState!.save();

      await _uploadImage();

      List<Map<String, dynamic>> dateTimeList = [];

      for (int i = 0; i < _numberOfDays; i++) {
        DateTime date = DateTime(
          _selectedDates[i]!.year,
          _selectedDates[i]!.month,
          _selectedDates[i]!.day,
        );

        dateTimeList.add({
          "date": DateFormat('yyyy-MM-dd').format(date),
          "start-time": DateFormat('h:mm a')
              .format(DateTime(date.year, date.month, date.day,
                  _selectedStartTimes[i]!.hour, _selectedStartTimes[i]!.minute))
              .toString(),
          "end-time": DateFormat('h:mm a')
              .format(DateTime(date.year, date.month, date.day,
                  _selectedEndTimes[i]!.hour, _selectedEndTimes[i]!.minute))
              .toString(),
        });
        //String formattedStartTime = _selectedStartTime!.format(context);
        //String formattedEndTime = _selectedEndTime!.format(context);
      }

      // Push booking information to Firestore
      await _firestore.collection('bookings').add({
        'id': uuid.v4(),
        'clubName': widget.userName,
        'clubEmail': widget.clubEmail,
        'eventName': _eventName,
        'eventDescription': _eventDescription,
        'venuename': widget.venuename,
        'contactPerson': _contactPerson,
        'contactEmail': _contactEmail,
        'contactPhone': _contactPhone,
        'dateTimeList': dateTimeList,
        'attendee_no': _numAttendees,
        'faculty': widget.faculty,
        'isConfirmed': false,
        'status': "Status Pending",
        'poster_url':
            _uploadedImageUrl, // Store date and time as a string or timestamp
      });

      // Optionally, navigate back to previous screen or show a success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking submitted successfully!'),
        ),
      );
    } else {
      if (!_agreedToTerms) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Error'),
                content: const Text(
                    'You must agree to the terms and conditions to submit the form.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
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
    return Stack(children: [
      Container(
        color: const Color.fromARGB(255, 248, 251, 255),
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
                  decoration: const InputDecoration(labelText: 'Club Name'),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  readOnly: true,
                  initialValue: widget.venuename,
                  decoration: const InputDecoration(labelText: 'Venue Name'),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Event Name'),
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
                  decoration:
                      const InputDecoration(labelText: 'Event Description'),
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
                  decoration:
                      const InputDecoration(labelText: 'Contact Person Name'),
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
                  decoration: const InputDecoration(labelText: 'Contact Email'),
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
                  decoration:
                      const InputDecoration(labelText: 'Contact Phone Number'),
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
                  height: 5.0,
                  width: 0.0,
                ),
                // Event Date Picker
                /*ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(_selectedDate == null
                      ? 'Select Date'
                      : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                  onTap: () => _selectDate(context),
                ),*/
                //ListTile(
                //leading: const Icon(Icons.calendar_today),
                //title:
                Row(
                  children: [
                    Icon(Icons.calendar_today),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const Text('Number of Days for Reservation:'),
                      ),
                    ),
                    // const Text('Number of Days for Reservation:'),
                    //const SizedBox(width: 35),
                    //const SizedBox(width: 5),
                    Container(
                      alignment: Alignment.centerRight,
                      child: DropdownButton<int>(
                        value: _numberOfDays,
                        items: List.generate(10, (index) => index + 1)
                            .map((e) => DropdownMenuItem<int>(
                                  value: e,
                                  child: Text(e.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _numberOfDays = value!;
                            while (_selectedDates.length < _numberOfDays) {
                              _addDateTimeFields();
                            }
                            while (_selectedDates.length > _numberOfDays) {
                              _removeDateTimeFields(_selectedDates.length - 1);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                //),
                for (int i = 0; i < _numberOfDays; i++)
                  Column(children: [
                    if (_numberOfDays > 1)
                      Text(
                        "Day ${i + 1}",
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.calendar_month_rounded),
                                hintText: _selectedDates[i] == null
                                    ? 'Select Date'
                                    : 'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDates[i]!)}'),
                            onTap: () => _selectDate(context, i),
                            validator: (value) {
                              if (_selectedDates[i] == null) {
                                return 'Please select the event date';
                              }
                              if (_checkDateTimeClash(i) == false) {
                                print("called");
                                return 'Date/Time clashing with already existing event!';
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
                                icon: const Icon(Icons.access_time),
                                hintText: _selectedStartTimes[i] == null
                                    ? 'Select Start Time'
                                    : 'Start Time: ${_selectedStartTimes[i]!.format(context)}'),
                            onTap: () => _selectStartTime(context, i),
                            validator: (value) {
                              if (_selectedStartTimes[i] == null) {
                                return 'Please select the event start time';
                              }
                              if (_checkDateTimeClash(i) == false) {
                                print("called");
                                return 'Date/Time clashing with existing event!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.access_time),
                                hintText: _selectedEndTimes[i] == null
                                    ? 'Select End Time'
                                    : 'End Time: ${_selectedEndTimes[i]!.format(context)}'),
                            onTap: () => _selectEndTime(context, i),
                            validator: (value) {
                              if (_selectedEndTimes[i] == null) {
                                return 'Please select the event end  time';
                              }
                              if (_validateEndTime(i) == false) {
                                print("called end time");
                                return "End time cannot be earlier than Start time";
                              }
                              if (_checkDateTimeClash(i) == false) {
                                print("called");
                                return 'Date/Time clashing with existing event!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ]),
                /*Row(
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
                ),*/

                // Number of Attendees TextFormField
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of Attendees'),
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
                        File(_selectedImageFile!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.image,
                        size: 25.0,
                      ),
                      onPressed: _pickImage,
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
      ),
      Positioned(
        top: 16.0,
        right: 16.0,
        child: IconButton(
          icon: Icon(Icons.close, size: 20.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    ]);
  }
}
