import 'package:flutter/material.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Color setPrimaryColor(String type) {
  if (type == null) return Color(0xfff79496);

  type = type.toLowerCase();
  if (type.contains('grass')) return Color(0xff8BCDB4);
  if (type.contains('water')) return Color(0xFFA4B4EE);
  if (type.contains('rock')) return Color(0xffBDA538);
  if (type.contains('bug')) return Color(0xff98B82E);
  if (type.contains('normal')) return Color(0xffBFB87F);
  if (type.contains('poison')) return Color(0xffAB46BC);
  if (type.contains('electric')) return Color(0xffFFCC00);
  if (type.contains('ground')) return Color(0xffE0B352);
  if (type.contains('flying')) return Color(0xff9D87E0);
  if (type.contains('fire')) return Color(0xffEE837B);
  if (type.contains('ice')) return Color(0xff1bcfe3);
  if (type.contains('steel')) return Color(0xffB4B4CC);
  if (type.contains('dark')) return Color(0xff9bbfbf);
  if (type.contains('fairy')) return Color(0xffF483BB);
  if (type.contains('psychic')) return Color(0xffF85888);
  if (type.contains('fighting')) return Color(0xffD32E2E);
  if (type.contains('ghost')) return Color(0xff7555A5);
  if (type.contains('dragon')) return Color(0xff7038F8);
  return Color(0xfffc6b6d);
}
