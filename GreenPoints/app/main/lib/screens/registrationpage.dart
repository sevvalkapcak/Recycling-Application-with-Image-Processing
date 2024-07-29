
import 'package:flutter/material.dart';
import 'package:boot1_project/theme_helper/theme_helper.dart';
import 'headerwidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'profilepage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
        child: Stack(
        children: [
        const SizedBox(
        height: 150,
        child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
    ),
    Container(
    margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    alignment: Alignment.center,
    child: Column(
    children: [
    Form(
    key: _formKey,
    child: Column(
    children: [
    GestureDetector(
    child: Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 5, color: Colors.white),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000), // Adjust opacity as per your requirement
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.person,
          color: Colors.grey[300], // Use grey with a shade of 300
          size: 80.0,
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(80, 80, 0, 0),
        child: Icon(
          Icons.add_circle,
          color: Colors.grey[700], // Use grey with a shade of 700
          size: 25.0,
        ),
      ),

    ],
    ),
    ),
    const SizedBox(height: 30,),
    Container(
    child: TextFormField(
    decoration: ThemeHelper().textInputDecoration('First Name', 'Enter your first name'),
    ),
    decoration: ThemeHelper().inputBoxDecorationShaddow(),
    ),
    const SizedBox(height: 30,),
    Container(
    child: TextFormField(
    decoration: ThemeHelper().textInputDecoration('Last Name', 'Enter your last name'),
    ),
    decoration: ThemeHelper().inputBoxDecorationShaddow(),
    ),
    const SizedBox(height: 20.0),
    Container(
    child: TextFormField(
    decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),
    keyboardType: TextInputType.emailAddress,
    validator: (val) {
    if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
    return "Enter a valid email address";
    }
    return null;
    },
    ),
    decoration: ThemeHelper().inputBoxDecorationShaddow(),
    ),
    const SizedBox(height: 20.0),
    Container(
    child: TextFormField(
    decoration: ThemeHelper().textInputDecoration(
    "Mobile Number",
    "Enter your mobile number"),
    keyboardType: TextInputType.phone,
    validator: (val) {
    if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
    return "Enter a valid phone number";
    }
    return null;
    },
    ),
    decoration: ThemeHelper().inputBoxDecorationShaddow(),
    ),
    const SizedBox(height: 20.0),
    Container(
    child: TextFormField(
    obscureText: true,
    decoration: ThemeHelper().textInputDecoration(
    "Password*", "Enter your password"),
    validator: (val) {
    if (val!.isEmpty) {
    return "Please enter your password";
    }
    return null;
    },
    ),
    decoration: ThemeHelper().inputBoxDecorationShaddow(),
    ),
    const SizedBox(height: 15.0),
    FormField<bool>(
    builder: (state) {
    return Column(
    children: <Widget>[
    Row(
    children: <Widget>[
    Checkbox(
    value: checkboxValue,
    onChanged: (value) {
    setState(() {
    checkboxValue = value!;
    state.didChange(value);
    });
    },
    ),
    const Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
    ],
    ),
    Container(
    alignment: Alignment.centerLeft,
    child: Text(
    state.errorText ?? '',
    textAlign: TextAlign.left,
    style: TextStyle(color: Theme.of(context).colorScheme.error,fontSize: 12,),
    ),
    )
    ],
    );
    },
    validator: (value) {
    if (!checkboxValue) {
    return 'You need to accept terms and conditions';
    } else {
    return null;
    }
    },
    ),
    const SizedBox(height: 20.0),
    Container(
    decoration: ThemeHelper().buttonBoxDecoration(context),
    child: ElevatedButton(
    style: ThemeHelper().buttonStyle(),
    child: Padding(
    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
    child: Text(
    "Register".toUpperCase(),
    style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
    builder: (context) => const ProfilePage()
    ),
    (Route<dynamic> route) => false
    );
    }
    },
    ),
    ),
    const SizedBox(height: 30.0),
    const Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
    const SizedBox(height: 25.0),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    GestureDetector(
    child: FaIcon(
    FontAwesomeIcons.googlePlus, size: 35,
    color: HexColor("#EC2D2F"),),
    onTap: () {
    setState(() {
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return ThemeHelper().alartDialog("Google Plus","You tap on GooglePlus social icon.",context);
    },
    );
    });
    },
    ),
    const SizedBox(width: 30.0,),
    GestureDetector(
    child: Container(
    padding: const EdgeInsets.all(0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(100),
    border: Border.all(width: 5, color: HexColor("#40ABF0")),
    color: HexColor("#40ABF0"),
    ),
      child: FaIcon(
        FontAwesomeIcons.twitter, size: 23,
        color: HexColor("#FFFFFF"),),
    ),
      onTap: () {
        setState(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ThemeHelper().alartDialog("Twitter","You tap on Twitter social icon.",context);
            },
          );
        });
      },
    ),
      const SizedBox(width: 30.0,),
      GestureDetector(
        child: FaIcon(
          FontAwesomeIcons.facebook, size: 35,
          color: HexColor("#3E529C"),),
        onTap: () {
          setState(() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThemeHelper().alartDialog("Facebook",
                    "You tap on Facebook social icon.",
                    context);
              },
            );
          });
        },
      ),
    ],
    ),
    ],
    ),
    ),
    ],
    ),
    ),
        ],
        ),
        ),
    );
  }
}

