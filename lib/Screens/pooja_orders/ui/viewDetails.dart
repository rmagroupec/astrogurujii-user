import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:get/get.dart';

import '../controller/PoojaOrderController.dart';

class ViewDetails extends StatefulWidget {
  final String poojaBookingId;

  const ViewDetails(this.poojaBookingId, {Key? key}) : super(key: key);

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> with SingleTickerProviderStateMixin {
   AnimationController? _animationController;
   Animation<double>? _opacityAnimation;
  PoojaOrderController screenController = Get.put(PoojaOrderController());

  @override
  void initState() {
    super.initState();
    screenController.viewDetailsApi(widget.poojaBookingId.toString());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("View Details", style: TextStyle(color: Colors.white)),
      ),
      body: GetBuilder<PoojaOrderController>(
        init: PoojaOrderController(),
        builder: (controller) {
          return screenController.viewDetailsModel == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FadeTransition(
              opacity: _opacityAnimation!,
              child:
                Column(children: [

                  cardSection(title: "Name",value: screenController.viewDetailsModel!.userDetails!.name ?? ""),
                  cardSection(title: "Gotra",value: screenController.viewDetailsModel!.userDetails!.gotra ?? ""),
                  cardSection(title: "Purpose",value: screenController.viewDetailsModel!.userDetails!.purposeOfPooja ?? ""),
                  cardSection(title: "Place",value: screenController.viewDetailsModel!.userDetails!.place ?? ""),
                  cardSection(title: "Email",value: screenController.viewDetailsModel!.userDetails!.email ?? ""),
                  cardSection(title: "WhatsApp Number",value: screenController.viewDetailsModel!.userDetails!.whatsappNumber ?? ""),
                  cardSection(title: "Courier Address",value: screenController.viewDetailsModel!.userDetails!.courierAddress ?? ""),

                ],)

              // Table(
              //   columnWidths: const {
              //     0: FixedColumnWidth(100),
              //     1: FlexColumnWidth(),
              //   },
              //   border: TableBorder.all(color: Colors.grey),
              //   children: [
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.name ?? ""),
              //       ),
              //     ]),
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("Gotra:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.gotra ?? ""),
              //       ),
              //     ]),
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("Purpose:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.purposeOfPooja ?? ""),
              //       ),
              //     ]),
              //
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("Place:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.place ?? ""),
              //       ),
              //     ]),
              //
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.email ?? ""),
              //       ),
              //     ]),
              //
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("WhatsApp Number:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.whatsappNumber ?? ""),
              //       ),
              //     ]),
              //
              //     TableRow(children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("Courier Address:", style: TextStyle(fontWeight: FontWeight.bold)),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(screenController.viewDetailsModel!.userDetails!.courierAddress ?? ""),
              //       ),
              //     ]),
              //   ],
              // ),
            ),
          );
        },
      ),
    );
  }

  Widget cardSection({required String title,required String value}){
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 5,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),

              CustomText(text: value,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )
            ],),
        ),
      ),
    );
  }
}
