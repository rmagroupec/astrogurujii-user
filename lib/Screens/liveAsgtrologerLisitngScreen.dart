import 'package:astro_gurujii/Screens/Models/live_listing/live_listing_reponse.dart';
import 'package:astro_gurujii/Setup/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../Setup/SetUp.dart';
import '../../Utilities/CustomText.dart';
import '../widget/bottom_navigation_bar_custom.dart';
import 'WebServices/HttpServices.dart';
import 'live/LiveVideoCallScreen.dart';

class LiveAstroLogersScreen extends StatefulWidget {
  LiveAstroLogersScreen({Key? key}) : super(key: key);

  @override
  State<LiveAstroLogersScreen> createState() => _LiveAstroLogersScreenState();
}

class _LiveAstroLogersScreenState extends State<LiveAstroLogersScreen>
    with SingleTickerProviderStateMixin {
  final HttpServices _httpServices = HttpServices();
  List<Data> liveAstrologersList = [];
  bool isLoading = false;
  late TabController _tabController;

  List<Data> get liveList =>
      liveAstrologersList.where((e) => e.isLive == "1").toList();
  List<Data> get upcomingList =>
      liveAstrologersList.where((e) => e.isLive != "1").toList();

  void getLiveAstrologer() async {
    setState(() => isLoading = false);
    var res = await _httpServices.getLiveListing();
    if (res?.status == true) {
      setState(() {
        liveAstrologersList = res!.data!;
        isLoading = true;
      });
    } else {
      Fluttertoast.showToast(msg: res?.message ?? "Something went wrong");
      setState(() => isLoading = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getLiveAstrologer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToLive(Data astro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveVideoCallScreen(
          screenType: "home",
          id: astro.sId,
          channelName: astro.channelId.toString(),
          astrologerId: astro.astrologerId!.sId.toString(),
          astrologerName: astro.astrologerId!.displayName.toString(),
          astrologerImage: astro.astrologerId!.profileImg.toString(),
        ),
      ),
    ).then((_) {
      getLiveAstrologer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainHomeScreenWithBottomNavigation(),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F4FF),
        appBar: _buildAppBar(),
        body: isLoading ? _buildBody() : _buildLoading(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      title: const Text(
        "Live Astrologers",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0.3,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: getLiveAstrologer,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            labelColor: primaryColor,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const Text("Live"),
                  ],
                ),
              ),
              const Tab(text: "Upcoming"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildGrid(liveList, isLiveTab: true),
        _buildGrid(upcomingList, isLiveTab: false),
      ],
    );
  }

  Widget _buildGrid(List<Data> list, {required bool isLiveTab}) {
    if (list.isEmpty) {
      return _buildEmptyState(isLiveTab);
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) => _buildCard(list[index]),
    );
  }

  Widget _buildCard(Data astro) {
    final bool isLive = astro.isLive == "1";
    final String name = astro.astrologerId?.name?.toString() ?? "";
    final String displayName =
        astro.astrologerId?.displayName?.toString() ?? name;
    final String imageUrl =
        astro.astrologerId?.profileImg?.toString() ?? "";

    return GestureDetector(
      onTap: () {
        if (isLive) {
          _navigateToLive(astro);
        } else {
          Fluttertoast.showToast(msg: "Session not started yet");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _shimmerPlaceholder(),
                      loadingBuilder: (_, child, progress) =>
                          progress == null ? child : _shimmerPlaceholder(),
                    ),
                  ),
                  // Gradient overlay
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Live / Upcoming badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildBadge(isLive),
                  ),
                  // Watch now button for live
                  if (isLive)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayName.isNotEmpty ? displayName : name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isLive &&
                        astro.startTime != null &&
                        astro.endTime != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              "${astro.startTime} - ${astro.endTime}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(bool isLive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLive ? Colors.red : const Color(0xFF6C63FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isLive ? Colors.red : const Color(0xFF6C63FF))
                .withOpacity(0.4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive) ...[
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
          Text(
            isLive ? "LIVE" : "SOON",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isLiveTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLiveTab
                  ? Icons.live_tv_rounded
                  : Icons.calendar_today_rounded,
              size: 52,
              color: primaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isLiveTab ? "No one is live right now" : "No upcoming sessions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLiveTab
                ? "Check back soon for live sessions"
                : "Sessions will appear here when scheduled",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: getLiveAstrologer,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.grey.shade300),
    );
  }
}