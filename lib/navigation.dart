import 'package:danmusic/ui/screens/album/album_screen.dart';
import 'package:danmusic/ui/screens/artist/artist_screen.dart';
import 'package:danmusic/ui/screens/current_playlist/current_playlist.dart';

import 'ui/screens/player/player.dart';
import 'ui/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

import 'ui/screens/playlist/playlist_screen.dart';
import 'ui/screens/search/search_screen.dart';

class RouteName {
  static const String home = HomeScreen.routeName;
  static const String player = Player.routeName;
  static const String search = SearchScreen.routeName;
  static const String playlist = PlaylistScreen.routeName;
  static const String album = AlbumScreen.routeName;
  static const String artist = ArtistScreen.routeName;
  static const String currentPlaylist = CurrentPlaylist.routeName;
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteName.player:
        return MaterialPageRoute(builder: (_) => Player());
      case RouteName.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      case RouteName.playlist:
        //final args = settings.arguments as Map<String, dynamic>;
        final id = (settings.arguments as List)[0] as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PlaylistScreen(key: Key(id)),
        );

      case RouteName.album:
        final id = (settings.arguments as List)[0] as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AlbumScreen(key: Key(id)),
        );
      case RouteName.artist:
        final id = (settings.arguments as List)[0] as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ArtistScreen(key: Key(id)),
        );
      case RouteName.currentPlaylist:
        if (settings.arguments == null) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => CurrentPlaylist(),
          );
        }
        final id = (settings.arguments as List)[0] as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CurrentPlaylist(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
