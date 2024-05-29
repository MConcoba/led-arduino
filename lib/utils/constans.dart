import 'package:flutter/material.dart';

const int min = 1;
const int max = 5;

const String nextString = "Next Floor: ";


const int openTime = 10;   //[sec]
const int waitTime = 3;    //[sec]
const int flashTime = 500; //[msec]

final List<bool> openedState = [true, false, false, false];
final List<bool> closedState = [false, true, false, false];
final List<bool> openingState = [false, false, true, false];
final List<bool> closingState = [false, false, false, true];

const List<int> floors1 = [3,4];
const List<int> floors2 = [1,2];

const List<bool> isFloors1 = [true, true];
const List<bool> isFloors2 = [true, true];

// Tamaño display
const double displayMarginRate = 0.09;
const double displayPaddingRate = 0.003;
const double displayHeightRate = 0.15;
const Color darkBlackColor = Colors.black;
const double displayArrowWidthRate = 0.08;
const double displayArrowHeightRate = 0.08;
const double displayNumberWidthRate = 0.24;
const double displayNumberHeightRate = 0.14;
const double shimadaLogoHeightRate = 0.10;

const double operationButtonSizeRate = 0.070;
const double operationButtonPaddingRate = 0.005;

//Tama;ioi  butons
const double buttonMarginRate = 0.025;
const double floorButtonSizeRate = 0.120;
const double buttonNumberFontSizeRate = 0.025;
const double buttonBorderWidthRate = 0.007;
const double buttonBorderRadiusRate = 0.015;

// Colores
const Color yellowColor = Color.fromRGBO(255, 234, 0, 1);
const Color greenColor = Color.fromRGBO(105, 184, 0, 1);
const Color grayColor = Colors.grey;
const Color lampColor = Color.fromARGB(255, 247, 178, 73);
const Color blackColor = Color.fromRGBO(56, 54, 53, 1);
const Color transpColor = Colors.transparent;
const Color whiteColor = Colors.white;


const Color metalColor1 = Colors.black12;
const Color metalColor2 = Colors.white24;
const Color metalColor3 = Colors.white54;
const Color metalColor4 = Colors.white10;
const Color metalColor5 = Colors.black12;
const List<Color> metalColor = [
  metalColor1,
  metalColor2,
  metalColor3,
  metalColor4,
  metalColor5
];
const List<double> metalSort = [0.1, 0.3, 0.4, 0.7, 0.9];

//files
const String buttons = "assets/images/normalMode/";
const String assets1000 = "assets/images/1000Mode/";
const String numberFont = "teleIndicators";


const String pressedCircle = "${buttons}pressedCircle.png";
const String circleButton = "${buttons}button.png";
const String upArrow = "${buttons}up.png";
const String downArrow = "${buttons}down.png";
const String buttonChan = "${buttons}button.png";
const String transpImage = "${buttons}transparent.png";
const String imgBlack = "${buttons}transparents.png";

const String shimadaOpen = "${buttons}sOpen.png";
const String pressedShimadaOpen = "${buttons}sPressedOpen.png";
const String shimadaClose = "${buttons}sClose.png";
const String pressedShimadaClose = "${buttons}sPressedClose.png";
const String shimadaAlert = "${buttons}sPhone.png";
const String pressedShimadaAlert = "${buttons}sPressedPhone.png";
const String pressedCloseButton = "${buttons}pressedClose.png";
const String closeButton = "${buttons}close.png";
const String alertButton = "${buttons}phone.png";
const String pressedAlertButton = "${buttons}pressedPhone.png";
const String openButton = "${buttons}open.png";
const String pressedOpenButton = "${buttons}pressedOpen.png";
const String pressedButtonChan = "${buttons}pButton.png";
const String shimadaImage = "${buttons}shimada.png";