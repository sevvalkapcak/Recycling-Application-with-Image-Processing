import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<Product> cart = [];
  double totalCartValue = 0;

  int get total => cart.length;

  void addProduct(Product product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1) {
      updateProduct(product, product.qty + 1);
    } else {
      cart.add(product);
      calculateTotal();
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1) {
      cart[index].qty = 1;
      cart.removeWhere((item) => item.id == product.id);
      calculateTotal();
      notifyListeners();
    }
  }

  void updateProduct(Product product, int qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    if (index != -1) {
      cart[index].qty = qty;
      if (cart[index].qty == 0) {
        removeProduct(product);
      }
      calculateTotal();
      notifyListeners();
    }
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 1);
    cart = [];
    totalCartValue = 0;  // Ekledim: toplam puanı sıfırlamak için
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue += f.price * f.qty;
    });
    notifyListeners();
  }
}

class Product {
  int id;
  String title;
  String imgUrl;
  double price;
  int qty;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.qty,
    required this.imgUrl,
  });
}
