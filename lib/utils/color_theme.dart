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

Color setSecondaryColor(String type) {
  if (type == null) {
    return Color(0xfff79496);
  }
  type = type.toLowerCase();
  // return type.contains('Grass')  ? Color(0xff57dcc1) :
  //        type.contains('Water') ? Color(0xff84c9f3)  :
  //        type.contains('Rock')  ? Color(0xffd1dadf)  :
  //         Color(0xfffc7f7b);
  return type.contains('grass')
      ? Color(0xff8ede54)
      : type.contains('water')
          ? Color(0xFF58ABF6)
          : type.contains('rock')
              ? Color(0xffd5e1eb)
              : type.contains('bug')
                  ? Color(0xff50f2d0)
                  : type.contains('normal')
                      ? Color(0xff9fc7b7)
                      : type.contains('poison')
                          ? Color(0xff5685f5)
                          : type.contains('electric')
                              ? Color(0xfffaf25f)
                              : type.contains('ground')
                                  ? Color(0xfff0c37d)
                                  : type.contains('ice')
                                      ? Color(0xff7aedfa)
                                      : type.contains('dark')
                                          ? Color(0xffd3e0e0)
                                          : type.contains('fairy')
                                              ? Color(0xff9f71e3)
                                              : type.contains('psychic')
                                                  ? Color(0xffce91eb)
                                                  : type.contains('fighting')
                                                      ? Color(0xff9cd44e)
                                                      : type.contains('ghost')
                                                          ? Color(0xff6d3bad)
                                                          : Color(0xfff79496);
}

Color setPrimaryColor(String type) {
  if (type == null) {
    return Color(0xfff79496);
  }
  type = type.toLowerCase();
  return type.contains('grass')
      ? Color(0xff68c724)
      : type.contains('water')
          ? Color(0xFF429BED)
          : type.contains('rock')
              ? Color(0xffbbc7d1)
              : type.contains('bug')
                  ? Color(0xff4bcfb2)
                  : type.contains('normal')
                      ? Color(0xff9AB8AC)
                      : type.contains('poison')
                          ? Color(0xff094be8)
                          : type.contains('electric')
                              ? Color(0xffe8dd09)
                              : type.contains('ground')
                                  ? Color(0xffcf9b48)
                                  : type.contains('ice')
                                      ? Color(0xff1bcfe3)
                                      : type.contains('dark')
                                          ? Color(0xff9bbfbf)
                                          : type.contains('fairy')
                                              ? Color(0xff784abd)
                                              : type.contains('psychic')
                                                  ? Color(0xffbc6ee0)
                                                  : type.contains('fighting')
                                                      ? Color(0xff72ab22)
                                                      : type.contains('ghost')
                                                          ? Color(0xff42206e)
                                                          : Color(0xfffc6b6d);
}
/* 
Color setPrimaryColor(String type) {
  if (type == null) return Color(0xfff79496);

  type = type.toLowerCase();

  if (type.contains('grass')) return Color(0xff68c724);
  if (type.contains('water')) return Color(0xFF429BED);
  if (type.contains('rock')) return Color(0xffB8A038);
  if (type.contains('bug')) return Color(0xff4bcfb2);
  if (type.contains('normal')) return Color(0xff9AB8AC);
  if (type.contains('poison')) return Color(0xffA040A0);
  if (type.contains('electric')) return Color(0xffe8dd09);
  if (type.contains('ground')) return Color(0xffE0C068);
  if (type.contains('fire')) return Color(0xffF08030);
  if (type.contains('ice')) return Color(0xff1bcfe3);
  if (type.contains('dark')) return Color(0xff9bbfbf);
  if (type.contains('fairy')) return Color(0xff784abd);
  if (type.contains('psychic')) return Color(0xffF85888);
  if (type.contains('fighting')) return Color(0xffC03028);
  if (type.contains('ghost')) return Color(0xff705898);
  if (type.contains('dragon')) return Color(0xff7038F8);
  return Color(0xfffc6b6d);
}
 */
