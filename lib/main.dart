import 'package:buy_and_sell_used_stuff_mobile_application/pages/favorites_page/FavoritesPage.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/home_page/home_page.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/profile_page/ProfilePage.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/search_screen/search_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/pages/sign_in_page/Sign_in_screen.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomAppTheme.lightTheme,
      darkTheme: CustomAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitSpinningLines(
                color: Colors.orange,
                size: 50.0,
              ),
            );
          } else if (user.hasData) {
            return const Home();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final items = [
    Icon(Icons.home, size: avgDimension(30)),
    Icon(Icons.search, size: avgDimension(30)),
    Icon(Icons.favorite, size: avgDimension(30)),
    Icon(Icons.person, size: avgDimension(30)),
  ];
  int index = 0;

  User? getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: AppColors.lightBackgroundColor,
          ),
        ),
        child: CurvedNavigationBar(
          color: AppColors.navigationBarColor,
          buttonBackgroundColor: AppColors.navigationBarSelectedIconColor,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 500),
          height: avgDimension(60),
          items: items,
          index: index,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
        ),
      ),
      body: Container(
        child: getSelectedWidget(
          index: index,
        ),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    late Widget widget;
    switch (index) {
      case 0:
        widget = const HomePage();
        break;
      case 1:
        widget = const ProductSearchPage();
        break;
      case 2:
        User? currentUser = getCurrentUser();
        if (currentUser != null) {
          widget = FavoriteListPage(userId: currentUser.uid);
        }
        break;
      default:
        widget = const ProfilePage();
        break;
    }
    return widget;
  }
}
