import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle fontStyle(BuildContext context, double size, color, weight, style) {
  return GoogleFonts.andika(
      textStyle: Theme.of(context).textTheme.bodyText1,
      fontSize: size,
      color: color,
      fontWeight: weight,
      fontStyle: style);
}
