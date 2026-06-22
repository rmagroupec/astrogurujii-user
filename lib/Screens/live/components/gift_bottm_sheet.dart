import 'package:astro_gurujii/Screens/WebServices/HttpServices.dart';
import 'package:astro_gurujii/Setup/SetUp.dart';
import 'package:astro_gurujii/Utilities/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../Models/GetGiftModel.dart';
import '../../MyWallet.dart';

class GiftBottomSheets extends StatefulWidget {
  List<Data>? dataGifts;
  final String astroId;
  final String screenType;
  var id;



  GiftBottomSheets({this.dataGifts,this.id ,required this.astroId, required this.screenType});

  @override
  State<GiftBottomSheets> createState() => _GiftBottomSheetsState();

  static showGistBottomSheet({
    required BuildContext context,
    List<Data>? dataGifts,
    required String astroId,
    required String id,
    required String screenType,

  }) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return GiftBottomSheets( id: id,dataGifts: dataGifts, astroId: astroId,screenType: screenType,);
      },
    );
  }
}

class _GiftBottomSheetsState extends State<GiftBottomSheets> {
  final HttpServices _httpServices = HttpServices();
  List<Data> dataGifts = [];

  @override
  void initState() {
    super.initState();
    getListGift();
  }

  void getListGift() async {
    var res = await _httpServices.getGiftsListing();
    if (res!.status == true) {
      setState(() {
        dataGifts = res.data!;
      });
    } else {
      Fluttertoast.showToast(msg: res.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: CustomText(
              text: "Gifts",
              color: Colors.white,
              fontSize: 25,
              letterspace: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: dataGifts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 150
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                   print("amount---->>> ${ dataGifts[index].price}");

                      onGiftSendFun(
                          giftId: dataGifts[index].sId.toString(),
                          to: widget.astroId.toString(),
                           amount: dataGifts[index].price,
                        id: widget.id
                      );


                    },
                    child: Column(children: [
                      SizedBox(height: 5,),

                      ClipOval(
                        child: Image.network(
                          dataGifts[index].image!,
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.grey[300]!,
                                            Colors.grey[100]!,
                                            Colors.grey[300]!,
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      CustomText(
                          text: dataGifts[index].title??"",
                          fontSize: 13,
                          color: Colors.white,
                          // fontWeight: FontWeight.bold
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                          text: dataGifts[index].price.toString(),
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),

                    ],),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  final _api = HttpServices();

  onGiftSendFun({String? giftId, String? to,String ?id,int ?amount}) {

    if(widget.screenType=="home"){

      _api.giftSendApiForLiveFun(giftId: giftId, to: to, id: widget.id,amount: amount).then((value) {

        if(value['status']==true){
          Fluttertoast.showToast(
            msg: value['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
        }else if(value['status']==false){
          showInsufficientBalanceDialog(context,value['message'].toString());

        }

      }).onError((error, stackTrace) {
        print("Errorin API giftSendApi: $error");
        print("Errorin API stacktrace: $stackTrace");
      });

    }else if(widget.screenType=="pooja"){
      _api.giftSendApiForPoojaFun(giftId: giftId, to: to,id: widget.id,amount: amount).then((value) {

        if(value['status']==true){
          Fluttertoast.showToast(
            msg: value['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
        }else if(value['status']==false){
          showInsufficientBalanceDialog(context,value['message'].toString());

        }

      }).onError((error, stackTrace) {
        print("Errorin API giftSendApi: $error");
        print("Errorin API stacktrace: $stackTrace");
      });


    }




  }
}

void showInsufficientBalanceDialog(BuildContext context, String msg,) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Alert'),
          InkWell(

              onTap: () {

                Navigator.pop(context);
              },
              child: Icon(Icons.close,color: Colors.black,))
        ],),
        content: Text(msg),
        actions: <Widget>[

          TextButton(
            child: Text(' Recharge Now'),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MyWallet()));
              // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void howToWorksDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: IntrinsicHeight(
          child: GiftsInfoScreen(),
        ),
      );
    },
  );
}


class GiftsInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [

                 SizedBox(width: 10,),

               Text(
                 'How Gifts works?',
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 20.0,
                 ),
               ),
               InkWell(
                   onTap: () {
                     Navigator.pop(context);
                   },
                   child: Icon(Icons.cancel,size: 30,))

             ],),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               SizedBox(height: 16.0),
               Text(
                 '1. Gifts are virtual.',
                 style: TextStyle(fontSize: 16.0),
               ),
               SizedBox(height: 8.0),
               Text(
                 '2. Gifts are voluntary & non-refundable.',
                 style: TextStyle(fontSize: 16.0),
               ),
               SizedBox(height: 8.0),
               Text(
                 '3. Company doesn\'t guarantee any service in exchange of gifts.',
                 style: TextStyle(fontSize: 16.0),
               ),
               SizedBox(height: 8.0),
               Text(
                 '4. Gifts can be encashed by the astrologer in monetary terms as per company policies.',
                 style: TextStyle(fontSize: 16.0),
               ),
             ],),
           )

         ],
       );

  }
}