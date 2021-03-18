import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'data/data.dart';
import 'extras/extras.dart';
import 'models/user_item.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  await preferences.putAppDeviceInfo();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of rent-a-tool-sample application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RequestNotifier()),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        initialRoute: preferences.getBool(SharedPreference.IS_LOGGED_IN)
            ? Routes.dashboardRoute
            : Routes.defaultRoute,
        routes: {
          Routes.defaultRoute: (context) => LoginPage(),
          Routes.registrationRoute: (context) => RegistrationPage(),
          Routes.dashboardRoute: (context) => Dashboard(),
          Routes.editUserProfile: (context) => UserProfile(),
        },
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0XFF8B8F95),
          splashColor: Color(0x803E454F),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: Theme.of(context).textTheme.copyWith(
                bodyText1: GoogleFonts.muli(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E454F),
                  fontSize: 20,
                ),
              ),
          textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
                cursorColor: Color(0XFF8B8F95),
              ),
        ),
      ),
    );
  }
}
