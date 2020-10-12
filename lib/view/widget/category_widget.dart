import 'package:blog_tuto_ap/view/page/category_page/category_page.dart';
import 'package:blog_tuto_ap/view/page/home_page/category_response_ob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CategoryWidget extends StatelessWidget {

  CategoryOb ob;


  CategoryWidget(this.ob);

  @override
  Widget build(BuildContext context) {
    return  NeumorphicButton(
      margin: EdgeInsets.only(right: 10),
      onPressed:(){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return CategoryPage(ob);
        }));
      },
      child: Center(child: Text(ob.name)),
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
      ),
    );
  }
}
