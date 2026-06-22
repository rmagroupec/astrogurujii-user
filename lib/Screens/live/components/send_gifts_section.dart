import 'package:flutter/material.dart';

import 'gifts_icons.dart';

class SendGiftsSection extends StatefulWidget {
  final String to_user_id;
  final String room_id;
  final String transaction_for;

  const SendGiftsSection(
      {Key? key,
      required this.to_user_id,
      required this.room_id,
      required this.transaction_for})
      : super(key: key);

  @override
  State<SendGiftsSection> createState() => _SendGiftsSectionState();

  static showSendGiftsBottomSheet({
    required BuildContext context,
    required String to_user_id,
    required String transaction_for,
    required String room_id,
  }) =>
      showModalBottomSheet(
        // backgroundColor: Color(0xFF82858C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        context: context,
        builder: (context) => SendGiftsSection(
          to_user_id: to_user_id,
          room_id: room_id,
          transaction_for: transaction_for,
        ),
      );
}

class _SendGiftsSectionState extends State<SendGiftsSection> {
  @override
  void initState() {
    initFunction();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Color(0xFF121119), // Set the background color here
          ),
          child: Column(
            children: [
              // BlocBuilder<WalletBloc, WalletState>(
              //   builder: (context, state) {
              //     return
                    Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // state.walletModel == null
                      //     ? SizedBox()
                      //     :
                      Text(
                              // '${state.walletModel!.data!.balance.toString()}',
                              'eretr',
                              style: TextStyle(color: Colors.white),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.diamond_sharp,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
              //   },
              // ),
              TabBar(
                // tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicator: BoxDecoration(),
                // Set indicator to null
                indicatorWeight: 0.0,
                // Set indicatorWeight to 0.0
                labelStyle: TextStyle(
                  color: Color(0xFFFFA801),
                ),
                unselectedLabelColor: Color(0xFF82858C),
                // dividerColor: Color(0xFF121119),
                tabs: [
                  Tab(
                    child: Text(
                      'Gift',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Segoe UI',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Lucky',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Segoe UI',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Taste',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Segoe UI',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Fans club',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Segoe UI',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GiftsIcons(
                      to_user_id: widget.to_user_id,
                      room_id: widget.room_id,
                      transaction_for: widget.transaction_for.toString(),
                    ),
                    GiftsIcons(
                      to_user_id: widget.to_user_id,
                      room_id: widget.room_id,
                      transaction_for: widget.transaction_for.toString(),
                    ),
                    GiftsIcons(
                      to_user_id: widget.to_user_id,
                      room_id: widget.room_id,
                      transaction_for: widget.transaction_for.toString(),
                    ),
                    GiftsIcons(
                      to_user_id: widget.to_user_id,
                      room_id: widget.room_id,
                      transaction_for: widget.transaction_for.toString(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initFunction() {
    // final joinLiveVideoBloc = context.read<JoinLiveVideoBloc>();
    // final walletBloc = context.read<WalletBloc>();
    //
    // walletBloc.add(WalletApi());
    // joinLiveVideoBloc.add(GetGifts());
  }
}
