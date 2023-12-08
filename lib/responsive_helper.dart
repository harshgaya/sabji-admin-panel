import 'package:flutter/material.dart';

class ResponsiveDesign extends StatelessWidget {
  
  final Widget mobile;
  final Widget desktop;


  ResponsiveDesign({required this.mobile,required this.desktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {

      if(constraints.maxWidth <768){
        return mobile;
      }else {
        return desktop;
      }

    });
  }
}
