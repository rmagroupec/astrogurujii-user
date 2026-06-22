

import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:astro_gurujii/Setup/buttons/app_button.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _imageFiler;
  final ImagePicker _picker = ImagePicker();
  String? path;
  int gender1 = 0;
  final HttpServices _httpServices = HttpServices();
  ProfileResults? profileResults;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController timeOfBirth = TextEditingController();
  final TextEditingController placeOfBirth = TextEditingController();
  final TextEditingController rashi = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController email = TextEditingController();
  String genderName = "";
  bool _isLoading = true;
  bool _isNameEdit = true,
      _isLocationEdit = true,
      _isRashiEdit = true,
      _isNumberEdit = true,
      _isEmailEdit = true;

  profile_update() async {
    var res = await _httpServices.profile_update(img: path.toString());
    if (res!.status == true) {
      setState(() {
        Fluttertoast.showToast(msg: res.message!);
        getProfile();
        _isLoading = false;
      });
    }
  }

  void getProfile() async {
    var res = await _httpServices.profile_api();
    if (res!.status == true) {
      setState(() {
        profileResults = res.results;
        nameController.text = profileResults!.name!;
        placeOfBirth.text = profileResults!.pob!;
        mobile.text = profileResults!.number!;
        email.text = profileResults!.email!;
        dateOfBirth.text = profileResults!.dob!;
        timeOfBirth.text = profileResults!.tob!;
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }


  void updateProfileApi() async {
    bool nameValid = RegExp(r'^[A-Za-z\s]+$').hasMatch(nameController.text);
     bool emailValid = 
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email.text);
      if (nameValid == true){
    if (emailValid == true){
       setState(() {
                      _isLoading = true;
                    });
    SharedPreferences preff=await SharedPreferences.getInstance();

    _isLoading = true;

    var res = await _httpServices.updateProfile_api(
        name: nameController.text,
        dob: dateOfBirth.text,
        gender: genderName,
        pob: placeOfBirth.text,
        tob: timeOfBirth.text,
        email: email.text,
        rashi: rashi.text);
    if (res!.status == true) {
      setState(() {
        Fluttertoast.showToast(msg: res.message!);
        preff.setString("name", nameController.text.trim().toString());

        getProfile();
        _isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
    }
    else{
       Fluttertoast.showToast(msg: "Enter valid Email");
    }
      }
    else{
       Fluttertoast.showToast(msg: "Enter valid Name, Numbers are not allowed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        iconTheme:IconThemeData(
         color: whiteColor, // Set your desired color here
        ),
        title:   CustomText(
          text: "Edit Profile",
          color: whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: (_isLoading)
          ? Center(
              child: Lottie.asset(
                'assets/profile/loader.json',
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [


                  Stack(
                    alignment: Alignment.center,
                    children: [

                    Image.asset("assets/images/editProfileBackground.png",
                      fit: BoxFit.fill,
                      height: 200,
                      width: double.infinity,
                    ),

                    Stack(
                      alignment: Alignment.bottomCenter,
                      //   fit: StackFit.loose,
                      children: [
                        Container(
                          // color: Colors.red,
                            width: 120,
                            child: Center(
                                child: ClipOval(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.2),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: profileResults!.profileImg!.isEmpty
                                        ? Image.asset(
                                      'assets/profile/name.png',
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(
                                      profileResults!.profileImg!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )

                              /*CircleAvatar(
                        radius: 45,
                       backgroundImage: CachedNetworkImageProvider(profileResults!.profileImg.toString()),
                      ) ,*/

                            )),
                        Positioned(
                          bottom: 1,
                          right: 9,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                       context: context,
                                      builder: (builder) => bottomSheet(),);
                                },
                                // color: whiteColor,
                                child: Image.asset(
                                  'assets/images/EditIconNew.png',
                                  fit: BoxFit.fill,

                                )),
                          ),
                        )
                      ],
                    ),

                  ],),



                  const SizedBox(
                    height: 20,
                  ),


                  customTextFormFiled(context, "Enter Name",nameController,false, 1),
                  customTextFormFiled( context, "Enter email ID",email,false, 2),
                  customTextFormFiled( context, "Enter Phone Number",mobile,true, 3),
                  customTextFormFiled( context, "Date of Birth",dateOfBirth,true, 4),
                  customTextFormFiled( context, "Time of Birth",timeOfBirth,true, 5),
                  customTextFormFiled( context, "Place of Birth",placeOfBirth,true, 6),



                  // /// start old code
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: Image.asset('assets/profile/name.png')),
                  //     Expanded(
                  //       flex: 4,
                  //       child: TextFormField(
                  //         readOnly: false,
                  //          nameController,
                  //         decoration: InputDecoration(
                  //              "Name",
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(color: blackColor)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 30, right: 30),
                  //   child: Divider(
                  //     color: Color(0xFFD9D9D9),
                  //     thickness: 2,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: Image.asset(
                  //           'assets/profile/calendar.png',
                  //           width: 25,
                  //           height: 25,
                  //         )),
                  //     Expanded(
                  //       flex: 4,
                  //       child:
                  //
                  //       TextFormField(
                  //         onTap: () {
                  //           _selectDate(context);
                  //         },
                  //         readOnly: true,
                  //          dateOfBirth,
                  //         decoration: InputDecoration(
                  //              "Date of Birth",
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(color: blackColor)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 30, right: 30),
                  //   child: Divider(
                  //     color: Color(0xFFD9D9D9),
                  //     thickness: 2,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: Image.asset(
                  //           'assets/profile/calendar.png',
                  //           width: 25,
                  //           height: 25,
                  //         )),
                  //     Expanded(
                  //       flex: 4,
                  //       child: TextFormField(
                  //         onTap: () {
                  //           _selectTime(context);
                  //         },
                  //         readOnly: true,
                  //          timeOfBirth,
                  //         decoration: InputDecoration(
                  //              "Time of Birth",
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(color: blackColor)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 30, right: 30),
                  //   child: Divider(
                  //     color: Color(0xFFD9D9D9),
                  //     thickness: 2,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: Image.asset(
                  //           'assets/profile/location.png',
                  //           width: 25,
                  //           height: 25,
                  //         )),
                  //     Expanded(
                  //       flex: 4,
                  //       child: TextFormField(
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       PlaceSearchScreen((value) {
                  //                         setState(() {
                  //                           setMPlace(value);
                  //                         });
                  //                       })));
                  //         },
                  //         readOnly: true,
                  //          placeOfBirth,
                  //         decoration: InputDecoration(
                  //              "Place of Birth",
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(color: blackColor)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 30, right: 30),
                  //   child: Divider(
                  //     color: Color(0xFFD9D9D9),
                  //     thickness: 2,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: Image.asset(
                  //           'assets/profile/calling.png',
                  //           width: 25,
                  //           height: 25,
                  //         )),
                  //     Expanded(
                  //       flex: 4,
                  //       child: TextFormField(
                  //         readOnly: true,
                  //          mobile,
                  //         decoration: InputDecoration(
                  //              "Mobile Number",
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(color: blackColor)),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         flex: 1,
                  //         child: InkWell(
                  //             onTap: () {
                  //               setState(() {
                  //                 _isNumberEdit = false;
                  //               });
                  //             },
                  //             child: CustomText(
                  //               text: "",
                  //             ))),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 30, right: 30),
                  //   child: Divider(
                  //     color: Color(0xFFD9D9D9),
                  //     thickness: 2,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //         flex: 1,
                  //         child: Image.asset(
                  //           'assets/profile/mail.png',
                  //           width: 25,
                  //           height: 25,
                  //         )),
                  //     Expanded(
                  //       flex: 4,
                  //       child: TextFormField(
                  //         readOnly: true,
                  //          email,
                  //         decoration: InputDecoration(
                  //              "Email Id",
                  //             border: InputBorder.none,
                  //             hintStyle: TextStyle(color: blackColor)),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         flex: 1,
                  //         child: InkWell(
                  //             onTap: () {
                  //               setState(() {
                  //                 _isEmailEdit = false;
                  //               });
                  //             },
                  //             child: CustomText(
                  //               text: "",
                  //             ))),
                  //   ],
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(left: 30, right: 30),
                  //   child: Divider(
                  //     color: Color(0xFFD9D9D9),
                  //     thickness: 2,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  //
                  //
                  // /// end


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.textFieldCOlor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey,width: 1)
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Gender",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  gender1 = 0;
                                  // genderSwitch(gender);
                                  profileResults!.gender = "Male";
                                  //  print("Gender is :${data.gender}");
                                  genderName = profileResults!.gender!;
                                });
                              },
                              child: Row(
                                children: [
                                  profileResults!.gender!.toLowerCase() ==
                                          "Male".toLowerCase()
                                      ? Text(
                                          'Male',
                                          style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                            fontSize: 14,

                                          ),
                                        )
                                      : Text(
                                          'Male',
                                          style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  profileResults!.gender!.toLowerCase() ==
                                          "Male".toLowerCase()
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: blueColor,
                                          size: 20,
                                        )
                                      : Icon(
                                          Icons.radio_button_off_sharp,
                                          size: 20,
                                        ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  gender1 = 1;
                                  //  genderSwitch(gender);
                                  profileResults!.gender = "Female";
                                  //  print("Gender is :${data.gender}");
                                  genderName = profileResults!.gender!;
                                });
                              },
                              child: Row(
                                children: [
                                  profileResults!.gender == "Female"
                                      ? Text(
                                          'Female',
                                          style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      : Text(
                                          'Female',
                                          style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  profileResults!.gender == "Female"
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          color: blueColor,
                                          size: 20,
                                        )
                                      : Icon(
                                          Icons.radio_button_off_sharp,
                                          size: 20,
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  CustomUi.getAppPrimaryButton('Submit', () {
                   
                    updateProfileApi();
                  }),

                  SizedBox(height: 20,),
                ],
              ),
            ),
    );
  }

  void getImage1(source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFiler = pickedFile;
      path = _imageFiler!.path;
      _isLoading = true;
      profile_update();
    });
  }

  Widget customTextFormFiled(

  
    BuildContext context,
    String  hintText,
    TextEditingController  controller,
     
     bool isRead,
    int num

      ){

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.textFieldCOlor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey,width: 1)
        ),
        child: TextFormField(
          onTap: () {
            switch(num){
              // case 2: Fluttertoast.showToast(
              //     msg: "Email Can't be Edit ",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              //          break;
              case 3: Fluttertoast.showToast(
                  msg: "Mobile Number Can't be Edit ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              break;
              case 4: _selectDate(context);
                       break;
              case 5: _selectTime(context);
                        break;
              case 6:  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PlaceSearchScreen(
      (value) {
        setState(() {
          setMPlace(value);
        });
        return value;
      },
    ),
  ),
);
                        break;

            }
           },
          readOnly: isRead,
          controller: controller
           ,
          decoration: InputDecoration(
               hintText: hintText,

              // suffixIcon: IconButton(onPressed: (){
              //
              // }, icon: num==3?Container():
              //
              // Image.asset("assets/images/EditIconNew.png",
              //   fit: BoxFit.fill,
              //   height: 20,width: 20,)),

              contentPadding: EdgeInsets.only(left: 13,top: 13),
              border: InputBorder.none,
              hintStyle: TextStyle(color: blackColor)),
        ),
      ),
    );

  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CustomText(text: 'Choose Profile photo'),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera, color: blueColor),
                onPressed: () {
                  getImage1(ImageSource.camera);
                  Navigator.pop(context);
                },
                label: CustomText(
                  text: "Camera",
                  color: blackColor,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.image, color: blueColor),
                onPressed: () {
                  getImage1(ImageSource.gallery);
                  Navigator.pop(context);
                },
                label: CustomText(
                  text: "Gallery",
                  color: blackColor,
                ),
              ),
            ],
          )
        ],
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
        dateOfBirth.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dateText.text=outputFormat.format(outputFormat);
      });
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() + ":" + selectedTime.minute.toString());
    var dateFormat = DateFormat("hh:mm a");
    timeOfBirth.text = dateFormat.format(tempDate);

    final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: selectedTime,
    initialEntryMode: TimePickerEntryMode.dial,
  );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        DateTime tempDate = DateFormat("hh:mm").parse(
            selectedTime.hour.toString() +
                ":" +
                selectedTime.minute.toString());
        //String datetime2 = DateFormat.Hms().format(_startDate);
        var dateFormat = DateFormat("hh:mm a");
        timeOfBirth.text = dateFormat.format(tempDate);
      });
    }
  }

  void setMPlace(String value) {
    setState(() {
      placeOfBirth.text =
          (value.length > 40) ? value.substring(0, 40) + ".." : value;
    });
  }
  
}
