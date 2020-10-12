import 'dart:convert';

import 'package:blog_tuto_ap/helpers/base_network.dart';
import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/helpers/shared_pref.dart';
import 'package:blog_tuto_ap/utils/app_constants.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:blog_tuto_ap/view/page/home_page/category_response_ob.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BaseNetwork {

  PublishSubject<ResponseOb> blogController = PublishSubject();

  Stream<ResponseOb> blogStream() => blogController.stream;


  String nextPageUrl;//null

  getBlog(String id) {
    getReq(CAT_BY_URL+id,onDataCallBack: (ResponseOb resp){

      print(resp.data);
      print("one");
      BlogResponseOb bro=BlogResponseOb.fromJson(resp.data);
      print("two");
      if(bro.result.nextPageUrl!="null"){
        nextPageUrl=bro.result.nextPageUrl;
      }
      print('three');

      resp.pageLoad=PageLoad.first;


      resp.data=bro.result.data;//List<BlogOb>
      blogController.sink.add(resp);


    },errorCallBack: (ResponseOb resp){
      blogController.sink.add(resp);

    });
  }

  getLoadMoreBlog(String id){


    if(nextPageUrl==null){
      List<BlogOb> list=[];
      ResponseOb resp=ResponseOb(pageLoad: PageLoad.noMore,message: MsgState.data,data: list);
      blogController.sink.add(resp);

    }else {
      getReq(nextPageUrl+"&category_id="+id, onDataCallBack: (ResponseOb resp) {
        BlogResponseOb bro = BlogResponseOb.fromJson(resp.data);
        if (bro.result.nextPageUrl != "null") {
          nextPageUrl = bro.result.nextPageUrl;
          resp.pageLoad = PageLoad.nextPage;
        } else {
          nextPageUrl = null;
        }

        resp.data = bro.result.data;
        blogController.sink.add(resp);
      }, errorCallBack: (ResponseOb resp) {
        blogController.sink.add(resp);
      });
    }
  }






  void dispose() {
    blogController.close();
  }
}
