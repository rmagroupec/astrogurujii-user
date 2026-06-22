import 'package:flutter/material.dart';

class Products with ChangeNotifier
{
  var _count = 0;
  var _fav_count = 0;
  int get getCounter {
    return _count;
  }

  int get getFavCounter {
    return _fav_count;
  }

  void incrementCounter(var countis) {
    _count = countis;
    notifyListeners();
  }


  void incrementFavCounter(var _fav_count) {
    _fav_count = _fav_count;
    notifyListeners();
  }

}