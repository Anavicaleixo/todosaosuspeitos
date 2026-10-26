import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/supabase_config.dart';
import 'core/constants/app_colors.dart';
import 'services/supabase_service.dart';
import 'screens/case_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      // ignore: deprecated_member_use
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Aviso Supabase: Inicializando com fallback offline: $e');
  }

  runApp(const CaseFilesApp());
}

class CaseFilesApp extends StatelessWidget {
  const CaseFilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SupabaseService()),
      ],
      child: MaterialApp(
        title: 'CASE FILES - Agência de Investigação',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.goldDark,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.goldBright,
            secondary: Color(0xFFA855F7),
            surface: AppColors.surface,
          ),
          textTheme: GoogleFonts.montserratTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        home: const CaseMapScreen(),
      ),
    );
  }
}
