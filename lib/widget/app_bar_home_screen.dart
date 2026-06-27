import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color backgroundColor;
  final Color iconColor;
  final String logoPath;
  final String titleImagePath;
  final String walletIconPath;
  final String supportIconPath;
  final Function()? onWalletTap;
  final Function()? onSupportTap;
  final bool isWalletVisible;
  final String? walletAmount;

  const CustomAppBar({
    Key? key,
    required this.height,
    required this.backgroundColor,
    required this.iconColor,
    required this.logoPath,
    required this.titleImagePath,
    required this.walletIconPath,
    required this.supportIconPath,
    this.onWalletTap,
    this.onSupportTap,
    this.isWalletVisible = true,
    this.walletAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              IconButton(
                padding: const EdgeInsets.only(left: 10),
                onPressed: (){

                    Scaffold.of(context).openDrawer(); // Fixed context issue
                  },

                icon: SvgPicture.asset(
                  'assets/images/lines_three.svg',
                  height: 18,
                  width: 18,
                  color: iconColor,
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  logoPath,
                  height: 25,
                  width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        },
      ),
      leadingWidth: screenWidth * 0.35,
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      backgroundColor: backgroundColor,
      title: Image.asset(
        titleImagePath,
        height: 20,
        width: screenWidth * 0.3,
      ),
      actions: [
        if (isWalletVisible)
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onWalletTap,
              child: Image.asset(
                walletIconPath,
                height: 20,
                width: 20,
                color: iconColor,
              ),
            ),
          ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onSupportTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, right: 6),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  supportIconPath,
                  height: 25,
                  width: 25,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
