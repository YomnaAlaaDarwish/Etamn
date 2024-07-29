import 'user_model.dart';
import 'package:flutter/material.dart';
import 'models/Patient.dart';
import 'Profile.dart';

class ProfileIcon extends StatelessWidget {
 final Patient user;

  ProfileIcon({required this.user});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right: 30,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Profile(user: user,)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black)
            ),
            child: ClipOval(
              child: Image.asset('assets/profile.png', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

