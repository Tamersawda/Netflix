import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:netflix_app/pages/home_page.dart';
import 'package:netflix_app/pages/new_&_how.dart';
import 'package:netflix_app/pages/my_netflix.dart';
import 'package:netflix_app/services/api_key.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                border: Border(
                  top:BorderSide(color: Colors.white.withOpacity(0.1), width: 1.0)
                )
              ),
              height: 70,
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Iconsax.home5), text: 'Home'),
                  Tab(icon: Icon(Icons.photo_library_outlined), text: 'Hot News'),
                  Tab(icon: Icon(Icons.person), text: 'My Netflix'),
                ],
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.white,
                indicatorColor: Colors.transparent,
              ),
            ),
          ),
        ),
        body: TabBarView(children: [HomePage(), NewHot(), ProfilePage(accountId: accountId,)]),
        
      ),
    );
  }
}
