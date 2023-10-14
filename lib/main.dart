import 'package:empresas_cliente/providers/address_provider.dart';
import 'package:empresas_cliente/providers/user_provider.dart';
import 'package:empresas_cliente/services/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AddressProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          )
        ],
        child: MaterialApp(
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: AuthService().handleAuthState(),
        ));
  }
}
