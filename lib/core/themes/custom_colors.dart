import 'package:flutter/material.dart';

class CustomColors {
  static const Color mainGreenColor = Color(0xFF5ABD8C);
  static const Color textColorAlmostBlack = Color(0xFF212121);
  static Color textFieldBackgroundColor =
      const Color(0xFFEFEFEF).withOpacity(0.4);
  static const Color textFieldSelectionColor = Color(0XFF00FF81);
  static const Color reviewCardBackgroundColor = Color(0XFFF9F9F9);
  static const Color drawerBackgroundColor = Color(0XFFF3F3F3);
  static const LinearGradient secondaryButtonGradientColors = LinearGradient(
    colors: [
      Color(0xFF5ABD8C),
      Color(0xFF00FF81),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color snackBarSuccessBackgroundColor = mainGreenColor;
  static Color snackBarFailureBackgroundColor = Colors.red.withOpacity(0.72);
  static const Color pdfTextSelectionColor = Color(0xFF00FF81);
  static const Color pdfContextMenuColor = Color(0xFF303030);
  static const Color inAppReadingSettingsModalBottomSheetPhoneBackgroundColor =
      Color(0xFFDFE2E1);
  static const Color
      inAppReadingSettingsModalBottomSheetSliderActiveTrackColor =
      Color(0xFF1C1C1C);
  static const Color
      inAppReadingSettingsModalBottomSheetSliderinactiveTrackColor =
      Color(0xFFC6C6C6);
}
