import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/constants/consts.dart';

class SetProfileIcon extends StatefulWidget {
  const SetProfileIcon({super.key});

  @override
  State<SetProfileIcon> createState() => _SetProfileIconState();
}

class _SetProfileIconState extends State<SetProfileIcon> {
  int selectedIndex = -1;
  
  @override
  Widget build(BuildContext context) {

    List<String> avatarImageList = [];
    for (int i = 1; i <= 11; i++) {
      avatarImageList.add('assets/images/avatar$i.png');
    }
    final user = FirebaseAuth.instance.currentUser;
    String? selectedAvatar = selectedIndex >= 0 ? avatarImageList[selectedIndex] : '';
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(50),
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Text(
                'Select your profile Icon',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: null,
              itemCount: avatarImageList.length,
              itemBuilder: (BuildContext context, int index) {
                final isSelected = (selectedIndex == index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      selectedAvatar = avatarImageList[index];
                    });
                  },
                  child: Center(
                    child: Container(
                      width: 160,
                      height: 200,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? primaryColor
                                : Colors.transparent,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: isSelected ? primaryColor : Colors.transparent,
                          width: 6,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(avatarImageList[index]),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: primaryColor,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
            Spacer(),
            IconButton(
              onPressed: () async {
                if (selectedIndex == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select an avatar')),
                  );
                  return;
                }
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .set({'avatar': selectedAvatar!}, SetOptions(merge: true));
                  Navigator.pushNamed(context, 'chatsProfile');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving avatar: $e')),
                  );
                }
              },
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
