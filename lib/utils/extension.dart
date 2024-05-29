import 'package:flutter/material.dart';
import 'package:hcled/utils/constans.dart';
import 'package:flutter/foundation.dart';

extension ContextExt on BuildContext {
  ///Common
  double width() => MediaQuery.of(this).size.width;
  double height() => MediaQuery.of(this).size.height;
  String lang() => Localizations.localeOf(this).languageCode;

  ///Responsible
  double responsible() => (height() < 1000) ? height() : 1000;
  double widthResponsible() => (width() < 600) ? width() : 600;
  double widthResponsible2() => (width() < 1000) ? width() : 1000;

  //Display
  double displayWidth() => widthResponsible();
  double displayMargin() => responsible() * displayMarginRate;
  double displayPadding() => responsible() * displayPaddingRate;
  double displayHeight() => responsible() * displayHeightRate;
  double displayArrowWidth() => responsible() * displayArrowWidthRate;
  double displayArrowHeight() => responsible() * displayArrowHeightRate;
  double displayNumberWidth() => responsible() * displayNumberWidthRate;
  double displayNumberHeight() => responsible() * displayNumberHeightRate;
  double shimadaLogoHeight() => responsible() * shimadaLogoHeightRate;

  //Button
  double buttonMargin() => responsible() * buttonMarginRate;
  double floorButtonSize() => responsible() * floorButtonSizeRate;
  double buttonNumberFontSize() => responsible() * buttonNumberFontSizeRate;
  double operationButtonSize() => responsible() * operationButtonSizeRate;
  double operationButtonPadding() => responsible() * operationButtonPaddingRate;
  double buttonBorderWidth() => responsible() * buttonBorderWidthRate;
  double buttonBorderRadius() => responsible() * buttonBorderRadiusRate;

  ///Admob
  double admobHeight() => (height() < 600)
      ? 50
      : (height() < 1000)
          ? 50 + (height() - 600) / 8
          : 100;
  double admobWidth() => width() - 100;

  //String pushNumber() => AppLocalizations.of(this)!.pushNumber;
}

extension StringExt on String {
  ///Common
  void debugPrint() {
    if (kDebugMode) print(this);
  }
}

extension IntExt on int {
  String displayNumber() => (this == max)
      ? max.toString()
      : (this == 0)
          ? '0'
          : (this < 0)
              ? "B${abs()}"
              : "$this";

  ///Button
//this is i
  String numberBackground(bool isShimada, isSelected) => (!isShimada)
      ? ((isSelected) ? pressedCircle : circleButton)
      : (this == max)
          ? "$assets1000${isSelected ? "pR.png" : "R.png"}"
          : (this > 0)
              ? "$assets1000${isSelected ? "p$this.png" : "$this.png"}"
              : "$assets1000${(isSelected) ? "pB${abs()}.png" : "B${abs()}.png"}";

  String buttonNumber(bool isShimada) => (isShimada)
      ? ""
      : (this == max)
          ? "R"
          : (this == 0)
              ? "G"
              : (this < 0)
                  ? "B${abs()}"
                  : "$this";

  //this is i and counter.
  bool isSelected(List<bool> isAboveSelectedList, isUnderSelectedList) =>
      (this > 0) ? isAboveSelectedList[this] : isUnderSelectedList[this * (-1)];

  void trueSelected(List<bool> isAboveSelectedList, isUnderSelectedList) {
    if (this > 0) isAboveSelectedList[this] = true;
    if (this < 0) isUnderSelectedList[this * (-1)] = true;
  }

  String arrowImage(bool isMoving, int nextFloor, int position) =>
      //(isMoving && this < nextFloor)

      (isMoving && position == 1)
          ? upArrow
          : (isMoving && position == 0)
              ? downArrow
              : imgBlack;

  bool onlyTrue(List<bool> isAboveSelectedList, isUnderSelectedList) {
    bool listFlag = false;
    if (isSelected(isAboveSelectedList, isUnderSelectedList)) listFlag = true;
    if (this > 0) {
      for (int k = 0; k < isAboveSelectedList.length; k++) {
        if (k != this && isAboveSelectedList[k]) listFlag = false;
      }
      for (int k = 0; k < isUnderSelectedList.length; k++) {
        if (isUnderSelectedList[k]) listFlag = false;
      }
    }
    if (this < 0) {
      for (int k = 0; k < isUnderSelectedList.length; k++) {
        if (k != this * (-1) && isUnderSelectedList[k]) listFlag = false;
      }
      for (int k = 0; k < isAboveSelectedList.length; k++) {
        if (isAboveSelectedList[k]) listFlag = false;
      }
    }
    return listFlag;
  }

  void falseSelected(List<bool> isAboveSelectedList, isUnderSelectedList) {
    if (this > 0) isAboveSelectedList[this] = false;
    if (this < 0) isUnderSelectedList[this * (-1)] = false;
  }

