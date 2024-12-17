import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'menu_item.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';

class SideBar extends StatefulWidget{
  const SideBar({super.key});

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenStreamController;
  late Stream<bool> isSidebarOpenStream;
  late StreamSink<bool> isSidebarOpenSink;
  final _animationDuration = const Duration(milliseconds: 250);

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenStreamController = PublishSubject<bool>();
    isSidebarOpenStream = isSidebarOpenStreamController.stream;
    isSidebarOpenSink = isSidebarOpenStreamController.sink;
  }

  @override
  void dispose(){
    _animationController.dispose();
    isSidebarOpenStreamController.close();
    isSidebarOpenSink.close();
    super.dispose();
  }

  void onIconPressed(){
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if(isAnimationCompleted){
      isSidebarOpenSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenStream,
      builder: (context, isSidebarOpenAsync){
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarOpenAsync.requireData ? 0 : -screenWidth,
          right: isSidebarOpenAsync.requireData ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xFFFFD700),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 100,
                      ),
                      const ListTile(
                        title: Text(
                          'OmeGabong',
                          style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w800
                          ),
                        ),
                        leading: Icon(
                          Icons.play_arrow, 
                          color: Colors.black, 
                          size: 30),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Colors.black.withOpacity(0.5),
                        indent: 32,
                        endIndent: 32,
                      ),
                      MenuItem(
                        icon: Icons.play_arrow,
                        title: 'Play Gabong',
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.playGabongClickedEvent);
                        },
                      ),
                      MenuItem(
                        icon: Icons.calculate,
                        title: 'Points Calculator',
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.pointsCalculatorClickedEvent);
                        },
                      ),
                      MenuItem(
                        icon: Icons.book,
                        title: 'Rules',
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.rulesClickedEvent);
                        },
                      ),
                    ]
                  )
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.8),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      color: const Color(0xFFFFD700),
                      width: 35,
                      height: 110,
                      alignment: Alignment.center,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.green,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],  
          ),
        );
      }
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    Paint paint = Paint();
    paint.color = Colors.green;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1, height/2 - 20, width, height/2);
    path.quadraticBezierTo(width+1, height/2 + 20, 10, height-16);
    path.quadraticBezierTo(0, height-8, 0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}