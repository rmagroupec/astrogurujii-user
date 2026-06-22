import 'package:astro_gurujii/Screens/transection_screen/transactionGiftModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../WebServices/HttpServices.dart';

class GiftTransactionScreen extends StatefulWidget {
  const GiftTransactionScreen();

  @override
  State<GiftTransactionScreen> createState() => _GiftTransactionScreenState();
}

class _GiftTransactionScreenState extends State<GiftTransactionScreen> {
  HttpServices _httpService = HttpServices();

 List<Gifts> giftList=[];

  bool isLoading=false;

  callWebServiceGiftList() async {
    setState(() {
      isLoading = true;
    });

    var res = await _httpService.giftTransaction();
    if (res!.status == true) {
      // other = res.transactions.data;
      giftList=res.gifts!;
    }
    print("giftList=====>>> ${giftList}");
    print("giftList=====>>> ${giftList[0].amount}");
    setState(() {
      isLoading = false;
    });
  }


 @override
  void initState() {
    callWebServiceGiftList();
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: giftList.length,
        itemBuilder: (context, index) {
          final transaction = giftList[index];
          return GiftTransactionCard(transaction: transaction);
        },
      ),
    );
  }
}

class GiftTransactionCard extends StatelessWidget {
  final Gifts transaction;

  GiftTransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: 
        
        
        Row(
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'From: ${transaction.fromUser!.name??""}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'To: ${transaction.toAstro!.displayname??""}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Gift: ${transaction.type??""}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Amount:  ₹ ${transaction.amount!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            
            ClipOval(
              child: Image.network(transaction.gift!.image.toString(),
              height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }
}

