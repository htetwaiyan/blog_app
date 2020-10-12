import 'package:blog_tuto_ap/helpers/response_ob.dart';
import 'package:blog_tuto_ap/view/page/category_page/category_page.dart';
import 'package:blog_tuto_ap/view/page/profile_page/profile_page.dart';
import 'package:blog_tuto_ap/view/page/upload_post_page/upload_post_page.dart';
import 'package:blog_tuto_ap/view/widget/category_widget.dart';
import 'package:blog_tuto_ap/view/widget/post_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'blog_response_ob.dart';
import 'category_response_ob.dart';
import 'home_bloc.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _refreshController=RefreshController();

  final _bloc=HomeBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getCategory();
    _bloc.getBlog();
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

  List<BlogOb> list =[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text("Blog App"),
        leading: NeumorphicButton(
          child: Icon(Icons.person),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
              return ProfilePage();
            }));

          },
        ),
        actions: [
          NeumorphicButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return UploadPostPage();
              })).then((b){
                if(b!=null) {
                  if (b) {
                    _bloc.getBlog();
                  }
                }
              });

            },
          ),

        ],
      ),
      body: Column(

        children: [
          Container(
            height: 80,
            child: StreamBuilder<ResponseOb>(
              stream: _bloc.categoryStream(),
              initialData: ResponseOb(message: MsgState.loading),
              builder: (context,snapshot){
                ResponseOb resp=snapshot.data;
                if(resp.message==MsgState.loading){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(resp.message==MsgState.error) {
                  return Center(
                      child: Text("Something Wrong!!")
                  );
                }else{
                  List<CategoryOb> list=resp.data;
                   return ListView(
                     padding: EdgeInsets.all(16),
                     scrollDirection: Axis.horizontal,
                     children:list.map((ob){
                       return CategoryWidget(ob);
                     }).toList(),
                   );
                }

              },
            )
          ),

          Expanded(
            child: StreamBuilder<ResponseOb>(
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
                      _bloc.getBlog();
                    },
                    onLoading: (){
                      _bloc.getLoadMoreBlog();
                    },
                    controller: _refreshController,
                    child: ListView(
                      padding: EdgeInsets.all(16),
//                        shrinkWrap: true,
//                        physics: ClampingScrollPhysics(),
                      children: list.map((ob){
                        return PostWidget(ob);
                      }).toList()
                    ),
                  );

                }

              },
            ),
          )



        ],
      ),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

}
