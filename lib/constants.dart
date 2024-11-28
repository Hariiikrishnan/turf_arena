import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color secondaryColor = Color(0xFF1E293B);
const Color whiteColor = Color(0XFFFFFFFF);
const Color primaryColor = Color(0XFF000000);
const Color greyColor = Color(0XFFD9D9D9);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(
    color: primaryColor,
  ),
  prefixIcon: Icon(Icons.search),
  prefixIconColor: primaryColor,
  suffixIcon: CircleAvatar(
    backgroundColor: whiteColor,
    child: Icon(Icons.menu),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secondaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secondaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  fillColor: whiteColor,
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
    color: greyColor,
  ),
  // prefixIcon: Icon(Icons.search),
  // prefixIconColor: greyColor,
  // suffixIcon: CircleAvatar(
  //   backgroundColor: whiteColor,
  //   child: Icon(Icons.menu),
  // ),
  contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 30.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  fillColor: greyColor,
  filled: true,
);
