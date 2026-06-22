
import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../TalkAstrologer/TalkAstrologers.dart';
import '../report/model/Result.dart';

class ReportListScreen extends StatefulWidget {
  static const String astroReport = "/astroReport";
  final String? id;
  ReportListScreen({this.id});

  @override
  State<ReportListScreen> createState() => _AstroReportTypeState();
}

class _AstroReportTypeState extends State<ReportListScreen> {
  HttpServices _httpService = HttpServices();
  bool is_loading = true;
  bool _isLoading = true;
  List<Result> tbl_report = [];
  String currency = '';
  String currencySign = "";
  @override
  void initState() {
    // TODO: implement initState
    //getAstroList();
    //callWebService();
    getProfile();
    getDataApi();
    super.initState();
  }

  Future<void> getDataApi() async {
    var res = await _httpService.report_list(id: "");
    if (res!.status == true) {
      setState(() {
        if (res.results != null) {
          tbl_report.addAll(res.results!);
        }
        _isLoading = false;
      });
    } else {
      _isLoading = false;
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  void getProfile() async {
    var res = await _httpService.profile_api();
    if (res!.status == true) {
      setState(() {
        currency = res.results!.currency.toString();
        if (currency == "USD") {
          setState(() {
            currencySign = "\u{20B9}";
          });
        } else {
          setState(() {
            currencySign = "\u{20B9}";
          });
        }
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Select Report Type",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: tbl_report.length,
                itemBuilder: (ctx, i) => reportType(
                    currencySign: currencySign,
                    context: context,
                    id: tbl_report[i].id!,
                    description: tbl_report[i].description,
                    price: tbl_report[i].price,
                    banner: tbl_report[i].banner,
                    type: tbl_report[i].type,
                    astroID: widget.id,
                    amount: tbl_report[i].price)));
  }
}

Widget reportType(
    {currencySign,
    context,
    String? id,
    description,
    price,
    banner,
    type,
    astroID,
    amount}) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TalkAstrologer(
                  appBarName: "Ask Report",
                  reportid: id.toString(),
                  chatKey: "",
                  talkKey: "",
                  videoKey: "",
                  report: "on",
                  callType: "report")));

      /*Navigator.push(context, MaterialPageRoute(
          builder: (ctx) =>
              ReportIntakeForm(astroId: astroID,
                id:id.toString(),title:type,amount: amount.toString(), ))
      );*/

      // Navigator.pushNamed(context, ReportIntakeForm.reportIntakeForm);
    },
    child: Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Container(
                child: Image.network(
              banner,
              fit: BoxFit.cover,
            )),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    type,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(description),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Price start at ${currencySign} " + amount.toString(),
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
