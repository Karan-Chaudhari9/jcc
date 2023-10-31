import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jcc/common/widget/menu_drawer.dart';
import 'dart:developer' as dev;
import 'package:jcc/config/router.dart';
import 'package:jcc/constants/string_constants.dart';
import 'package:jcc/features/home/widgets/data_card.dart';
import 'package:jcc/features/home/widgets/data_chart.dart';
import 'package:jcc/features/home/widgets/recent_complaints_card.dart';
import 'package:jcc/generated/assets.dart';
import 'package:jcc/theme/colors.dart';

import '../../../common/widget/scroll_to_hide_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.bottomNavKey,
  });

  final ScrollController controller;
  final GlobalKey<ScrollToHideWidgetState> bottomNavKey;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<ComplaintStateData> complaintStateData = [
    ComplaintStateData(ComplaintStateDataConstants.complaintState[0],
        "12,33,23,233", 39.43, AppColors.brightTurquoise),
    ComplaintStateData(ComplaintStateDataConstants.complaintState[1],
        "32,44,89,329", 40.60, AppColors.monaLisa),
    ComplaintStateData(ComplaintStateDataConstants.complaintState[2],
        "22,53,88,984", 28.88, AppColors.heliotrope),
    ComplaintStateData(ComplaintStateDataConstants.complaintState[3],
        "98,23,54,898", 88.09, AppColors.mantis),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuDrawer(),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          if (widget.bottomNavKey.currentState != null) {
            dev.log('State is not null', name: 'Home');
            if (widget.bottomNavKey.currentState!.isVisible) {
              widget.bottomNavKey.currentState!.hide();
            }
          } else {
            dev.log('State is null', name: 'Home');
          }
        }else {
          if (widget.bottomNavKey.currentState != null) {
            dev.log('State is not null', name: 'Home');
            if (!widget.bottomNavKey.currentState!.isVisible) {
              widget.bottomNavKey.currentState!.show();
            }
          } else {
            dev.log('State is null', name: 'Home');
          }
        }
      },
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                dev.log(MediaQuery.of(context).size.width.toString());
                dev.log(MediaQuery.of(context).size.height.toString());
                Scaffold.of(context).openDrawer();
              },
              icon: SvgPicture.asset(
                Assets.iconsMenu,
                fit: BoxFit.cover,
              )),
        ),
        title: Text(CommonDataConstants.home,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(fontSize: 22)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.iconsSearch),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      DataCard(
                          index: 0, complaintStateData: complaintStateData),
                      DataCard(
                          index: 1, complaintStateData: complaintStateData),
                    ],
                  ),
                  Row(
                    children: [
                      DataCard(
                          index: 2, complaintStateData: complaintStateData),
                      DataCard(
                          index: 3, complaintStateData: complaintStateData),
                    ],
                  )
                ],
              ),
            ),
            Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Container(
                  height: 360,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: AppColors.platinum,
                  ),
                  child: Center(
                      child: DataChart(complaintStateData: complaintStateData)),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                ScreensDataConstants.recentTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              clipBehavior: Clip.hardEdge,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(15)),
              //   // child: Column(
              //   //   children: List.generate(10, (index) => RecentComplaintsCard(index: index)),
              //   // ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemBuilder: (context, index) {
                  return RecentComplaintsCard(index: index);
                },
              ),
            ),
            const SizedBox(
              height: 92,
            )
          ],
        ),
      ),
    );
  }
}

class ComplaintStateData {
  ComplaintStateData(this.complaintState, this.complaintDataInNumber,
      this.complaintsDataInPercentage, this.color);

  final String complaintState;
  final String complaintDataInNumber;
  final double complaintsDataInPercentage;
  final Color color;
}