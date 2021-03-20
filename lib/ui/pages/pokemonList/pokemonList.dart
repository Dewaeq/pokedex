import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/constants/filterTypes.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonFilter.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/filter/filterButtons.dart';
import 'package:pokedex/ui/pages/pokemonList/components/filter/filterWidget.dart';
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
  bool _openFilter = false;
  bool _includeEvolutions = false;
  List<Pokemon> shownPokemon;
  List<Pokemon> filteredPokemon;
  Set<PokemonFilter> _filters;
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
          ElevatedButton(
            onPressed: () {
              _animate();
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                _animate();
                onPressed();
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                primary: Colors.white,
                onPrimary: Colors.black,
              ),
              child: Icon(icon, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: _animate,
      backgroundColor: _open ? Colors.white : Colors.deepPurpleAccent,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        color: _open ? Colors.deepPurpleAccent : Colors.white,
        progress: _animationController,
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
            _filterPokemon(_filters);
            setState(() => _openSearch = false);
            _searchController.text = '';
            FocusScope.of(context).unfocus();
          },
        ),
      ),
      floating: true,
      backgroundColor: Colors.white,
      toolbarHeight: size.height * 0.15,
    );
  }

  Widget _pokemonList(Size size) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        !_openSearch ? _appBar(size) : _searchAppBar(size),
        SliverPadding(
          padding: EdgeInsets.only(left: 25, right: 25, top: 15),
          sliver: shownPokemon.isEmpty
              ? SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No pokemon found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[850],
                        ),
                      ),
                      _filters != null ? _clearFilters() : Container(),
                    ],
                  ),
                )
              : SliverGrid.count(
                  crossAxisCount: _cardType + 1,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List<Widget>.from(shownPokemon.map(
                    (e) => PokemonCard(
                      cardType: 1,
                      pokemon: e,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PokemonDetailsPage(pokemon: e),
                        ),
                      ),
                      onLongPressed: () =>
                          Helper.showShortPokemonDetails(context, size, e),
                    ),
                  ))
                    ..addAll([
                      SizedBox(
                        height: 1,
                      ),
                      shownPokemon.length % (_cardType + 1) == 0
                          ? SizedBox(height: 1)
                          : Container(),
                    ]),
                ),
        ),
      ],
    );
  }

  Widget _clearFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ResetFiltersButton(
        resetFilters: () {
          setState(() => _filters = null);
          _resetPokemon();
        },
      ),
    );
  }

  void _openFilterMenu() {
    setState(() => _openFilter = true);
  }

  void _closeFilterMenu() {
    setState(() => _openFilter = false);
  }

  /// Filter all the pokemon with a Set of PokemonFilters
  void _filterPokemon(Set<PokemonFilter> filters) {
    if (filters == null || filters.isEmpty) {
      _resetPokemon();
      setState(() {
        _filters = null;
        if (_openSearch) _openSearch = false;
      });
      return;
    }
    _filters = filters;

    /// Reset all the pokemon so we filter with a clean start
    _resetPokemon();

    for (var filter in filters) {
      if (filter.filterType == FilterType.FILTER_BY_TYPE) {
        _filterPokemonByType(filter.options['type']);
      } else if (filter.mode == FilterType.FILTER_STAT) {
        _filterPokemonByStat(filter.options);
      } else if (filter.filterType == FilterType.FILTER_BY_GENERATION) {
        _filterPokemonByGeneration(filter.options['id']);
      }
    }
    filteredPokemon = shownPokemon;
  }

  /// Filter all the pokemon by their type.
  /// * `pokemonType` is a String
  void _filterPokemonByType(String pokemonType) {
    var newPokemon =
        shownPokemon.where((e) => e.types.contains(pokemonType)).toList();
    setState(() => shownPokemon = newPokemon);
  }

  /// Filter all the pokemon by their generation.
  /// * `generationId` is an int starting from 1
  void _filterPokemonByGeneration(int generationId) {
    var newPokemon = shownPokemon
        .where((e) => e.species.generationId == generationId)
        .toList();

    setState(() => shownPokemon = newPokemon);
  }

  /// Filter all the pokemon by their stat
  /// * `options` is a Map with a `ValueFilterType` in the mode key
  /// and an `int` which represents the stat's value in the value key
  void _filterPokemonByStat(Map<String, dynamic> options) {
    var newPokemon = <Pokemon>[];
    if (options['mode'] == ValueFilterType.HIGHER_THEN) {
      newPokemon = shownPokemon
          .where((e) => e.stats[options['index']].baseStat >= options['value'])
          .toList();
    } else {
      newPokemon = shownPokemon
          .where((e) => e.stats[0].baseStat < options['value'])
          .toList();
    }
    setState(() => shownPokemon = newPokemon);
  }

  void _searchPokemon(String input) {
    if (input == '') {
      if (_filters != null)
        _filterPokemon(_filters);
      else
        _resetPokemon();
      return;
    }
    input = input.trim().toLowerCase();
    var newPokemon = _filters == null ? state.pokemons : filteredPokemon;

    if (POKEMON_TYPES.contains(input) && _filters == null) {
      _filterPokemonByType(input);
      return;
    }

    newPokemon = newPokemon.where((e) {
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
      var mainPokemon = newPokemon.firstWhere(
          (e) => Helper.getDisplayName(e.name).toLowerCase().contains(input));
      newPokemon.remove(mainPokemon);
      newPokemon = Helper.sortPokemon(newPokemon)..insert(0, mainPokemon);
    } else {
      newPokemon = Helper.sortPokemon(newPokemon);
    }

    setState(() {
      shownPokemon = newPokemon;
    });
  }

  /// Reset the searchField's text and set `shownPokemon` to `state.pokemons`
  void _resetPokemon() {
    _searchController.text = '';
    FocusScope.of(context).unfocus();
    setState(() => shownPokemon = state.pokemons);
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _animate() {
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
        floatingActionButton: _openFilter ? null : _floatingActionButton(),
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Container(
                  child: _pokemonList(size),
                ),
                !_open
                    ? Container()
                    : Positioned(
                        bottom: 85,
                        right: 15,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: _open ? 1 : 0,
                          child: floatingOptions(),
                        ),
                      ),
                _openFilter
                    ? FilterWidget(
                        filter: _filterPokemon,
                        onClosed: _closeFilterMenu,
                        filters: _filters,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
