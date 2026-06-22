
import 'package:flutter/material.dart';
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/PlaceSearchScreen.dart';
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Screens/video_call/Helpers/utils.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:astro_gurujii/Utilities/CustomUi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreenBottomSheet extends StatefulWidget {
  const ProfileScreenBottomSheet({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenBottomSheet> {

  XFile? _imageFiler;
  final ImagePicker _picker = ImagePicker();
  String? path;
  int gender1 = 0;
  final HttpServices _httpServices=HttpServices();
  ProfileResults? profileResults;
  final TextEditingController nameController=TextEditingController();
  final TextEditingController dateOfBirth=TextEditingController();
  final TextEditingController timeOfBirth=TextEditingController();
  final TextEditingController placeOfBirth=TextEditingController();
  final TextEditingController rashi=TextEditingController();
  final TextEditingController mobile=TextEditingController();
  final TextEditingController email=TextEditingController();
  String genderName="";
  bool _isLoading=true;
  bool _isNameEdit=true,_isLocationEdit=true,_isRashiEdit=true,_isNumberEdit=true,_isEmailEdit=true;


  profile_update() async {
    var res = await _httpServices.profile_update(
        img: path.toString());
    if (res?.status == true) {
      setState(() {
        Fluttertoast.showToast(msg: res!.message.toString());
        getProfile();
        _isLoading=false;
      });
    }
  }

  void getProfile()async{
    var res=await _httpServices.profile_api();
    if(res!.status==true){
      setState(() {
        profileResults=res.results;
        nameController.text=profileResults!.name!;
        placeOfBirth.text=profileResults!.pob!;
        mobile.text=profileResults!.number!;
        email.text=profileResults!.email!;
        dateOfBirth.text=profileResults!.dob!;
        timeOfBirth.text=profileResults!.tob!;
        _isLoading=false;
      });
    }
    else
    {
      Fluttertoast.showToast(msg: res.message!);
    }
  }


  void updateProfileApi()async{
    _isLoading=true;
    var res=await _httpServices.updateProfile_api(
        name: nameController.text,
        dob: dateOfBirth.text,gender: genderName,
        pob: placeOfBirth.text,
        tob: timeOfBirth.text,
        rashi: rashi.text, email: '');
    if(res!.status==true)
    {
      setState(() {
        Fluttertoast.showToast(msg: res.message.toString());
        getProfile();
        _isLoading=false;
      });
    }
    else{
      Fluttertoast.showToast(msg: res.message.toString());
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
    return Container(
      height: MediaQuery.of(context).copyWith().size.height * 0.75,
      child: Scaffold(
        backgroundColor: whiteColor,
        body: (_isLoading)? Center(child:Lottie.asset(
          'assets/profile/loader.json',
        ),):SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,top: 15),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new),
                      const SizedBox(width: 10,),
                      CustomText(text: "Profile",color: blackColor,fontSize: 16,fontWeight: FontWeight.w600,)
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30,),
              Stack(
                alignment: Alignment.bottomCenter,
                //   fit: StackFit.loose,
                children: [
                  Container(
                      width: 120,
                      decoration:  BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                        border:  Border.all(
                          color:  Color(0xFFD1D3FF),
                          width: 10,
                        ),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: CachedNetworkImageProvider(profileResults!.profileImg.toString()),
                        ) ,

                      )
                  ),

                  Positioned(
                    bottom: 13,
                    right: 15,
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: TextButton(

                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (builder) =>
                                    bottomSheet());
                          },
                          // color: whiteColor,
                          child: Image.asset('assets/login/Camera.png',width:40,height: 40,)
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/name.png')),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      readOnly: false,
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Name",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              _isNameEdit=false;
                            });
                          },
                          child: CustomText(text: "Edit",color: blackColor))),
                ],
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/calendar.png',width: 35,height: 35,)),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      onTap: (){
                        _selectDate(context);

                      },
                      readOnly: true,
                      controller: dateOfBirth,
                      decoration: InputDecoration(
                          hintText: "Date of Birth",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: CustomText(text: "Edit",color: blackColor)),
                ],
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/calendar.png',width: 35,height: 35,)),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      onTap: (){
                        _selectTime(context);
                      },
                      readOnly: true,
                      controller: timeOfBirth,
                      decoration: InputDecoration(
                          hintText: "Time of Birth",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: CustomText(text: "Edit",color: blackColor)),
                ],
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/location.png',width: 35,height: 35,)),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaceSearchScreen((value) {
                                  setState(() {
                                    setMPlace(value);
                                  });
                                  return value;
                                })
                            ));
                      },
                      readOnly: true,
                      controller: placeOfBirth,
                      decoration: InputDecoration(
                          hintText: "Place of Birth",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              _isLocationEdit=false;
                            });
                          },

                          child: CustomText(text: "Edit",color: blackColor))),
                ],
              ),
              /* const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),*/
              /* const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/rashi.png',width: 35,height: 35,)),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      readOnly: _isRashiEdit,
                      controller: rashi,
                      decoration: InputDecoration(
                          hintText: "Rashi",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _isRashiEdit=false;
                          });
                        },
                          child: CustomText(text: "Edit",))),
                ],
              ),*/
              const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/calling.png',width: 35,height: 35,)),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      readOnly: true,
                      controller: mobile,
                      decoration: InputDecoration(
                          hintText: "Mobile Number",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              _isNumberEdit=false;
                            });
                          },
                          child: CustomText(text: "",))),
                ],
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Image.asset('assets/profile/mail.png',width: 35,height: 35,)),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      readOnly: true,
                      controller: email,
                      decoration: InputDecoration(
                          hintText: "Email Id",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: blackColor)
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: (){
                            setState(() {
                              _isEmailEdit=false;
                            });
                          },
                          child: CustomText(text: "",))),
                ],
              ),
              const Padding(
                padding:  EdgeInsets.only(left: 30,right: 30),
                child: Divider(
                  color: Color(0xFFD9D9D9),
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 30,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomText(text: "Gender",fontWeight: FontWeight.w400,fontSize: 18,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender1 = 0;
                        // genderSwitch(gender);
                        profileResults!.gender="Male";
                        //  print("Gender is :${data.gender}");
                        genderName=profileResults!.gender!;
                      });
                    },
                    child: Row(
                      children: [
                        profileResults!.gender!.toLowerCase() == "Male".toLowerCase()?Text(
                          'Male',
                          style: TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ):Text(
                          'Male',
                          style: TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 5,
                        ),

                        profileResults!.gender!.toLowerCase() == "Male".toLowerCase()
                            ?Icon(Icons.radio_button_checked,color: blueColor,size: 20,)
                            :Icon(Icons.radio_button_off_sharp,size: 20,),

                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender1 = 1;
                        //  genderSwitch(gender);
                        profileResults!.gender="Female";
                        //  print("Gender is :${data.gender}");
                        genderName=profileResults!.gender!;
                      });
                    },
                    child: Row(
                      children: [
                        profileResults!.gender == "Female"?Text(
                          'Female',
                          style: TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ):Text(
                          'Female',
                          style: TextStyle(
                              color: Color(0xFF6F6F6F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        profileResults!.gender == "Female"
                            ? Icon(Icons.radio_button_checked,color:blueColor,size: 20,)
                            : Icon(Icons.radio_button_off_sharp,size: 20,),
                        SizedBox(
                          width: 5,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30,right: 30,top: 30,bottom: 20),
                child: CustomUi.getAppPrimaryButton('SAVE', (){
                  setState(() {
                    _isLoading=true;
                  });
                  updateProfileApi();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getImage1(source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFiler = pickedFile;
      path = _imageFiler!.path;
      _isLoading=true;
      profile_update();
    });
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
                label: CustomText(text:
                "Camera",color: blackColor,),
              ),
              TextButton.icon(
                icon: Icon(Icons.image, color: blueColor),
                onPressed: () {
                  getImage1(ImageSource.gallery);
                  Navigator.pop(context);
                },
                label: CustomText(text:
                "Gallery",
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
  initialEntryMode: DatePickerEntryMode.calendarOnly,
  firstDate: DateTime(1980, 8),
  lastDate: DateTime.now(),
);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirth.text= DateFormat('yyyy-MM-dd').format(selectedDate);
        // _dateText.text=outputFormat.format(outputFormat);
      });
    }
  }


  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {

    DateTime tempDate = DateFormat("hh:mm").parse(
        selectedTime.hour.toString() +
            ":" + selectedTime.minute.toString());
    var dateFormat = DateFormat("hh:mm a");
    timeOfBirth.text=dateFormat.format(tempDate);

    final TimeOfDay? pickedTime = await showTimePicker(
  context: context,
  initialTime: selectedTime,
  initialEntryMode: TimePickerEntryMode.dial,
);
    if(pickedTime != null && pickedTime != selectedTime)
    {
      setState(() {
        selectedTime = pickedTime;
        DateTime tempDate = DateFormat("hh:mm").parse(
            selectedTime.hour.toString() +
                ":" + selectedTime.minute.toString());
        //String datetime2 = DateFormat.Hms().format(_startDate);
        var dateFormat = DateFormat("hh:mm a");
        timeOfBirth.text=dateFormat.format(tempDate);
      });
    }
  }

  void setMPlace(String value) {

    setState(() {
      placeOfBirth.text=(value.length>40)?value.substring(0,40)+"..":value;
    });
  }

}
