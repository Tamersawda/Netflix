import 'package:flutter/material.dart';
import 'package:netflix_app/pages/search_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.accountId});
  final int accountId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'My Netflix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: Icon(Icons.search),
            iconSize: 40,
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list_rounded),
            iconSize: 40,
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: SizedBox(
                height: 180,
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/walp.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tamer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.expand_more_sharp, color: Colors.white, size: 38),
              ],
            ),
        
          ],
        ),
      ),
    );
  }
}
