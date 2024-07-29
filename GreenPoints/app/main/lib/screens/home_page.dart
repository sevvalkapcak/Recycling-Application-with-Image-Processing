
import 'package:boot1_project/login/login_pagee.dart';
import 'package:flutter/material.dart';
import 'package:boot1_project/barcode.dart';
import 'package:boot1_project/box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'add_product.dart';
import 'profile.dart';
import 'models/habers.dart';


class ucuncuSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA5D6A7),
      appBar: AppBar(
        title: const Text('Green Points'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.favorite_outlined,),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => sepet()),);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Barkod()),);
              },
            ),
            IconButton(
              icon: Icon(Icons.newspaper_sharp),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Haber()),);
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle_rounded),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ikinciSayfa()),);
              },
            ),
          ],
        ),
      ),

    );
  }
}
