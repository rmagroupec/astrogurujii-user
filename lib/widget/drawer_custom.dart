import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDrawer extends StatelessWidget {
  final String name;
  final String image;
  final Function()? onProfileTap;
  final Function()? onTransactionTap;
  final Function()? onWalletTap;
  final Function()? onFollowingTap;
  final Function()? onPoojaBookingsTap;
  final Function()? onAstromallBookingsTap;
  final Function()? onSupportTap;
  final Function()? onRegistrationTap;
  final Function()? onReferTap;
  final Function()? onAboutUsTap;
  final Function()? onPrivacyPolicyTap;
  final Function()? onTermsTap;
  final Function()? onLogoutTap;
  final Function()? onAppleTap;
  final Function()? onWebTap;
  final Function()? onYouTubeTap;
  final Function()? onFaceBookTap;
  final Function()? onInstagramTap;
  final Function()? onLinkedLnTap;
  final String version;

  const CustomDrawer({
    Key? key,
    required this.name,
    required this.image,
    this.onProfileTap,
    this.onTransactionTap,
    this.onWalletTap,
    this.onFollowingTap,
    this.onPoojaBookingsTap,
    this.onAstromallBookingsTap,
    this.onSupportTap,
    this.onRegistrationTap,
    this.onReferTap,
    this.onAboutUsTap,
    this.onPrivacyPolicyTap,
    this.onTermsTap,
    this.onLogoutTap,
    this.version = "1.0.0", this.onAppleTap, this.onWebTap, this.onYouTubeTap, this.onFaceBookTap, this.onInstagramTap, this.onLinkedLnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Drawer(
      child: ListView(
        children: [
          // Profile Section
          InkWell(
            onTap: onProfileTap,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.orange,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: image.isEmpty
                          ? const AssetImage("assets/profile/name.png")
                          : NetworkImage(image) as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi $name",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "View your details",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, color: Colors.orange),

          // Drawer Items
          _buildDrawerItem(
            icon: "assets/d_icons/my_transaction_icon.png",
            label: "My Transaction",
            onTap: onTransactionTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/my_wallet_icon.png",
            label: "My Wallet",
            onTap: onWalletTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/my_following.png",
            label: "My Following",
            onTap: onFollowingTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/my_orders.png",
            label: "Puja Bookings",
            onTap: onPoojaBookingsTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/astro_mall.png",
            label: "Astromall Bookings",
            onTap: onAstromallBookingsTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/support_icon.png",
            label: "Customer Support",
            onTap: onSupportTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/astro_ragistration.png",
            label: "Astrologer Registration",
            onTap: onRegistrationTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/refer_icon.png",
            label: "Refer a Friend",
            onTap: onReferTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/about_us_icon.png",
            label: "About Us",
            onTap: onAboutUsTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/pravicy_icon.png",
            label: "Privacy Policy",
            onTap: onPrivacyPolicyTap,
            width: width,
          ),
          _buildDrawerItem(
            icon: "assets/d_icons/t_and_c_icon.png",
            label: "Terms & Conditions",
            onTap: onTermsTap,
            width: width,
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextButton(
              onPressed: onLogoutTap,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/Icons/drawer/log.svg',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFFF7C5D),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(thickness: 1, color: Colors.orange),

          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap:onAppleTap,

                child: Container(
                    margin: EdgeInsets.all(5),
                    height: 28,
                    width: 28,
                    child: Image.asset("assets/d_icons/apple_icon.png")),
              ),
              InkWell(
                onTap:onWebTap,
                child: Container(
                    margin: EdgeInsets.all(5),
                    height: 28,
                    width: 28,
                    child: Image.asset("assets/d_icons/website.png")),
              ),
              InkWell(
                onTap:onYouTubeTap,
                child: Container(
                    margin: EdgeInsets.all(5),
                    height: 28,
                    width: 28,
                    child: Image.asset("assets/d_icons/youtube.png")),
              ),
              InkWell(
                onTap: onFaceBookTap,
                child: Container(
                    margin: EdgeInsets.all(5),
                    height: 28,
                    width: 28,
                    child: Image.asset("assets/d_icons/facebook.png")),
              ),
              InkWell(
                onTap: onInstagramTap,
                child: Container(
                    margin: EdgeInsets.all(5),
                    height: 28,
                    width: 28,
                    child: Image.asset("assets/d_icons/instagram.png")),
              ),
              InkWell(
                onTap: onLinkedLnTap,
                child: Container(
                    margin: EdgeInsets.all(5),
                    height: 28,
                    width: 28,
                    child: Image.asset("assets/d_icons/linkedin.png")),
              ),
            ],
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Text(
              "Version $version",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required String icon,
    required String label,
    required Function()? onTap,
    required double width,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 5),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Image.asset(icon),
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 14,
              width: 14,
              child: Image.asset("assets/d_icons/arrow_right_icon.png"),
            ),
          ],
        ),
      ),
    );
  }
}
