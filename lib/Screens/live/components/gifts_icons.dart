import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class GiftsIcons extends StatefulWidget {
  final String to_user_id;
  final String room_id;
  final String transaction_for;

  const GiftsIcons(
      {
      required this.to_user_id,
      required this.room_id,
      required this.transaction_for});

  @override
  State<GiftsIcons> createState() => _GiftsIconsState();
}

class _GiftsIconsState extends State<GiftsIcons> {
  @override
  Widget build(BuildContext context) {
    return
      // BlocBuilder<JoinLiveVideoBloc, JoinLiveVideoState>(
      // builder: (context, state) {
      //   return state.gifts == null
      //       ? SizedBox()
      //       :

        GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Animate(
                    effects: [
                      FadeEffect(
                          delay: Duration(microseconds: 1000),
                          duration: Duration(milliseconds: 500)),
                      ScaleEffect(
                          delay: Duration(microseconds: 1000),
                          duration: Duration(milliseconds: 500))
                    ],
                    child:

                    IconList(
                      title: "",
                      icon: "",
                      coins:"" ,
                      gift_id: "",
                      room_id:"" ,
                      to_user_id:"" ,
                      transaction_for:"" ,

                      // coins: state.gifts!.gift![index].coins.toString(),
                      // to_user_id: widget.to_user_id.toString(),
                      // room_id: widget.room_id.toString(),
                      // gift_id: state.gifts!.gift![index].sId.toString(),
                      // icon: state.gifts!.gift![index].icon,
                      // title: state.gifts!.gift![index].name,
                      // transaction_for: widget.transaction_for.toString(),
                    ),
                  );
                },
              );
    //   },
    // );
  }
}

class IconList extends StatefulWidget {
  final String coins;
  final String to_user_id;
  final String room_id;
  final String gift_id;
  final String icon;
  final String title;
  final String transaction_for;

  const IconList({
    required this.coins,
    required this.to_user_id,
    required this.room_id,
    required this.gift_id,
    required this.icon,
    required this.title,
    required this.transaction_for,
  });

  @override
  State<IconList> createState() => _IconListState();
}

class _IconListState extends State<IconList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // final joinLiveVideoBloc = context.read<JoinLiveVideoBloc>();
        //
        // joinLiveVideoBloc.add(SendGifts(
        //     to_user_id: widget.to_user_id,
        //     room_id: widget.room_id,
        //     gift_id: widget.gift_id,
        //     context: context,
        //     transaction_for: widget.transaction_for));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              widget.icon,
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.width * 0.18,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.24,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/coins.png",
                height: 10,
                width: 10,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.coins.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFA801),
                  fontSize: 10,
                  fontFamily: 'Segoe UI',
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.24,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
