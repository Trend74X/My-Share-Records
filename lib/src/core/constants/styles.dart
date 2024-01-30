import 'package:flutter/material.dart';

// ----- Colors -----
const white =         Color(0xFFFFFFFF);
const primary =       Color(0xFF17A67B);
const secondary =     Color(0xFFFF5C28);
const error =         Color(0xFFE00000);
const black =         Color(0xFF2C2C2C);
const gray01 =        Color(0xFF4B4B4B);


// text styles

tileHeader() => const TextStyle(
  fontSize: 16.0, 
  fontWeight: FontWeight.w500,
  // color: color ?? gray01,
  height: 1.5,
);

// tileHeaderMid() => const TextStyle(
//   fontSize: 16.0, 
//   fontWeight: FontWeight.w500,
//   // color: color ?? gray01,
//   height: 1.5,
// );

tileSubtitle() => const TextStyle(
  fontSize: 14.0, 
  fontWeight: FontWeight.w500,
  // color: color ?? gray01,
  height: 1.0,
);