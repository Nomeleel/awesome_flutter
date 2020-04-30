
import 'package:flutter/widgets.dart';

class ImageWraper{
  
  static Image path(String path) {
    return path.startsWith(RegExp('http[s]?://')) ? Image.network(path) : Image.asset(path);
  }

}