//
// import 'package:boot1_project/cartmodel.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';
//
// class sepet extends StatefulWidget {
//   @override
//   _sepetState createState() => _sepetState();
// }
//
// class _sepetState extends State<sepet> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     )..repeat(reverse: true);
//     _animation = Tween<double>(begin: -10.0, end: 10.0)
//         .chain(CurveTween(curve: Curves.easeInOut))
//         .animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _showMessage(BuildContext context, String message) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//             SizedBox(height: 20),
//             Image.asset(
//               "icons8-dog-food-65.png",
//               width: 100,
//               height: 100,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 ScopedModel.of<CartModel>(context, rebuildOnChange: true).clearCart();
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sepet'),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(0, _animation.value),
//                   child: child,
//                 );
//               },
//               child: Card(
//                 margin: EdgeInsets.all(16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 color: Colors.green[100],
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Toplam: " +
//                             ScopedModel.of<CartModel>(context, rebuildOnChange: true)
//                                 .totalCartValue
//                                 .toString() +
//                             " puan",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Column(
//                         children: [
//                           if (ScopedModel.of<CartModel>(context, rebuildOnChange: true)
//                               .totalCartValue ==
//                               0) ...[
//                             Text(
//                               "Maalesef, daha fazla geri dönüşüm yapmalısınız :(",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                           ] else if (ScopedModel.of<CartModel>(context, rebuildOnChange: true)
//                               .totalCartValue <
//                               300) ...[
//                             SizedBox(height: 20),
//                           ] else if (ScopedModel.of<CartModel>(context, rebuildOnChange: true)
//                               .totalCartValue >=
//                               300) ...[
//                             Text(
//                               "Adınıza bir fidan dikildi!",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             Image.asset(
//                               "icons8-tree-planting-96.png",
//                               width: 100,
//                               height: 100,
//                             ),
//                           ]
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             FloatingActionButton(
//               onPressed: () {
//                 _showMessage(
//                     context, "Topladığınız puanlar sayesinde sokak hayvanlarına yiyecek bağışlandı!");
//               },
//               child: Icon(Icons.card_giftcard, color: Colors.white),
//               backgroundColor: Colors.green,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:boot1_project/cartmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class sepet extends StatefulWidget {
  @override
  _sepetState createState() => _sepetState();
}

class _sepetState extends State<sepet> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -10.0, end: 10.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalCartValue =
        ScopedModel.of<CartModel>(context, rebuildOnChange: true).totalCartValue;

    String message;
    if (totalCartValue >= 300) {
      message = "Adınıza bir fidan dikildi!";
    } else if (totalCartValue > 0 && totalCartValue < 300) {
      message = "Topladığınız puanlar sayesinde sokak hayvanlarına yiyecek bağışlandı!";
    } else {
      message = "Maalesef, daha fazla geri dönüşüm yapmalısınız :(";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepet'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Card(
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.green[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Toplam: $totalCartValue puan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          if (totalCartValue > 0) ...[
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 20),
                            if (totalCartValue >= 300)
                              Image.asset(
                                "icons8-tree-planting-96.png",
                                width: 100,
                                height: 100,
                              ),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                _showMessage(context, message);
              },
              child: Icon(Icons.card_giftcard, color: Colors.white),
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            // Image.asset(
            //   "icons8-dog-food-65.png",
            //   width: 100,
            //   height: 100,
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScopedModel.of<CartModel>(context, rebuildOnChange: true).clearCart();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
