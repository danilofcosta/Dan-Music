import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/ui/screens/album_page/album_page.dart';
import '/ui/screens/home_page/home_page.dart';
import '/ui/screens/playlist_page/playlist_page.dart';
import 'ui/screens/artist_page/artist_page.dart';
import 'ui/screens/fila_player/file_player.dart';
import 'ui/screens/player_page/player_page.dart';
import 'ui/screens/search_page/search_page.dart';

class ScreenNavigationSetup {
  ScreenNavigationSetup._();

  static const id = 1;
  static const homeScreen = '/homeScreen';
  static const searchScreen = '/searchScreen';
  static const playerScreen = '/playerScreen';
  static const albumScreen = '/albumScreen';
  static const filaScreen = '/filaScreen';
  static const playlistScreen = '/playlistScreen';
  static const artistScreen = '/artistScreen';
}

class NavigationRotes extends StatelessWidget {
  const NavigationRotes({super.key});

  @override
  Widget build(BuildContext context) {
    final navKey = Get.nestedKey(ScreenNavigationSetup.id);

    return PopScope(
      canPop: false, // impede o pop automático
      onPopInvoked: (didPop) async {
        // se o pop já foi tratado, não faz nada
        if (didPop) return;

        final navigator = navKey!.currentState!;

        // tenta voltar dentro do nested navigator
        final canPopInside = await navigator.maybePop();

        if (!canPopInside) {
          // se não tem mais telas dentro do nested,
          // permita que o app feche
          Navigator.of(context).maybePop();
        }
      },
      child: Navigator(
        key: navKey,
        initialRoute: ScreenNavigationSetup.homeScreen,
        onGenerateRoute: (settings) {
          Get.routing.args = settings.arguments;

          switch (settings.name) {
            case ScreenNavigationSetup.homeScreen:
              return GetPageRoute(
                page: () => const HomePage(),
                settings: settings,
              );

            case ScreenNavigationSetup.playlistScreen:
              final id = (settings.arguments as List)[1] as String;
              return GetPageRoute(
                page: () => PlaylistPage(key: Key(id)),
                settings: settings,
              );
            case ScreenNavigationSetup.playerScreen:
              return GetPageRoute(
                    page: () => const PlayerPage(),
                    settings: settings,
                  )
                  as Route;

            case ScreenNavigationSetup.albumScreen:
              final id = (settings.arguments as List)[1] as String;
              return GetPageRoute(
                page: () => AlbumPage(key: Key(id)),
                settings: settings,
              );

            case ScreenNavigationSetup.filaScreen:
              return GetPageRoute(
                page: () => const FilePlayer(),
                settings: settings,
              );

            case ScreenNavigationSetup.searchScreen:
              return GetPageRoute(
                page: () => const SearchPage(),
                settings: settings,
              );
            case ScreenNavigationSetup.artistScreen:
              final id = (settings.arguments as List)[1] as String;
              return GetPageRoute(
                page: () => ArtistPage(key: Key(id)),
                settings: settings,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
