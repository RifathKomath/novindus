import 'package:flutter/material.dart';

extension NumberExtension on num {
  /// <b>SizedBox(height: 8)<b/>
  Widget get hBox => SizedBox(height: toDouble());
  /// <b>SizedBox(width: 8)<b/>
  Widget get wBox => SizedBox(width: toDouble());

}

extension PaddingExtension on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);
  Widget paddingSymmetricHorizontal(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);
  Widget paddingSymmetricVertical(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);
      Widget paddingHorVert(double value1,double value2) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value1,vertical: value2), child: this);
}