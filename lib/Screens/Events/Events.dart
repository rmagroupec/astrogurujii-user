import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Events extends StatefulWidget {
  List<Live>data=[];
   Events({Key? key,required this.data}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 300,
      child: GridView.count(
      physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // Create a grid with 2 columns in portrait mode, or 3 columns in
        // landscape mode.
        crossAxisCount: orientation == Orientation.portrait ? 4:5,
        mainAxisSpacing: 10,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(widget.data.length, (index) {
          return Center(
            child: Column(
            mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                 InkWell(
                   onTap: (){
                     Fluttertoast.showToast(msg: "Coming soon");
                   },
                   child: CircleAvatar(
                    radius: 35,backgroundImage: NetworkImage(widget.data[index].profileImg.toString()),),
                 ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: blueColor, 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     Container(
                       width: 7,
                       height: 7,
                       decoration: BoxDecoration(
                         color: greenColor,
                         shape: BoxShape.circle
                       ),
                     ),
                      CustomText(text: 'Live',color: whiteColor,fontWeight: FontWeight.w600,)
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      )
    );
  }
}
