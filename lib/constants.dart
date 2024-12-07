import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color secondaryColor = Color(0xFF1E293B);
const Color whiteColor = Color(0XFFFFFFFF);

const Color primaryColor = Color(0xFF000000);
const Color greyColor = Color(0XFFD9D9D9);

Color color1 = Color(0xFFFFCB79);
Color color2 = Color(0xFFFFCB79);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter Turf Name',
  hintStyle: TextStyle(
    color: whiteColor,
  ),
  suffixIcon: Icon(Icons.search),

  suffixIconColor: whiteColor,
  // suffixIcon: CircleAvatar(
  //   backgroundColor: whiteColor,
  //   child: Icon(Icons.menu),
  // ),
  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 25.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: whiteColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: whiteColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  fillColor: Colors.black26,
  focusColor: whiteColor,

  filled: true,
);
const kLoginFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(
    color: primaryColor,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secondaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secondaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  fillColor: whiteColor,
  filled: true,
);

const kOtpDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: primaryColor,
  ),

  // hintText: "0",
  // prefixIcon: Icon(Icons.search),
  // prefixIconColor: greyColor,
  // suffixIcon: CircleAvatar(
  //   backgroundColor: whiteColor,
  //   child: Icon(Icons.menu),
  // ),
  // contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 5.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 4.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  fillColor: greyColor,
  filled: true,
);
