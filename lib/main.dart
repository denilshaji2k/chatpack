import 'package:chatpack/pages/splash_page_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/authentication_provider.dart';
import './services/navigation_service.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import '../pages/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(const MainApp());
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(create: (BuildContext context) => AuthenticationProvider()),
      ],
      child: MaterialApp(
                debugShowCheckedModeBanner: false,

        title: 'ChatPack Messenger',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 49, 45, 110),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.black),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) =>  HomePage(), 
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }
}
