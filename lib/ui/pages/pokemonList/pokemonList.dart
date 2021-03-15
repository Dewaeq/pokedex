import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/constants/filterTypes.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/filterWidget.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemon_card.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList>
    with TickerProviderStateMixin {
  int _cardType = 1;
  bool _open = false;
  bool _openSearch = false;
  bool _includeEvolutions = false;
  List<Pokemon> shownPokemon;
  PokemonState state;

  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController;
  AnimationController _animationController;

  Widget _fabButton({Function onPressed, String title, IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RaisedButton(
            onPressed: () {
              animate();
              onPressed();
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(title),
          ),
          SizedBox(
            height: 40,
            child: RaisedButton(
              onPressed: () {
                animate();
                onPressed();
              },
              shape: CircleBorder(),
              color: Colors.white,
              child: Icon(icon),
            ),
          ),
        ],
      ),
    );
  }

  Widget floatingOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _fabButton(
          onPressed: scrollToTop,
          icon: Icons.keyboard_arrow_up,
          title: 'Go to top',
        ),
        _fabButton(
          onPressed: () {},
          icon: Icons.sort,
          title: 'Sort by property',
        ),
        _fabButton(
          onPressed: _openFilterMenu,
          icon: Icons.filter_list_alt,
          title: 'Filter by property',
        ),
        _fabButton(
          onPressed: () {
            scrollToTop();
            setState(() => _openSearch = !_openSearch);
          },
          icon: Icons.search,
          title: 'Search',
        ),
      ],
    );
  }

  Widget _appBar(Size size) {
    return SliverAppBar(
      title: Text(
        'Pokédex',
        style: TextStyle(
          color: Colors.blueGrey[900],
        ),
      ),
      toolbarHeight: size.height * 0.1,
      iconTheme: IconThemeData(color: Colors.blueGrey[700]),
      floating: true,
      backgroundColor: Colors.white,
    );
  }

  Widget _searchAppBar(Size size) {
    return SliverAppBar(
      snap: _openSearch,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) => _searchPokemon(value),
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(hintText: 'Pokemon name or id'),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            onChanged: (value) {
              setState(() => _includeEvolutions = value);
              _searchPokemon(_searchController.text);
            },
            contentPadding: EdgeInsets.zero,
            value: _includeEvolutions,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Include evolutions'),
          ),
        ],
      ),
      leading: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey[800]),
          onPressed: () {
            _searchPokemon('');
            setState(() {
              _searchController.text = '';
              _openSearch = false;
            });
            FocusScope.of(context).unfocus();
          },
        ),
      ),
      floating: true,
      backgroundColor: Colors.white,
      toolbarHeight: size.height * 0.15,
    );
  }

  void _openFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      builder: (context) => FilterWidget(
        filter: _filterPokemon,
      ),
    );
  }

  void _filterPokemon(FilterType filterType, Map<String, dynamic> options) {
    if (options.containsKey('error')) {
      print('oh ow');
      return;
    }

    if (filterType == FilterType.FILTER_BY_TYPE) {
      _filterPokemonByType(options['pokemon_type']);
    }
  }

  void _filterPokemonByType(String type) {
    var newPokemon =
        state.pokemons.where((e) => e.types.contains(type)).toList();
    setState(() => shownPokemon = newPokemon);
  }

  void _searchPokemon(String input) {
    if (input == '') {
      setState(() => shownPokemon = state.pokemons);
      return;
    }
    input = input.trim().toLowerCase();
    var newPokemon = state.pokemons;

    if (POKEMON_TYPES.contains(input)) {
      _filterPokemonByType(input);

      return;
    }
    newPokemon = state.pokemons.where((e) {
      if (_includeEvolutions) {
        for (var x in e.species.evolutions) {
          if (Helper.getDisplayName(x.fromPokemon)
                  .toLowerCase()
                  .contains(input) ||
              Helper.getDisplayName(x.toPokemon)
                  .toLowerCase()
                  .contains(input)) {
            return true;
          }
        }
      }
      if (Helper.getDisplayName(e.name).toLowerCase().contains(input) ||
          '${e.id}'.contains(input) ||
          Pokemon.getId('${e.id}').contains(input)) {
        return true;
      }
      return false;
    }).toList();

    if (_includeEvolutions) {
      newPokemon.sort((a, b) {
        if (a.name.toLowerCase().contains(input)) {
          if (a.name.contains('-mega') || a.name.contains('-gmax')) {
            return 1;
          }
          return -1;
        }
        return 1;
      });
    } else {
      newPokemon = Helper.sortPokemon(newPokemon);
    }

    setState(() {
      shownPokemon = newPokemon;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void animate() {
    if (!_open) {
      _animationController.forward();
    } else
      _animationController.reverse();
    _open = !_open;
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    )..addListener(() => setState(() {}));

    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (state == null || !state.gotData) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (shownPokemon == null) shownPokemon = state.pokemons;

    return KeyboardVisibilityBuilder(builder: (_, visible) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: animate,
          backgroundColor: _open ? Colors.white : Colors.deepPurpleAccent,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            color: _open ? Colors.deepPurpleAccent : Colors.white,
            progress: _animationController,
          ),
        ),
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Container(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      !_openSearch ? _appBar(size) : _searchAppBar(size),
                      SliverPadding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                        sliver: shownPokemon.isEmpty
                            ? SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    'No pokemon found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey[850],
                                    ),
                                  ),
                                ),
                              )
                            : SliverGrid.count(
                                crossAxisCount: _cardType + 1,
                                childAspectRatio: 1.2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: List<Widget>.from(shownPokemon.map(
                                  (e) => PokemonCard(
                                    cardType: 1,
                                    pokemon: e,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PokemonDetailsPage(pokemon: e),
                                      ),
                                    ),
                                    onLongPressed: () =>
                                        Helper.showShortPokemonDetails(
                                            context, size, e),
                                  ),
                                ))
                                  ..add(SizedBox(height: 20)),
                              ),
                      ),
                    ],
                  ),
                ),
                !_open
                    ? Container()
                    : Positioned(
                        bottom: 85,
                        right: 5,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: _open ? 1 : 0,
                          child: floatingOptions(),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
    });
  }
}
