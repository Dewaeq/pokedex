import 'package:flutter/foundation.dart';
import 'package:pokedex/constants/filterTypes.dart';

class PokemonFilter {
  FilterType filterType;
  FilterType mode;
  Map<String, dynamic> options = <String, dynamic>{};

  PokemonFilter({
    @required this.filterType,
    @required this.mode,
    this.options,
  });
}
