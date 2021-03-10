extension StringExtension on String {
  String capitalizeFirstofEach() {
    var s = this;
    List<String> r = [];
    for (var x in s.split(' ')) {
      x = x.toLowerCase();
      r.add(x[0].toUpperCase() + x.substring(1));
    }
    return r.join(' ');
  }
}
