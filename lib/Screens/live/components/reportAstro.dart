import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../Setup/SetUp.dart';
import '../../../Utilities/CustomText.dart';
import '../../WebServices/HttpServices.dart';

enum ReportOption { unprofessionalBehaviour, abusiveContent, misguidance, others }




class ReportDialog extends StatefulWidget {
  final String astroId;
  ReportDialog(this.astroId);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportOption? _selectedOption;
  TextEditingController commntController=TextEditingController();
  String ? selectedValue;
  final _api=HttpServices();
  void reportAstroApi( {required String astrologerId,
    required String reason}){
    _api.reportAstrologer(astrologerId: astrologerId, reason: reason).then((value) {

      Fluttertoast.showToast(
          msg: value["message"].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pop(context);


    }).onError((error, stackTrace) {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 1),
                  CustomText(
                    text: "Report",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset("assets/images/cancelImage.png", height: 30, width: 30),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Unprofessional Behaviour'),
                    leading: Radio<ReportOption>(
                      value: ReportOption.unprofessionalBehaviour,
                      groupValue: _selectedOption,
                      onChanged: (ReportOption? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Abusive Content/Harmful'),
                    leading: Radio<ReportOption>(
                      value: ReportOption.abusiveContent,
                      groupValue: _selectedOption,
                      onChanged: (ReportOption? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Misguidance'),
                    leading: Radio<ReportOption>(
                      value: ReportOption.misguidance,
                      groupValue: _selectedOption,
                      onChanged: (ReportOption? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Others'),
                    leading: Radio<ReportOption>(
                      value: ReportOption.others,
                      groupValue: _selectedOption,
                      onChanged: (ReportOption? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  width: double.infinity,
                  child: TextFormField(
                    controller: commntController,
                    decoration: InputDecoration(
                      hintText: "Write your reason....",
                      contentPadding: EdgeInsets.only(left: 20),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (_selectedOption != null) {
                    selectedValue = _selectedOption.toString().split('.').last;
                    print("Selected value ==>>> $selectedValue");
                    reportAstroApi(astrologerId:widget.astroId ,reason: selectedValue.toString());
                  }else{
                    selectedValue=commntController.text.toString();
                    print("commnt====>>>>  ${selectedValue}");
                    reportAstroApi(astrologerId:widget.astroId ,reason: selectedValue.toString());

                  }


                  // Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "Submit",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}