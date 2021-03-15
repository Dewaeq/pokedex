import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/constants/filterTypes.dart';
import 'package:pokedex/utils/helper.dart';

class FilterWidget extends StatefulWidget {
  final Function(FilterType, Map<String, dynamic>) filter;
  FilterWidget({Key key, @required this.filter}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  FilterType _filterType = FilterType.FILTER_BY_TYPE;
  HPFilterType _hpFilterType = HPFilterType.HIGHER_THEN;
  String _typeFilterType = 'normal';
  final TextEditingController _hpLimitController = TextEditingController();
  final _hpKey = GlobalKey<FormState>();

  void filter() {
    var options = <String, dynamic>{};

    switch (_filterType) {
      case (FilterType.FILTER_BY_TYPE):
        options['pokemon_type'] = _typeFilterType;
        break;
      case (FilterType.FILTER_BY_HP):
        if (!_hpKey.currentState.validate()) {
          return;
        }
        break;
      default:
        options['error'] = true;
        break;
    }
    widget.filter(_filterType, options);

    Navigator.of(context).pop();
  }

  Widget _typeFilter() {
    return RadioListTile<FilterType>(
      value: FilterType.FILTER_BY_TYPE,
      groupValue: _filterType,
      onChanged: (FilterType filterType) {
        setState(() => _filterType = filterType);
      },
      title: Row(
        children: [
          Text('Type'),
          Spacer(),
          DropdownButton(
            value: _typeFilterType,
            items: POKEMON_TYPES
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(Helper.getDisplayName(e)),
                    ))
                .toList(),
            onChanged: (newType) {
              setState(() => _typeFilterType = newType);
            },
          ),
        ],
      ),
    );
  }

  Widget _hpFilter() {
    return RadioListTile<FilterType>(
      value: FilterType.FILTER_BY_HP,
      groupValue: _filterType,
      onChanged: (FilterType filterType) {
        setState(() => _filterType = filterType);
      },
      title: Row(
        children: [
          Text('HP'),
          Spacer(),
          DropdownButton(
            value: _hpFilterType,
            items: [
              DropdownMenuItem(
                value: HPFilterType.HIGHER_THEN,
                child: Text('>='),
              ),
              DropdownMenuItem(
                value: HPFilterType.LOWER_THEN,
                child: Text('<'),
              ),
            ],
            onChanged: (newtype) {
              setState(() => _hpFilterType = newtype);
            },
          ),
          SizedBox(width: 30),
          SizedBox(
            width: 60,
            child: Form(
              key: _hpKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (int.tryParse(value) == null) return 'Not valid';
                  return null;
                },
                controller: _hpLimitController,
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
                'APPLY FILTER',
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
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.75,
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
          _typeFilter(),
          _hpFilter(),
          Spacer(),
          _filterButton(),
        ],
      ),
    );
  }
}
