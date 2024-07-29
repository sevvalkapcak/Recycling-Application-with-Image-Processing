import 'package:boot1_project/login/login_pagee.dart';
import 'package:boot1_project/home_page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:boot1_project/cartmodel.dart';
import 'package:boot1_project/add_product.dart';
import 'box.dart';
class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Hazinem"),
          actions: <Widget>[
            TextButton(
                onPressed: () => ScopedModel.of<CartModel>(context).clearCart(),
                child: Text(
                  "Temizle",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
            .cart
            .length ==
            0
            ? Center(
          child: Text("Dönüştürülecek ürün yok!"),
        )
            : Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: ScopedModel.of<CartModel>(context,
                      rebuildOnChange: true)
                      .total,
                  itemBuilder: (context, index) {
                    return ScopedModelDescendant<CartModel>(
                      builder: (context, child, model) {
                        return ListTile(
                          title: Text(model.cart[index].title),
                          subtitle: Text(model.cart[index].qty.toString() +
                              " x " +
                              model.cart[index].price.toString() +
                              " = " +
                              (model.cart[index].qty *
                                  model.cart[index].price)
                                  .toString()),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    model.updateProduct(
                                        model.cart[index],
                                        model.cart[index].qty + 1);
                                    // model.removeProduct(model.cart[index]);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    model.updateProduct(
                                        model.cart[index],
                                        model.cart[index].qty - 1);
                                    // model.removeProduct(model.cart[index]);
                                  },
                                ),
                              ]),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Toplam: " +
                        ScopedModel.of<CartModel>(context,
                            rebuildOnChange: true)
                            .totalCartValue
                            .toString() +
                        " puan",
                    style: TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.lightGreen,
                      elevation: 0,
                    ),
                    child: Text("Tıkla Sepetine Git!"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => sepet(),
                        ),
                      );
                    },
                  ))
            ])));
  }
}
