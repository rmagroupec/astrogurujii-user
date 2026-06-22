
 import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

import 'WebServices/model/kundali/KundaliDetails.dart';

class MatchMakingFormScreen extends StatefulWidget {
  final String id;
  final String price;
  MatchMakingFormScreen({required this.id,required this.price});
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<MatchMakingFormScreen> {
  HttpServices _httpService = HttpServices();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _relationShipStatus = TextEditingController();
  final TextEditingController _genderStatus = TextEditingController();
  final TextEditingController _placeOfBirth = TextEditingController();
  var day;
  var month;
  var year;
  var hh;
  var mm;
   bool? isLoading;
  String userId1="";

  var _currencies = [
    "India",
    "Afghanistan",
    "Albania",
    "Austria",
    "Belize",
    "Bangladesh",
    "Canada",
    "United States",
  ];

  var _genderList = [
    "Male",
    "Female",
    "Other"
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validate() {
    if (_formKey.currentState!.validate()) {

      if(_dob.text.length == 0 || _time.text.length == 0 ||   _relationShipStatus.text.length==0)
      {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please fill input fields'),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        
                        ),

                        onPressed: () {

                          Navigator.pop(context);

                        },
                        child: Text("Ok"),
                      )
                    ],
                  )

                ],
              ),
            )
        );
      }
      else
      {
       // print(_dob.text);
       // print("=====================================================ok");

        _createUser();

      }
    }
    else {

    }

  }

  _createUser() async
  {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.kundali(
      name: _firstNameController.text,
      year: year.toString(),
      month: month.toString(),
      day: day.toString(),
      hour: hh.toString(),
      min: mm.toString(),
      lat: "28.542294867618875",
      lon: "77.42449198114385",
      tzone: "5.5",
      planetColor: "black",
      signColor: "black",
      lineColor: "black",
      chartType: "black",
    );
    if(res!.status == true)
    {
      Fluttertoast.showToast(msg: res.message!);
      Navigator.pop(context);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => KundaliDetailsN(res:res,name:_firstNameController.text,place: _placeOfBirth.text,id: res.id.toString(),)),
      // );

    }
    else
    {
      //print("SigUp fAILED");
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
        backgroundColor: primaryColor,
        title: Text("Kundli Form"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: "Name Required"),
                          MaxLengthValidator(30, errorText: "Enter Valid First Name"),
                          MinLengthValidator(2,
                              errorText: "Name should be minimum 3 character"),
                        ]
                    ),
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
                      labelText: "Name",
                      hintText: "Name",
                    ),
                  ),
                ),
                /*Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    validator: MultiValidator(
                        [
                          MaxLengthValidator(30, errorText: "Enter Valid Last Name"),
                        ]
                    ),
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greyColor1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greyColor1),
                      ),
                      labelStyle: TextStyle(color: greyColor1),
                      labelText: "Enter Last name",
                      hintText: "Enter last name",
                    ),
                  ),
                ),*/

                SizedBox(height: 20,),

                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: greyColor1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: greyColor1),
                          ),
                          labelText: "Gender",
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Gender',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: _genderSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _genderSelectedValue,
                          isDense: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _genderSelectedValue = newValue;
                              //print(_genderSelectedValue);
                              _genderStatus.text = _genderSelectedValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _genderList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20,),
                Align(
                    alignment : Alignment.topLeft,
                    child: CustomText(text:'Birth Date',align:TextAlign.start,color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500,)),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    _selectDate(context);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)
                          ),
                          child: CustomText(text: _dob.text.toString(),),
                        )
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                Align(
                    alignment : Alignment.topLeft,
                    child: CustomText(text:'Birth Time',align:TextAlign.start,color: primaryColor,fontSize: 14,fontWeight: FontWeight.w500,)),
                SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    _selectTime(context);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)
                          ),
                          child: CustomText(text: _time.text.toString(),),
                        )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: _placeOfBirth,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greyColor1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: greyColor1),
                      ),
                      labelStyle: TextStyle(color: greyColor1),
                      labelText: "Place of Birth",
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: greyColor1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: greyColor1),
                          ),
                          labelText: "Country",
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Country',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              _currentSelectedValue = newValue;
                              //print(_currentSelectedValue);
                              _relationShipStatus.text = _currentSelectedValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: () {
                    validate();
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        top: 20,
                        bottom: 20
                    ),
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
  initialEntryMode: DatePickerEntryMode.calendarOnly,
  firstDate: DateTime(1980, 8),
  lastDate: DateTime.now(),
);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        day=selectedDate.day;
        month=selectedDate.month;
        year=selectedDate.year;
        _dob.text= DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dob.text=outputFormat.format(outputFormat);
      });
    }
  }
  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() +
            ":" + selectedTime.minute.toString());
    //String datetime2 = DateFormat.Hms().format(_startDate);
    var dateFormat = DateFormat("hh:mm a");
    _time.text=dateFormat.format(tempDate);
   final TimeOfDay? timeOfDay = await showTimePicker(
  context: context,
  initialTime: selectedTime,
  initialEntryMode: TimePickerEntryMode.dial,
);
    setState(() {

      selectedTime = timeOfDay!;

      DateTime tempDate = DateFormat("hh:mm").parse(
          selectedTime.hour.toString() +
              ":" + selectedTime.minute.toString());
      //String datetime2 = DateFormat.Hms().format(_startDate);
      var dateFormat = DateFormat("hh:mm");
      hh= tempDate.hour.toString();
      mm=tempDate.minute.toString();
      _time.text=dateFormat.format(tempDate);
    });
    if(timeOfDay != null && timeOfDay != selectedTime)
    {

    }
  }
}
