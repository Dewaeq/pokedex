import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/utils/colorTheme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:pokedex/extensions/string_extension.dart';

class PokemonCard1 extends StatelessWidget {
  final Pokemon pokemon;
  final Function onPressed;
  final Function onLongPressed;

  PokemonCard1({
    @required this.pokemon,
    @required this.onPressed,
    @required this.onLongPressed,
  });

  Widget _pokemonTypeWidget(String type) {
    if (type == null || type.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey[300].withOpacity(.4),
        ),
      ),
      child: Text(
        type.capitalizeFirstofEach(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialButton(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      padding: EdgeInsets.zero,
      color: setPrimaryColor(pokemon.types[0]),
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    Helper.getDisplayName(pokemon.name),
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5),
                  _pokemonTypeWidget(pokemon.types[0]),
                  SizedBox(
                    height: 5,
                  ),
                  if (pokemon.types.length > 1)
                    _pokemonTypeWidget(pokemon.types[1]),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              right: 10,
              width: size.width * 0.2,
              height: size.width * 0.2,
              child: CachedNetworkImage(
                imageUrl: pokemon.photoUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (_, __, ___) => Icon(Icons.error),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                Pokemon.getId(pokemon.id.toString()),
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
