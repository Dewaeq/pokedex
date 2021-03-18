import 'package:flutter/material.dart';

class ApplyFiltersButton extends StatelessWidget {
  final Function filter;
  ApplyFiltersButton({@required this.filter});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
                'APPLY',
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
}

class ResetFiltersButton extends StatelessWidget {
  final Function resetFilters;
  ResetFiltersButton({@required this.resetFilters});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: OutlineButton(
        onPressed: resetFilters,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        highlightedBorderColor: Colors.grey,
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'RESET FILTERS',
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 16,
                ),
              ),
              Positioned(
                left: 0,
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.deepPurpleAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
