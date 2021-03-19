import 'package:flutter/material.dart';

class ApplyFiltersButton extends StatelessWidget {
  final Function filter;
  ApplyFiltersButton({@required this.filter});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        onPressed: filter,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      child: MaterialButton(
        onPressed: resetFilters,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.withOpacity(.4)),
        ),
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