  int upNextFloor(List<bool> isAboveSelectedList, isUnderSelectedList) {
    int nextFloor = max;
    for (int k = this + 1; k < max + 1; k++) {
      bool isSelected = k.isSelected(isAboveSelectedList, isUnderSelectedList);
      if (k < nextFloor && isSelected) nextFloor = k;
    }
    if (nextFloor == max) {
      bool isMaxSelected =
          max.isSelected(isAboveSelectedList, isUnderSelectedList);
      if (isMaxSelected) {
        nextFloor = max;
      } else {
        nextFloor = min;
        bool isMinSelected =
            min.isSelected(isAboveSelectedList, isUnderSelectedList);
        for (int k = min; k < this; k++) {
          bool isSelected =
              k.isSelected(isAboveSelectedList, isUnderSelectedList);
          if (k > nextFloor && isSelected) nextFloor = k;
        }
        if (isMinSelected) nextFloor = min;
      }
    }
    bool allFalse = true;
    for (int k = 0; k < isAboveSelectedList.length; k++) {
      if (isAboveSelectedList[k]) allFalse = false;
    }
    for (int k = 0; k < isUnderSelectedList.length; k++) {
      if (isUnderSelectedList[k]) allFalse = false;
    }
    if (allFalse) nextFloor = this;
    return nextFloor;
  }

  // this is counter
  int downNextFloor(List<bool> isAboveSelectedList, isUnderSelectedList) {
    int nextFloor = min;
    for (int k = min; k < this; k++) {
      bool isSelected = k.isSelected(isAboveSelectedList, isUnderSelectedList);
      if (k > nextFloor && isSelected) nextFloor = k;
    }
    if (nextFloor == min) {
      bool isMinSelected =
          min.isSelected(isAboveSelectedList, isUnderSelectedList);
      if (isMinSelected) {
        nextFloor = min;
      } else {
        nextFloor = max;
        bool isMaxSelected =
            max.isSelected(isAboveSelectedList, isUnderSelectedList);
        for (int k = max; k > this; k--) {
          bool isSelected =
              k.isSelected(isAboveSelectedList, isUnderSelectedList);
          if (k < nextFloor && isSelected) nextFloor = k;
        }
        if (isMaxSelected) nextFloor = max;
      }
    }
    bool allFalse = true;
    for (int k = 0; k < isAboveSelectedList.length; k++) {
      if (isAboveSelectedList[k]) allFalse = false;
    }
    for (int k = 0; k < isUnderSelectedList.length; k++) {
      if (isUnderSelectedList[k]) allFalse = false;
    }
    if (allFalse) nextFloor = this;
    return nextFloor;
  }

  List<int> upFromToNumber(int nextFloor) {
    List<int> floorList = [];
    for (int i = this + 1; i < nextFloor + 1; i++) {
      floorList.add(i);
    }
    return floorList;
  }

  int elevatorSpeed(int count, int nextFloor) {
    int l = (this - nextFloor).abs();
    return (count < 2 || l < 2)
        ? 2000
        : (count < 5 || l < 5)
            ? 1000
            : (count < 10 || l < 10)
                ? 500
                : (count < 20 || l < 20)
                    ? 250
                    : 100;
  }

  void clearLowerFloor(List<bool> isAboveSelectedList, isUnderSelectedList) {
    for (int j = min; j < this + 1; j++) {
      if (j > 0) isAboveSelectedList[j] = false;
      if (j < 0) isUnderSelectedList[j * (-1)] = false;
    }
  }

  List<int> downFromToNumber(int nextFloor) {
    List<int> floorList = [];
    for (int i = this - 1; i > nextFloor - 1; i--) {
      floorList.add(i);
    }
    return floorList;
  }

  void clearUpperFloor(List<bool> isAboveSelectedList, isUnderSelectedList) {
    for (int j = max; j > this - 1; j--) {
      if (j > 0) isAboveSelectedList[j] = false;
      if (j < 0) isUnderSelectedList[j * (-1)] = false;
    }
  }
}

extension BoolExt on bool {
  ///This is isShimada
  String buttonChanBackGround() => (this) ? pressedButtonChan : buttonChan;
  String shimadaLogo() => (this) ? shimadaImage : transpImage;

  String closeBackGround(bool isPressed) => (this)
      ? ((isPressed) ? pressedShimadaClose : shimadaClose)
      : ((isPressed) ? pressedCloseButton : closeButton);

  String phoneBackGround(bool isPressed) => (this)
      ? ((isPressed) ? pressedShimadaAlert : shimadaAlert)
      : ((isPressed) ? pressedShimadaAlert : alertButton);

  String openBackGround(bool isPressed) => (this)
      ? ((isPressed) ? pressedShimadaOpen : shimadaOpen)
      : ((isPressed) ? pressedOpenButton : openButton);

  String operateBackGround(String operate, bool isPressed) =>
      (operate == "alert")
          ? phoneBackGround(isPressed)
          : (operate == "open")
              ? openBackGround(isPressed)
              : closeBackGround(isPressed);
}
