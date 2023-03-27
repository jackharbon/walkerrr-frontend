// ignore_for_file: constant_identifier_names

import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';

class GlobalStyleVariables {
  //  Primary colors
  static const primaryAppBarColour = Color(0xff7776bc);
  static const primaryBottomBarColour = Color(0xffeff0d1);
  static const primaryBackgroundColour = Color(0xfff3feff);
  static const primaryBackgroundGradientColour = Color(0xffeefeff);
  static const primaryAccentColor = Color(0xfff18f01);
  static const primaryTextDarkColour = Color(0xff000000);
  static const primaryTextLightColour = Color(0xffffffff);
  static const primaryTextErrorColour = Color(0xffa30015);

  // Standard Buttons
  static const buttonGreenActive = Color(0xff5eb336);
  static const buttonGreenInactive = Color(0xff80cb61);
  static const buttonRedActive = Color(0xffa30015);
  static const buttonRedInactive = Color(0xffd56aa0);
  static const buttonRedBackground = Color(0xffffbeb0);
  static const buttonBlueActive = Color(0xff265eb1);
  static const buttonBlueInactive = Color(0xffa9c8e7);
  static const buttonGreyActive = Color(0xff7593af);
  static const buttonGreyInactive = Color(0xffd1dbe4);

  // Form Fields
  static const formActive = Color(0xfffcf0cc);

  // Quest Page Blue
  static const questsButtonReady = Color(0xffc6a3dc);
  static const questsButtonActive = Color(0xff7503b8);
  static const questsButtonInactive = Color(0xffd1dbe4);
  static const questsButtonFinished = Color(0xff5eb336);
  static const questsButtonClaimed = Color(0xff839788);
  static const questsProgressBar = Color(0xffa767cd);
  static const questsProgressBarBackground = Color(0xffdbdfff);
  static const questsProgressBarInactiveBackground = Color(0xffd1dbe4);
  static const questsDivider = Color(0xffdbc9e5);

  // Steps Page Green
  static const stepsPlusMenuBackgroundColour = Color(0xffeff0d1);
  static const stepsPlusMenuTextColour = Color(0xff000000);
  static const stepsInventoryMenuColour = Color(0xffeff0d1);
  static const stepsShopMenuColour = Color(0xffeff0d1);

  //Inventory & Shop Page Brown
  static const equipmentAppBarColour = Color(0xff7503b8);
  static const equipmentButtonActiveColour = Color(0xff7503b8);
  static const equipmentButtonInactiveColour = Color(0xffdbb8b2);
  static const equipmentBackgroundColour = Color(0xffd9d7dd);
  static const equipmentItemBackgroundColour = Color(0xffdbf9f4);
  static const equipmentItemBorderColour = Color(0xff7503b8);
}

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';
  static const String? _kFontPkg = null;

  static const IconData icon_add =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData icon_x =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
