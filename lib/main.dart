import 'package:armiyaapp/providers/appoinment/appoinment_provider.dart';
import 'package:armiyaapp/providers/appoinment/membergroups_provider.dart';
import 'package:armiyaapp/providers/appoinment/misafir_add_provider.dart';
import 'package:armiyaapp/providers/iptal_randevu_provider.dart';
import 'package:armiyaapp/view/onboarding/LogoAnimationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppointmentProvider()),
      ChangeNotifierProvider(create: (context) => MisafirAddProvider()),
      ChangeNotifierProvider(create: (context) => MemberGroupsProvider()),
      ChangeNotifierProvider(create: (context) => IptalRandevuProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [Locale('tr')],
      home: LogoAnimationScreen(),
    );
  }
}
