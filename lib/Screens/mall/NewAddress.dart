
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/mall/AddAddress.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';

class NewAddress extends StatefulWidget {
  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // FORM KEY
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HttpServices _httpService = HttpServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  bool _isLoading = true;
  String? value1 = null;
  List<DropdownMenuItem<String>> listDrop = [];
  List<DropdownMenuItem<String>> listDrop1 = [];
  String userId1 = "";
  var details;
  String? selected, selected2 = null;
  @override
  void initState() {
    // TODO: implement initState
    //callWebService();
    //statename();
    super.initState();
  }

  //State Name Api

  /* Future<String> statename() async {
    final _prefs = await SharedPreferences.getInstance();
    userId1 = _prefs.getString('userID') ?? '';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final res = jsonEncode({
      "user_id": userId1,
    });
    var response = await http.post(
        "https://talkastro.devclub.co.in/userapi/state_list",
        headers: headers,
        body: res);
    Map data = json.decode(response.body);
    var status = data['status'];
    details = data["states"] as List;
    listDrop = [];
    if (status == true) {
      setState(() {
        _isLoading = false;
        for (int i = 0; i < details.length; i++) {
          listDrop.add(new DropdownMenuItem(
            child: new Text(
              details[i]['name'],
            ),
            value: details[i]['id'],
          ));
        }
      });
    }
    return "Success";
  }
*/
  //City Name Api
  /* Future cityName(String id) async {
    final _prefs = await SharedPreferences.getInstance();
    userId1 = _prefs.getString('userID') ?? '';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final res = jsonEncode({"user_id": userId1, "state_id": id});
    var response = await http.post(
        "https://talkastro.devclub.co.in/userapi/city_list",
        headers: headers,
        body: res);
    Map data = json.decode(response.body);
    var status = data['status'];
    var cityes = data["cities"] as List;

    listDrop1 = [];
    if (status == true) {
      setState(() {
        //_isLoading=false;
        for (int i = 0; i < cityes.length; i++) {
          listDrop1.add(new DropdownMenuItem(
            child: new Text(
              cityes[i]['city'],
            ),
            value: cityes[i]['id'],
          ));
        }
      });
    }
  }*/

  /* callWebService() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var res = await _httpService.getProfile();
    if (res.result == "true") {
      profileData = res;
      _nameController.text = res.user_list.name;
      _mobileNumber.text = res.user_list.phone;
    } else {
      //print("Profile Api Not Working");
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }
*/
  //Api Add Address

  Future addAddress() async {
    setState(() {
      _isLoading = true;
    });

    var res = await _httpService.user_address(
        key: "add",
        contact_person_mobile: _mobileNumber.text,
        contact_person_name: _nameController.text,
        landmark: _landmarkController.text,
        location: _addressController.text,
        building_name: _localityController.text,
        flat_no: _flatController.text,
        pincode: _pincodeController.text,
        address_type: value1,
        is_default: "Y");
    if (res!.result == true) {
      setState(() {
        _isLoading = false;
        _scaffoldKey.currentState!.
            //.showSnackBar(new SnackBar(content: new Text("Successfully Added")));
            setState(() {
          _isLoading = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (BuildContext context) => AddAddress()));
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  validate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      addAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: blueColor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("Add Address",style: TextStyle(color: whiteColor),),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Name cannot be blank';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Name",
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              //  color: blueColor,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Mobile Number cannot be blank';
                        }
                        return null;
                      },
                      controller: _mobileNumber,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Mobile",
                        hintText: "Mobile",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              //  color: blueColor,
                              ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Address cannot be blank';
                        }
                        return null;
                      },
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Address",
                        hintText: "Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Locality cannot be blank';
                        }
                        return null;
                      },
                      controller: _localityController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Locality",
                        hintText: "Locality",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Flat no cannot be blank';
                        }
                        return null;
                      },
                      controller: _flatController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Flat no",
                        hintText: "Flat no",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Landmark cannot be blank';
                        }
                        return null;
                      },
                      controller: _landmarkController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Landmark",
                        hintText: "Landmark",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Pincode cannot be blank';
                        } else if (val.length < 6) {
                          return 'Pincode must be 6 digit';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _pincodeController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: blueColor),
                        labelText: "Pincode",
                        hintText: "Pincode",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: blueColor,
                          )),
                      margin: EdgeInsets.only(top: 20),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: value1,
                          hint: Text(
                            ' Select Type',
                            style: TextStyle(color: blueColor),
                          ),
                          items: <String>['Home', 'Office', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          iconSize: 30.0,
                          elevation: 16,
                          iconEnabledColor: blueColor,
                          onChanged: (val) {
                            setState(() {
                              value1 = val!;
                              //print(value1);
                            });
                          },
                        ),
                      )),
                  /*  Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: blueColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                isExpanded: true,
                                value: selected,
                                hint: new Text(
                                  'Select State',
                                  style: new TextStyle(
                                    color: blueColor,
                                    fontSize: 18.0,
                                  ),
                                ),
                                items: listDrop,
                                iconSize: 30.0,
                                elevation: 16,
                                iconEnabledColor: blueColor,
                                onChanged: (value) {
                                  setState(() {
                                    selected = value;
                                    //_isLoading=true;
                                    cityName(selected);
                                  });
                                }),
                          ),
                        ),*/
                  /* Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: blueColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                isExpanded: true,
                                value: selected2,
                                hint: new Text(
                                  'Select City',
                                  style: new TextStyle(
                                    color: blueColor,
                                    fontSize: 18.0,
                                  ),
                                ),
                                items: listDrop1,
                                iconSize: 30.0,
                                elevation: 16,
                                iconEnabledColor: blueColor,
                                onChanged: (value) {
                                  setState(() {
                                    selected2 = value;
                                  });
                                }),
                          ),
                        ),*/
                  InkWell(
                    onTap: () async {
                      /*setState(() {
                        _isLoading = true;
                      });*/

                      //addAddress();
                      validate();
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 40,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                      child: Text(
                        "Add Address",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
