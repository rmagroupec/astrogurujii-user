
 import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomRichText.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

 import 'KundaliDetails.dart';

class KundaliFormScreenN extends StatefulWidget {
  final String id;
  final String price;
  KundaliFormScreenN({required this.id, required this.price});
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<KundaliFormScreenN> {
  HttpServices _httpService = HttpServices();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _placeOfBirth = TextEditingController();
  var day;
  var month;
  var year;
  var hh;
  var mm;
  bool? isLoading;
  String userId1 = "";

  bool m_dateStatus = false;
  bool m_tiemStatus = false;
  bool m_placeStatus = false;
  var latitude;
  var longitude;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validate() {
    if (_dob.text.length == 0) {
      setState(() {
        m_dateStatus = true;
      });
    } else {
      setState(() {
        m_dateStatus = false;
      });
    }

    if (_time.text.length == 0) {
      setState(() {
        m_tiemStatus = true;
      });
    } else {
      setState(() {
        m_tiemStatus = false;
      });
    }
    print('jhhhhhhhhhhhh');
    if (_formKey.currentState!.validate()) {
      _createUser();
    }
  }

  _createUser() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.kundaliNew(
      name: _firstNameController.text,
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hh.toString(),
      min: mm.toString(),
      lat: latitude,
      lon: longitude,
      tzone: "5.5",
      planetColor: "black",
      signColor: "black",
      lineColor: "black",
      chartType: "black",
    );
    if (res!.success == true) {
      Fluttertoast.showToast(msg: res.message.toString());
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => KundaliDetailsN(
              year: year.toString(),
              month: month.toString(),
              day: day.toString(),
              hour: hh.toString(),
              min: mm.toString(),
              lat: latitude,
              lon: longitude,
              res: res,
              name: _firstNameController.text,
              place: _placeOfBirth.text,
              id: "res.id.toString()",
            )),
      );

    } else {
      print("SigUp fAILED");
    }
    setState(() {
      isLoading = false;
    });
  }

  final dateFormat = DateFormat("dd-MM-yyyy");
  final timeFormat = DateFormat("HH:mm");
  DateTime currentVale = DateTime.now();

  var _currentSelectedValue;
  var _genderSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: whiteColor, //change your color here
        ),
        backgroundColor: primaryColor,
        title: Text(
          "Kundli Form",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Name',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Name Required"),
                              MaxLengthValidator(30,
                                  errorText: "Enter Valid First Name"),
                              MinLengthValidator(2,
                                  errorText:
                                  "Name should be minimum 3 character"),
                            ]),
                            controller: _firstNameController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              labelStyle: TextStyle(color: greyColor1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Date',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomText(
                                  text: _dob.text.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (m_dateStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Please select birth date',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            )
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Time',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CustomText(
                                  text: _time.text.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (m_tiemStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Please select birth time',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: CustomRichText(
                              text: 'Birth Place',
                              align: TextAlign.start,
                              color: blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      // PlaceSearchScreen((value,lat,log) {
                                      PlaceSearchScreen((value) {
                                        setState(() {
                                          setMPlace(value);
                                        });
                                        return value;
                                      })));

                              /* LocationResult result = await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyBaJahlqsM8FAUa6zAZ2RTef67NqQtVZVY")));
                              setState(() {
                                _placeOfBirth.text=result.name;
                                latitude=result.latLng.latitude.toString();
                                longitude=result.latLng.longitude.toString();
                              });*/
                            },
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "Birth place Required"),
                              MaxLengthValidator(30,
                                  errorText: "Enter Valid Birth place"),
                              MinLengthValidator(2,
                                  errorText:
                                  "Birth place be minimum 2 character"),
                            ]),
                            readOnly: true,
                            controller: _placeOfBirth,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1),
                              ),
                              labelStyle: TextStyle(color: greyColor1),
                            ),
                          ),
                        ),
                        (m_placeStatus)
                            ? Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: 'Try nearby city or district!',
                              align: TextAlign.start,
                              color: redColor,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ))
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print('jhhhhhhhhhhhh');
                    validate();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
  context: context,
  initialDate: selectedDate,
  firstDate: DateTime(1900, 8),
  lastDate: DateTime.now(),
);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        day = selectedDate.day;
        month = selectedDate.month;
        year = selectedDate.year;
        _dob.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dob.text=outputFormat.format(outputFormat);
      });
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
    //String datetime2 = DateFormat.Hms().format(_startDate);
    var dateFormat = DateFormat("hh:mm a");
    _time.text = dateFormat.format(tempDate);
   final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );
    setState(() {
      selectedTime = timeOfDay!;

      DateTime tempDate = DateFormat("hh:mm").parse(
          selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
      //String datetime2 = DateFormat.Hms().format(_startDate);
      var dateFormat = DateFormat("hh:mm");
      hh = tempDate.hour.toString();
      mm = tempDate.minute.toString();
      _time.text = dateFormat.format(tempDate);
    });
    if (timeOfDay != null && timeOfDay != selectedTime) {}
  }

  void setMPlace(String value) {
    getLatidudeM(value.toString());
    setState(() {
      _placeOfBirth.text =
      (value.length > 40) ? value.substring(0, 40) + ".." : value;
    });
  }

  Future<void> getLatidudeM(String address) async {
    var res = await _httpService.geocode(place: address);
    setState(() {
      latitude = res!.lat.toString();
      longitude = res.lng.toString();
    });
  }

}
