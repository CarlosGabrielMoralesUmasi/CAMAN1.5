// inicial snippet code for login.dart
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:empresas_cliente/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account extends StatefulWidget {
  const Account({
    super.key
  });

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 16.0),
                    child: Text(
                      "Cuenta",
                      style: TextStyle(
                        fontSize: textScale*30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ) 
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Imagen
                  const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                  ),
                  if (currentUser != null && currentUser!.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(currentUser!.photoURL!),
                      radius: 35,
                  ),
                  // Nombre y correo
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),        
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                          child: Text(
                            FirebaseAuth.instance.currentUser!.displayName.toString(),
                            style: TextStyle(
                              fontSize: textScale * 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                          child: Text(
                            FirebaseAuth.instance.currentUser!.email.toString(),
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: textScale*15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  // QR 
                  const Spacer(), 
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.qr_code,
                      color: Colors.black.withOpacity(0.4),
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            
          // Cerrar sesion
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {AuthService().signOut();},
              style:  ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), elevation: MaterialStateProperty.all<double>(0.0), overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black.withOpacity(0.4),
                    size: 19.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Cerrar sesión",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: textScale*19.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black.withOpacity(0.4),
                    size: 19.0,
                  ),
                ],
              ),
            ),
          ), 
          ],
        ),
      ),
    );
  }
}