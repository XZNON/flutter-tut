import 'package:flutter/material.dart';
import 'package:flutter_tut/providers/bucket_location_provider.dart';
import 'package:flutter_tut/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseUrl = dotenv.env["SUPABASE_URL"];
  final supabaseAnonKey = dotenv.env["SUPABASE_ANON_KEY"];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception("Supabase environment variables not found.");
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider()
            ..listenToAuth()
            ..startRealtime(),
        ),
        ChangeNotifierProvider(create: (_) => BucketLocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = snapshot.data?.session;

          if (session == null) {
            return const AuthScreen();
          }

          return const HomeScreen();
        },
      ),
    );
  }
}
