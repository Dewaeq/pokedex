import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/extensions/string_extension.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/utils/colorTheme.dart';

class Helper {
  static String getDisplayName(String n) {
    if (n == null) return '';
    n = n.replaceAll('-galar', ' Galarian');
    n = n.replaceAll('-gmax', ' Gigantamax');
    return n.trim().replaceAll('-', ' ').capitalizeFirstofEach();
  }

  static String getGenerationName(String n) {
    if (n == null) return '';
    var split = n.split('-');
    var result =
        split[0].capitalizeFirstofEach() + ' ' + split[1].toUpperCase();
    return result;
  }

  static List<Pokemon> sortPokemon(List<Pokemon> toSort) {
    return toSort
      ..sort(((a, b) {
        if (a.species.name == b.species.name) {
          if (a.name.contains('-mega') ||
              a.name.contains('-gmax') ||
              a.name.contains('-eternamax')) {
            return 1;
          }
          return -1;
        }
        /* This sorts by family
       if (a.order == -1 && b.order == -1) return 0;
      if (a.order == -1) return 1;
      if (b.order == -1) return -1;
      return a.order.compareTo(b.order); */

        /// This sorts like we're used to
        if (a.id == -1 && b.id == -1) return 0;
        if (a.id == -1) return 1;
        if (b.id == -1) return -1;
        return a.id.compareTo(b.id);
      }));
  }

  static Widget _panelRow(String text1, String text2) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 15),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Text(
                text1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )),
          Expanded(
            flex: 2,
            child: Text(
              text2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showShortPokemonDetails(
      BuildContext context, Size size, Pokemon pokemon) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        backgroundColor: setPrimaryColor(pokemon.types[0]),
        isScrollControlled: true,
        builder: (_) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -50,
                  width: size.width,
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 80),
                          width: size.width * 0.5,
                          child: Text(
                            Helper.getDisplayName(pokemon.name),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: CachedNetworkImage(
                            imageUrl: pokemon.photoUrl,
                            width: size.width * 0.4 - 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 110),
                  child: Column(
                    children: [
                      _panelRow("Id", Pokemon.getId(pokemon.id.toString())),
                      if (pokemon.types.length == 1)
                        _panelRow(
                            'Type', pokemon.types[0].capitalizeFirstofEach()),
                      if (pokemon.types.length > 1)
                        _panelRow('Types',
                            '${pokemon.types[0].capitalizeFirstofEach()}, ${pokemon.types[1].capitalizeFirstofEach()}'),
                      _panelRow('Height', '${pokemon.height / 10} m'),
                      _panelRow('Weight', '${pokemon.weight / 10} kg'),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          pokemon.species.description.replaceAll('\n', ' '),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
