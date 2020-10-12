import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/view/page/home_page/blog_response_ob.dart';
import 'package:blog_tuto_ap/view/page/home_page/category_response_ob.dart';
import 'package:flutter/material.dart';




import 'package:blog_tuto_ap/view/page/profile_page/profile_page.dart';
import 'package:blog_tuto_ap/view/page/upload_post_page/upload_post_page.dart';
import 'package:blog_tuto_ap/view/widget/post_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'category_bloc.dart';



class CategoryPage extends StatefulWidget {

  CategoryOb ob;
  CategoryPage(this.ob);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  final _bloc=CategoryBloc();

  var _refreshController=RefreshController();

  List<BlogOb> list =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getBlog(widget.ob.id.toString());
    _bloc.blogStream().listen((ResponseOb resp) {

      if(resp.message==MsgState.data){

        if(resp.pageLoad==PageLoad.first) {
          _refreshController.refreshCompleted();
        }
        if(resp.pageLoad==PageLoad.nextPage) {
          _refreshController.loadComplete();
        }
        if(resp.pageLoad==PageLoad.noMore){
          _refreshController.loadNoData();
        }


      }


    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: NeumorphicAppBar(
        title: Text(widget.ob.name),

      ),
      body: StreamBuilder<ResponseOb>(
        stream: _bloc.blogStream(),
        initialData: ResponseOb(message: MsgState.loading),
        builder: (context,snapshot){
          ResponseOb resp=snapshot.data;
          if(resp.message==MsgState.loading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(resp.message==MsgState.error){

            return Center(
              child: Text("Something Wrong"),
            );
          }
          else{

            if(resp.pageLoad==PageLoad.first){
              list=resp.data;
            }else{
              list.addAll(resp.data);
            }


            return SmartRefresher(
              enablePullUp: list.length>4,
              onRefresh: (){
                _bloc.getBlog(widget.ob.id.toString());
              },
              onLoading: (){
                _bloc.getLoadMoreBlog(widget.ob.id.toString());
              },
              controller: _refreshController,
              child: ListView(
                  padding: EdgeInsets.all(16),
//                        shrinkWrap: true,
//                        physics: ClampingScrollPhysics(),
                  children: list.map((ob){
                    return PostWidget(ob,catName:widget.ob.name);
                  }).toList()
              ),
            );

          }

        },
      )
    );
  }
}
