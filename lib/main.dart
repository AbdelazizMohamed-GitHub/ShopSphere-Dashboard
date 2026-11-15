import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_keys.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/features/shop_shere_dashboard_app.dart';
import 'package:shop_sphere_dashboard/firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GoRouter.optionURLReflectsImperativeAPIs = true;
  setupLocator();
  usePathUrlStrategy();
   await Supabase.initialize(
    url: AppKeys.supbaseUrl,
    anonKey: AppKeys.supbaseApiKey,
  );

  runApp(ShopSphereDashboardApp());
}
