import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empresas_cliente/providers/address_provider.dart';
import 'package:empresas_cliente/providers/user_provider.dart';
import 'package:empresas_cliente/screens/account.dart';
//import 'package:empresas_cliente/screens/history.dart';
import 'package:empresas_cliente/screens/category.dart';
import 'package:empresas_cliente/screens/home.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:geocoding/geocoding.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

var logger = Logger(
  printer: PrettyPrinter(),
  filter: null,
  output: null,
);

Future<Map<String, dynamic>> getCurrentLocation() async {
  final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  final latitude = position.latitude;
  final longitude = position.longitude;

  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  Placemark place = placemarks[0];
  String addr = "${place.street}, ${place.locality}, ${place.country}";

  final Map<String, dynamic> currentLocation = {
    'latitude': latitude,
    'longitude': longitude,
    'address': addr,
  };

  return currentLocation;
}

class Screenhandler extends StatefulWidget {
  const Screenhandler({super.key});

  @override
  State<Screenhandler> createState() => _ScreenhandlerState();
}

class _ScreenhandlerState extends State<Screenhandler> {
  final db = FirebaseFirestore.instance;
  //final databaseReference = FirebaseDatabase.instance.ref();

  final userName = FirebaseAuth.instance.currentUser!.displayName;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  final userPhoto = FirebaseAuth.instance.currentUser!.photoURL;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late String adress;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _screens() {
    return [
      const HomePage(),
      // const History(),
      const Category(),
      const Account(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Inicio',
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      // Eliminamos la referencia a History
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.schedule),
      //   title: 'Historial',
      //   activeColorPrimary: Colors.blue,
      //   inactiveColorPrimary: Colors.grey,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.category),
        title: 'Categorías',
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: 'Cuenta',
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  void saveUserDataToFireStore() {
    final client = <String, dynamic>{
      'name': userName.toString(),
      'email': userEmail.toString(),
      'photoUrl': userPhoto.toString(),
    };

    db.collection('clients').doc(uid).set(client);
  }

  int selectedIndex = 0;

  @override
  void initState() {
    //saveUserDataToFirebase();
    saveUserDataToFireStore();
    getCurrentLocation().then((value) {
      Provider.of<AddressProvider>(context, listen: false)
          .setAddressData(value);
    });
    Future.delayed(Duration.zero, () async {
      Provider.of<UserProvider>(context, listen: false).setUserId(uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PersistentTabView(
          context,
          navBarHeight: 60.0,
          controller: _controller,
          screens: _screens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          navBarStyle: NavBarStyle.style1,
        ),
      ),
    );
  }
}
