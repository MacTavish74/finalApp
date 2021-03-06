import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire99/add_post.dart';
import 'package:fire99/cat2.dart';
import 'package:fire99/chat/cat.dart';
import 'package:fire99/dashboard.dart';
import 'package:fire99/login2.dart';
import 'package:fire99/new.dart';
import 'package:fire99/posts.dart';
import 'package:fire99/profile.dart';
import 'package:fire99/save2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'fchat/screens/chat_screen2.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: -30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(appBar: AppBar(
       backgroundColor:Colors.white,
         iconTheme: IconThemeData(color: Colors.black),
        title:Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                 // Colors.white,
                  Colors.white,
                  //Colors.lightBlueAccent,

                 // Colors.lightBlueAccent,
                  Colors.white,
                ])),
          height:30,
            child: Center(child: Row(
              children: [
                Text("   Sw",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w600,fontSize:21)),
                Text("ap",style:TextStyle(color:Colors.red,fontWeight:FontWeight.w600,fontSize:21)),
                Text("  Broker",style:TextStyle(color:Colors.black,fontWeight:FontWeight.w600,fontSize:21)),

              ],
            ))
        ),
        //backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
             RaisedButton(
            child: Text('Log Out',style: TextStyle(fontSize: 18,color: Colors.black),),
            color: Colors.white,
            onPressed: () async{
              WidgetsFlutterBinding.ensureInitialized();
                     await Firebase.initializeApp();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen2()));
            }
          ),

          ]
      ),


        drawer: SidebarPage(),
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: [
          /// ListView
          ListView(
            physics:
            BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(_w / 17, _w / 20, 0, _w / 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Swap Broker',
                        style: TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )

                  ],
                ),
              ),
              homePageCardsGroup(
                Colors.black,
                Icons.cloud_upload_sharp,
                'Upload Item',
                context,
                AddPost(),



                Colors.black,
                Icons.preview_outlined,
                'See All Products  ',
                PostsScreen(),
              ),
 RaisedButton(
              child: Text('Notifications'),

              onPressed:() async {
                final user = FirebaseAuth.instance.currentUser;
                final userData = await Firestore.instance.collection('users').doc(user.uid).get();
                String ud=userData['email'];
                Navigator.push(context, MaterialPageRoute(builder: (context) =>ChatScreen2(ud)));
              }
         
            ),
             RaisedButton(
                child: Text('Saved Deals'),

                onPressed:()async {
                 final user = FirebaseAuth.instance.currentUser;
                  final userData = await Firestore.instance.collection('users').doc(user.uid).get();
                  String ud=userData['email'];
                  Navigator.push(context, MaterialPageRoute(builder: (context) => save2(ud)));
                }

            ),

            RaisedButton(
                child: Text('Profile'),
                onPressed:() async {
                  final user = FirebaseAuth.instance.currentUser;
                  final userData = await Firestore.instance.collection('users').doc(user.uid).get();
                  String ud=userData['email'];
                  Navigator.push(context, MaterialPageRoute(builder: (context) => profile(ud)));
                }
            ),


            

            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, _w / 9.5, _w / 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RouteWhereYouGo();
                        },
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(99)),
                   /* child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: Container(
                        height: _w / 8.5,
                        width: _w / 8.5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.05),
                          shape: BoxShape.circle,
                        ),
                      /*  child: Center(
                          child: Icon(
                            Icons.settings,
                            size: _w / 17,
                            color: Colors.black.withOpacity(.6),
                          ),
                        ),*/
                      ),
                    ),*/
                  ),
                ),
              ],
            ),
          ),

          // Blur the Status bar
          blurTheStatusBar(context),
        ],
      ),
    );
  }

  Widget homePageCardsGroup(
      Color color,
      IconData icon,
      String title,
      BuildContext context,
      Widget route,
      Color color2,
      IconData icon2,
      String title2,
      Widget route2) {
    double _w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: _w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(color, icon, title, context, route),
          homePageCard(color2, icon2, title2, context, route2),
        ],
      ),
    );
  }

  Widget homePageCard(Color color, IconData icon, String title,
      BuildContext context, Widget route) {
    double _w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return route;
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(15),
            height: _w / 2,
            width: _w / 2.4,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xff040039).withOpacity(.15),
                  blurRadius: 99,
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(),
                Container(
                  height: _w / 8,
                  width: _w / 8,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                  ),
                ),
                Text(
                  title,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blurTheStatusBar(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          height: _w / 18,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class RouteWhereYouGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 50,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(.5),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black.withOpacity(.8),
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}