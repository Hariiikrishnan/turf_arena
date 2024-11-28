import 'package:turf_arena/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader(this.userDetails);

  Map userDetails;
  // User? user = userDetails.user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          userDetails['displayName'] ?? userDetails['email'] ?? "",
          style: TextStyle(
            color: whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(
            userDetails['photoURL'],
          ),
        ),
      ],
    );
  }
}
