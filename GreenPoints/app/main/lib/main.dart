import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:boot1_project/cartmodel.dart';
import 'login/login_pagee.dart'; 
import 'treasure.dart'; 
import 'package:boot1_project/barcode.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(); 

  runApp(MyApp(model: CartModel()));
}

class MyApp extends StatelessWidget {
  final CartModel model;

  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CartModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopping Cart',
        routes: {
          '/cart': (context) => CartPage(),
          '/barkod': (context) => Barkod(),
        },
        home: SignInPage(),
      ),
    );
  }
}
