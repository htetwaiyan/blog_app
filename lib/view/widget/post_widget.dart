import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PostWidget extends StatelessWidget {

  BlogOb ob;
  String catName;
  PostWidget(this.ob,{this.catName});

  @override
  Widget build(BuildContext context) {
    return  Neumorphic(
      margin: EdgeInsets.only(top: 5,bottom: 15),
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 8,
//              lightSource: LightSource.topLeft,
//                    color: Colors.grey
        ),
        child: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child:CachedNetworkImage(
                  imageUrl: IMG_BASE_URL+ob.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),

              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ob.title,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                    SizedBox(height: 3,),
                    Row(
                      children: [
                        Text(ob.createdAt.split('T')[0],style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          color: Colors.grey
                        ),),
                        SizedBox(width: 5,),
                        Container(
                          padding: EdgeInsets.only(left:5,right: 5,top: 3,bottom: 3),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12)
                          ),

                          child: Text(catName!=null?catName:ob.category.name,style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            color: Colors.white
                          ),),
                        ),

                      ],
                    ),

                    SizedBox(height: 10,),
                    Text(ob.description,style: TextStyle(

                        fontSize: 14,

                    ),),



                  ],
                ),
              ),



            ],
          ),

        )
    );
  }
}
