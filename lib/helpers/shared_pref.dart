import 'package:shared_preferences/shared_preferences.dart';




class SharedPref{

  static const token="token";
  static const category="category";
  static const profile='profile';


  static Future<bool> setData({String key,String value})async{
    SharedPreferences shp=await SharedPreferences.getInstance();
    return shp.setString(key, value);
  }


  static Future<String> getData({String key})async{
    SharedPreferences shp=await SharedPreferences.getInstance();
    String str=shp.getString(key);
    return str;
  }



  static void clear()async{
    SharedPreferences shp=await SharedPreferences.getInstance();
    shp.clear();
  }





}