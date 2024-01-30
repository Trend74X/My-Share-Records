import 'package:flutter/material.dart';

AppBar appBar(BuildContext context, String title, [action]) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    actions: action == null 
    ? []
    : [
      action,
      const SizedBox(width: 8.0)
    ],
  );
}