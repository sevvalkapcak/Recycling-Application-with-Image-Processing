import 'dart:async';
import 'dart:io';
import 'package:boot1_project/treasure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'cartmodel.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Barkod());
}

class Barkod extends StatefulWidget {
  @override
  _BarkodState createState() => _BarkodState();
}

class _BarkodState extends State<Barkod> {
  String _scanBarcode = 'Unknown';
  XFile? photoPath;
  File? imageFile;
  String label = '';
  double confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _tfLiteInit();
  }

  Future<void> _tfLiteInit() async {
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          photoPath = pickedFile;
          imageFile = File(pickedFile.path);
          uploadPhoto(pickedFile);
          runModelOnImage(File(pickedFile.path));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          photoPath = pickedFile;
          imageFile = File(pickedFile.path);
          uploadPhoto(pickedFile);
          runModelOnImage(File(pickedFile.path));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> runModelOnImage(File image) async {
    print("Model çalıştırılıyor...");
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    print("Model çalışması tamamlandı.");

    if (recognitions == null) {
      print("recognitions is Null");
      return;
    }

    // Etiketi al ve gereksiz karakterleri kaldır
    String label = recognitions[0]['label']
        .toString()
        .replaceAll(RegExp(r'[0-9]'), '')
        .trim();

    // Güvenilirlik oranını al
    double confidence = (recognitions[0]['confidence'] * 100);

    // Etiketi ve güvenilirlik oranını göster
    print("Tespit edilen etiket: $label");
    print("Doğruluk Oranı: ${confidence.toStringAsFixed(0)}%");

    // Etiketi ve güvenilirlik oranını göndererek diyalog kutusunu göster
    showConfirmationDialog(context, label, confidence);
  }

  Future<void> uploadPhoto(XFile photo) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Kullanıcı giriş yapmamış');
        return;
      }

      String filePath =
          'user_photos/${user.email}/${DateTime.now().toIso8601String()}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(File(photo.path));

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String photoUrl = await taskSnapshot.ref.getDownloadURL();

      DatabaseReference databaseRef =
          FirebaseDatabase.instance.ref('users/${user.uid}/photos');
      await databaseRef.push().set({
        'photoUrl': photoUrl,
        'timestamp': DateTime.now().toIso8601String(),
        'email': user.email,
      });

      DatabaseReference conversionsRef =
          FirebaseDatabase.instance.ref('conversions');
      await conversionsRef.push().set({
        'userId': user.uid,
        'email': user.email,
        'timestamp': DateTime.now().toIso8601String(),
        'photoUrl': photoUrl,
      });

      print('Fotoğraf başarıyla yüklendi ve kaydedildi: $photoUrl');
    } catch (e) {
      print('Fotoğraf yükleme ve kaydetme sırasında hata: $e');
    }
  }

  void addToCart(String label, double confidence) {
    int id = 0;
    String title = "Bilinmeyen";
    double price = 0.0;
    String imgUrl = ""; // Uygun resim URL'sini de burada ayarlayabilirsiniz

    // Loglama için print ekleyelim
    print("Tespit edilen etiket: $label");

    // Remove any leading/trailing whitespace and convert to lowercase
    String trimmedLabel = label.trim().toLowerCase();

    switch (trimmedLabel) {
      case "plastic":
        id = 1;
        title = "Plastik Şişe";
        price = 25.0;
        imgUrl = "https://img.icons8.com/officel/160/plastic.png";
        break;
      case "paper":
        id = 2;
        title = "Kağıt";
        price = 10.0;
        imgUrl =
            "https://img.icons8.com/external-icongeek26-linear-colour-icongeek26/128/external-papers-kindergarten-icongeek26-linear-colour-icongeek26.png";
        break;
      case "metal":
        id = 3;
        title = "Teneke Kutu";
        price = 35.0;
        imgUrl = "https://img.icons8.com/doodle/192/tin-can--v1.png";
        break;
      case "glass":
        id = 4;
        title = "Cam";
        price = 30.0;
        imgUrl = "https://img.icons8.com/plasticine/200/fragile.png";
        break;
      case "biological":
        id = 5;
        title = "Biyolojik Atık";
        price = 10.0;
        imgUrl = ""; // Biyolojik atık için uygun bir resim URL'si ekleyin
        break;
      case "battery":
        id = 6;
        title = "Pil";
        price = 20.0;
        imgUrl =
            "https://img.icons8.com/external-phatplus-lineal-color-phatplus/128/external-battery-ecology-system-phatplus-lineal-color-phatplus-2.png";
        break;
      default:
        // Bilinmeyen etiket
        id = 0;
        title = "Bilinmeyen";
        price = 0.0;
        imgUrl = ""; // Bilinmeyen için uygun bir resim URL'si ekleyin
        break;
    }

    // Yeni bir Product nesnesi oluştur
    Product product = Product(
      id: id,
      title: title,
      price: price,
      imgUrl: imgUrl,
      qty: 1,
    );

    // CartModel'i al
    CartModel cartModel = ScopedModel.of<CartModel>(context);

    // Ürünü sepete ekle
    cartModel.addProduct(product);

    // Ürünü sepete eklediğimizi loglayalım
    print("Ürün sepete eklendi: $title");
  }

  void showConfirmationDialog(
      BuildContext context, String label, double confidence) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ürünü sepete eklemek ister misiniz?"),
          content: Text(
              "Tespit edilen ürün: $label\nDoğruluk: ${confidence.toStringAsFixed(0)}%"),
          actions: <Widget>[
            TextButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Evet"),
              onPressed: () {
                addToCart(label,
                    confidence); // Ürünü sepete ekleyen fonksiyon burada çağrılıyor
                Navigator.of(context).pop(); // Mevcut dialogu kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CartPage()), // CartPage sayfasına yönlendirme
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFA5D6A7),
        appBar: AppBar(
          title: const Text('Tara - Dönüştür'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ucuncuSayfa()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => scanBarcodeNormal(),
                  child: Text(
                    'Barkod Tara',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(
                    height: 10), // Aralık eklemek için SizedBox kullanıyoruz
                ElevatedButton(
                  onPressed: () => scanQR(),
                  child: Text(
                    'QR Tara',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(
                    height: 10), // Aralık eklemek için SizedBox kullanıyoruz
                ElevatedButton(
                  onPressed: () => pickImageCamera(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.green,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Fotoğraf Çek',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 10), // Aralık eklemek için SizedBox kullanıyoruz
                ElevatedButton(
                  onPressed: () => pickImageGallery(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Colors.green,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Galeriden Seç',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 10), // Aralık eklemek için SizedBox kullanıyoruz
                photoPath != null
                    ? Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 300, // set a max height for the image
                            ),
                            child: Image.file(File(photoPath!.path)),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
