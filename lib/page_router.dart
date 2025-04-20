import 'package:flutter/material.dart';
import 'nearby_hospitals.dart';
import 'crop_prices.dart';
import 'news_update.dart';
import 'help.dart';
import 'health.dart';
import 'schemes.dart';
import 'weather.dart';
import 'digilocker.dart';

/// Returns the route to the corresponding page based on a topic keyword.
Route<dynamic>? getPageRouteByTopic(BuildContext context, String topic) {
  final lower = topic.toLowerCase();
  if (lower.contains('hospital')) {
    return MaterialPageRoute(builder: (_) => const NearbyHospitalsPage());
  } else if (lower.contains('crop')) {
    return MaterialPageRoute(builder: (_) => const CropPricesPage());
  } else if (lower.contains('news')) {
    return MaterialPageRoute(builder: (_) => const NewsUpdatePage());
  } else if (lower.contains('help')) {
    return MaterialPageRoute(builder: (_) => const HelpPage());
  } else if (lower.contains('health')) {
    return MaterialPageRoute(builder: (_) => const HealthPage());
  } else if (lower.contains('scheme')) {
    return MaterialPageRoute(builder: (_) => const SchemesPage());
  } else if (lower.contains('weather')) {
    return MaterialPageRoute(builder: (_) => const WeatherPage());
  } else if (lower.contains('digilocker')) {
    return MaterialPageRoute(builder: (_) => const DigiLockerPage());
  }
  return null;
}
