import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/constants/filterTypes.dart';
import 'package:pokedex/model/PokemonFilter.dart';
import 'package:pokedex/utils/helper.dart';

class FilterWidget extends StatefulWidget {
  final Function(List<PokemonFilter>) filter;
  FilterWidget({Key key, @required this.filter}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final _hpLimitController = TextEditingController()..text = '0';
  final _defLimitController = TextEditingController()..text = '0';
  final _atkLimitController = TextEditingController()..text = '0';
  final _specAtkLimitController = TextEditingController()..text = '0';
  final _specDefLimitController = TextEditingController()..text = '0';
  final _speedLimitController = TextEditingController()..text = '0';
  final _hpKey = GlobalKey<FormState>();
  final _atkKey = GlobalKey<FormState>();
  final _defKey = GlobalKey<FormState>();
  final _specAtkKey = GlobalKey<FormState>();
  final _specDefKey = GlobalKey<FormState>();
  final _speedKey = GlobalKey<FormState>();

  StatFilterType _hpFilterMode = StatFilterType.HIGHER_THEN;
  StatFilterType _atkFilterMode = StatFilterType.HIGHER_THEN;
  StatFilterType _defFilterMode = StatFilterType.HIGHER_THEN;
  StatFilterType _specAtkFilterMode = StatFilterType.HIGHER_THEN;
  StatFilterType _specDefFilterMode = StatFilterType.HIGHER_THEN;
  StatFilterType _speedFilterMode = StatFilterType.HIGHER_THEN;
  String _typeFilterName = 'normal';

  List<String> enabledFilters = [];

  var filters = <PokemonFilter>[];

  void filter() {
    if (enabledFilters.contains('type')) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_TYPE,
        mode: FilterType.FILTER_PROPERTY,
        options: <String, dynamic>{
          'type': _typeFilterName,
        },
      ));
    }
    if (enabledFilters.contains('hp') && _hpKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_HP,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 0,
          'mode': _hpFilterMode,
          'value': int.parse(_hpLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('atk') && _atkKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_ATK,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 1,
          'mode': _atkFilterMode,
          'value': int.parse(_atkLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('def') && _defKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_DEF,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 2,
          'mode': _defFilterMode,
          'value': int.parse(_defLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('spec-atk') &&
        _specAtkKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_SPEC_ATK,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 3,
          'mode': _specAtkFilterMode,
          'value': int.parse(_specAtkLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('spec-def') &&
        _specDefKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_SPEC_DEF,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 4,
          'mode': _specDefFilterMode,
          'value': int.parse(_specDefLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('speed') && _speedKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_SPEED,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 5,
          'mode': _speedFilterMode,
          'value': int.parse(_speedLimitController.text),
        },
      ));
    }

    widget.filter(filters);
    Navigator.of(context).pop();
  }

  Widget _typeFilterWidget() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: enabledFilters.contains('type'),
      onChanged: (value) {
        if (enabledFilters.contains('type')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_HP);
          setState(() => enabledFilters.remove('type'));
        } else {
          setState(() => enabledFilters.add('type'));
        }
      },
      title: Row(
        children: [
          Text('Type'),
          Spacer(),
          DropdownButton(
            value: _typeFilterName,
            items: POKEMON_TYPES
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(Helper.getDisplayName(e)),
                    ))
                .toList(),
            onChanged: (newType) {
              setState(() => _typeFilterName = newType);
            },
          ),
        ],
      ),
    );
  }

  Widget _hpFilter() {
    return _statFilter(
      key: _hpKey,
      title: 'HP',
      enabled: enabledFilters.contains('hp'),
      onEnabled: (value) {
        if (enabledFilters.contains('hp')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_HP);
          setState(() => enabledFilters.remove('hp'));
        } else {
          setState(() => enabledFilters.add('hp'));
        }
      },
      onChanged: (value) => setState(() => _hpFilterMode = value),
      controller: _hpLimitController,
      filterMode: _hpFilterMode,
    );
  }

  Widget _atkFilter() {
    return _statFilter(
      key: _atkKey,
      title: 'Attack',
      enabled: enabledFilters.contains('atk'),
      onEnabled: (value) {
        if (enabledFilters.contains('atk')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_ATK);
          setState(() => enabledFilters.remove('atk'));
        } else {
          setState(() => enabledFilters.add('atk'));
        }
      },
      onChanged: (value) => setState(() => _atkFilterMode = value),
      controller: _atkLimitController,
      filterMode: _atkFilterMode,
    );
  }

  Widget _defFilter() {
    return _statFilter(
      key: _defKey,
      title: 'Defense',
      enabled: enabledFilters.contains('def'),
      onEnabled: (value) {
        if (enabledFilters.contains('def')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_DEF);
          setState(() => enabledFilters.remove('def'));
        } else {
          setState(() => enabledFilters.add('def'));
        }
      },
      onChanged: (value) => setState(() => _defFilterMode = value),
      controller: _defLimitController,
      filterMode: _defFilterMode,
    );
  }

  Widget _specAtkFilter() {
    return _statFilter(
      key: _specAtkKey,
      title: 'Special Attack',
      enabled: enabledFilters.contains('spec-atk'),
      onEnabled: (value) {
        if (enabledFilters.contains('spec-atk')) {
          filters.removeWhere(
              (e) => e.filterType == FilterType.FILTER_BY_SPEC_ATK);
          setState(() => enabledFilters.remove('spec-atk'));
        } else {
          setState(() => enabledFilters.add('spec-atk'));
        }
      },
      onChanged: (value) => setState(() => _specAtkFilterMode = value),
      controller: _specAtkLimitController,
      filterMode: _specAtkFilterMode,
    );
  }

  Widget _specDefFilter() {
    return _statFilter(
      key: _specDefKey,
      title: 'Special Defense',
      enabled: enabledFilters.contains('spec-def'),
      onEnabled: (value) {
        if (enabledFilters.contains('spec-def')) {
          filters.removeWhere(
              (e) => e.filterType == FilterType.FILTER_BY_SPEC_DEF);
          setState(() => enabledFilters.remove('spec-def'));
        } else {
          setState(() => enabledFilters.add('spec-def'));
        }
      },
      onChanged: (value) => setState(() => _specDefFilterMode = value),
      controller: _specDefLimitController,
      filterMode: _specDefFilterMode,
    );
  }

  Widget _speedFilter() {
    return _statFilter(
      key: _speedKey,
      title: 'Speed',
      enabled: enabledFilters.contains('speed'),
      onEnabled: (value) {
        if (enabledFilters.contains('speed')) {
          filters
              .removeWhere((e) => e.filterType == FilterType.FILTER_BY_SPEED);
          setState(() => enabledFilters.remove('speed'));
        } else {
          setState(() => enabledFilters.add('speed'));
        }
      },
      onChanged: (value) => setState(() => _speedFilterMode = value),
      controller: _speedLimitController,
      filterMode: _speedFilterMode,
    );
  }

  Widget _statFilter({
    @required Key key,
    @required String title,
    @required StatFilterType filterMode,
    @required bool enabled,
    @required Function onEnabled,
    @required Function onChanged,
    @required TextEditingController controller,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: enabled,
      onChanged: onEnabled,
      title: Row(
        children: [
          Text(title),
          Spacer(),
          DropdownButton(
            value: filterMode,
            items: [
              DropdownMenuItem(
                value: StatFilterType.HIGHER_THEN,
                child: Text('>='),
              ),
              DropdownMenuItem(
                value: StatFilterType.LOWER_THEN,
                child: Text('<'),
              ),
            ],
            onChanged: onChanged,
          ),
          SizedBox(width: 30),
          SizedBox(
            width: 60,
            child: Form(
              key: key,
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (int.tryParse(value) == null) return 'Not valid';
                  return null;
                },
                controller: controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 3,
                decoration: InputDecoration(
                  counter: Container(),
                  errorStyle: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        onPressed: filter,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minWidth: double.infinity,
        color: Colors.deepPurpleAccent,
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                filters.length > 1 ? 'APPLY FILTERS' : 'APPLY FILTER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Positioned(
                left: 0,
                child: Icon(Icons.filter_list_alt, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 15),
            child: Text(
              'Filter by...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 18,
              ),
            ),
          ),
          _typeFilterWidget(),
          _hpFilter(),
          _atkFilter(),
          _defFilter(),
          _specAtkFilter(),
          _specDefFilter(),
          _speedFilter(),
          //   Spacer(),
          SizedBox(height: 25),
          _filterButton(),
        ],
      ),
    );
  }
}
