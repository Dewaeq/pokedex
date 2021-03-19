import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/utils/colorTheme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:pokedex/extensions/string_extension.dart';

class HeaderWidget extends StatelessWidget {
  final Pokemon pokemon;
  HeaderWidget({@required this.pokemon});

  Widget _pokemonTypeWidget(String type, Color color) {
    if (type == null || type.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Text(
        type.capitalizeFirstofEach(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white60.withOpacity(.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Helper.getDisplayName(pokemon.name),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      Pokemon.getId('${pokemon.id}'),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 7),
                    child: Text(
                      pokemon.species.typeDescription,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: pokemon.types
                          .map(
                            (e) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child:
                                    _pokemonTypeWidget(e, setPrimaryColor(e)),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          CachedNetworkImage(
            imageUrl: pokemon.photoUrl,
            width: size.width * 0.25,
          )
        ],
      ),
    );
  }
}
