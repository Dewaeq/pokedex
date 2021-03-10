import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonStat.dart';
import 'package:pokedex/extensions/string_extension.dart';
import 'package:pokedex/utils/color_theme.dart';

class StatWidget extends StatelessWidget {
  final Pokemon pokemon;
  StatWidget({@required this.pokemon});

  Widget _stat(PokemonStat stat, int max) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              stat.name.replaceAll('-', ' ').capitalizeFirstofEach(),
              style: TextStyle(
                color: Colors.grey[850],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Container(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: stat.baseStat / max,
                    ),
                  ),
                  Positioned(
                    top: -20,
                    right: 0,
                    height: 20,
                    child: Text(
                      '${stat.baseStat}',
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var max = pokemon.stats.map((e) => e.baseStat).toList()..sort();
    int totalStats = max.fold(0, (a, b) => a + b);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: pokemon.stats.map((e) => _stat(e, max.last)).toList()
          ..add(
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(text: 'TOTAL   '),
                  TextSpan(
                    text: '$totalStats',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: setPrimaryColor(pokemon.types[0]),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
