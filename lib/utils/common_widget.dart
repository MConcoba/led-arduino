// import 'package:games_services/games_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcled/utils/constans.dart';
import './extension.dart';

BoxDecoration metalDecoration() => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: metalSort,
        colors: metalColor,
      ),
    );

Widget floorButtonImage(
  BuildContext context,
  int floorNumber, // Renamed `i` to `floorNumber` for clarity
  bool isShimada,
  bool isSelected,
) =>
    SizedBox(
      width: context.floorButtonSize(),
      height: context.floorButtonSize(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(floorNumber.numberBackground(isShimada, isSelected)),
          Text(
            floorNumber.buttonNumber(isShimada),
            style: TextStyle(
              color: (isSelected) ? lampColor : blackColor,
              fontSize: context.buttonNumberFontSize(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

Image shimadaLogoImage(BuildContext context, bool isShimada) => Image(
      color: blackColor,
      height: context.shimadaLogoHeight(),
      image: AssetImage(isShimada.shimadaLogo()),
    );

Widget imageButton(BuildContext context, String image) => SizedBox(
      width: context.operationButtonSize(),
      height: context.operationButtonSize(),
      child: Image.asset(image, fit: BoxFit.contain),
    );

Widget operationImage(
        BuildContext context, String operate, bool isShimada, bool isPressed) =>
    Stack(alignment: Alignment.center, children: [
      imageButton(context, isShimada.operateBackGround(operate, isPressed)),
      Container(
        width: context.operationButtonSize() + context.buttonBorderWidth(),
        height: context.operationButtonSize() + context.buttonBorderWidth(),
        decoration: BoxDecoration(
          color: transpColor,
          shape: (isShimada && operate == "alert")
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: (isShimada && operate == "alert")
              ? null
              : BorderRadius.circular(context.buttonBorderRadius()),
          border: Border.all(
            color: (operate == "alert")
                ? yellowColor
                : (operate == "open")
                    ? greenColor
                    : whiteColor,
            width: context.buttonBorderWidth(),
          ),
        ),
      )
    ]);
