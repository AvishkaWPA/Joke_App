import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hello_flutter_app/models/Jokes.dart';

class JokeService {
  static const String _cacheKey = 'cached_jokes';
  final SharedPreferences _prefs;

  JokeService(this._prefs);

  Future<List<Joke>> fetchJokes() async {
    try {
      final response = await http.get(
        Uri.parse('https://v2.jokeapi.dev/joke/Programming?type=single&amount=5'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final jokes = (jsonData['jokes'] as List)
            .map((jokeData) => Joke.fromJson({
          'id': jokeData['id'].toString(),
          'joke': jokeData['joke'],
        }))
            .toList();

        // Cache the jokes
        await cacheJokes(jokes);
        return jokes;
      }
      throw Exception('Failed to load jokes');
    } catch (e) {
      // Return cached jokes if available
      return getCachedJokes();
    }
  }

  Future<void> cacheJokes(List<Joke> jokes) async {
    final jokesJson = jokes.map((joke) => joke.toJson()).toList();
    await _prefs.setString(_cacheKey, json.encode(jokesJson));
  }

  List<Joke> getCachedJokes() {
    final cachedData = _prefs.getString(_cacheKey);
    if (cachedData != null) {
      final List<dynamic> jsonList = json.decode(cachedData);
      return jsonList.map((json) => Joke.fromJson(json)).toList();
    }
    return [];
  }
}
