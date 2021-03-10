import 'package:pokedex/extensions/string_extension.dart';

class Helper {
  static String getDisplayName(String n) {
    return n.trim().replaceAll('-', ' ').capitalizeFirstofEach();
  }
}
