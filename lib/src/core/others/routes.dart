import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/modules/history/history_cubit.dart';
import 'package:share_records/src/modules/history/history_screen.dart';
import 'package:share_records/src/modules/home_screen.dart';
import 'package:share_records/src/modules/my_shares/my_share_cubit.dart';
import 'package:share_records/src/modules/my_shares/my_share_screen.dart';
import 'package:share_records/src/modules/others/splash_screen.dart';
import 'package:share_records/src/modules/portfolio/portfolio_cubit.dart';
import 'package:share_records/src/modules/portfolio/portfolio_screen.dart';
import 'package:share_records/src/settings/settings_controller.dart';
import 'package:share_records/src/settings/settings_view.dart';

class RouteManager {
  static Route? onGenerateRoute(RouteSettings settings, SettingsController settingsController) {
    switch (settings.name) {
      case "/splash":
        return MaterialPageRoute(
          builder: (context) => const SplashScreen()
        );

      case "/settingsView":
        return MaterialPageRoute(
          builder: (context) => SettingsView(controller: settingsController)
        );

      case "/home":
        return MaterialPageRoute(
          builder: (context) => const HomeScreen()
        );
      
      // case "/ipoResult":
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider(
      //       create: (context) => IpoResultCubit(),
      //       child: const IpoResultScreen(),
      //     )
      //   );
      
      case "/portfolio":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => PortfolioCubit(),
            child: const PortfolioScreen(),
          )
        );

      case "/myShares":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => MySharesCubit(),
            child: const MySharesScreen(),
          )
        );

      case "/history":
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HistoryCubit(),
            child: const HistoryScreen(),
          )
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen()
        );
    }
  }
}