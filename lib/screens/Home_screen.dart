import 'package:flutter/material.dart';
import '../services/joke_service.dart';
import 'package:hello_flutter_app/models/Jokes.dart';

class HomeScreen extends StatefulWidget {
  final JokeService jokeService;

  const HomeScreen({super.key, required this.jokeService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Joke> _jokes = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCachedJokes();
  }

  Future<void> _loadCachedJokes() async {
    final cachedJokes = widget.jokeService.getCachedJokes();
    setState(() {
      _jokes = cachedJokes;
    });
  }

  Future<void> _fetchNewJokes() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final jokes = await widget.jokeService.fetchJokes();
      setState(() {
        _jokes = jokes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load jokes. Showing cached content.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: const Text(
          'Fun Programming',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,

          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildJokesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[500],
        //borderRadius: const BorderRadius.only(
        //  bottomLeft: Radius.circular(30),
         // bottomRight: Radius.circular(30),
        //),
      ),
      child: Row(
        children: [
          const Text(
            'Need a laugh?   ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _fetchNewJokes,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),

            ),
            icon: _isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue[700]!,
                ),
              ),
            )
                : const Icon(Icons.mood),
            label: Text(
              _isLoading ? 'Fetching Jokes...' : 'Fetch New Jokes',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJokesList() {
    if (_jokes.isEmpty && !_isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No jokes available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: _fetchNewJokes,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _jokes.length,
          itemBuilder: (context, index) {
            final joke = _jokes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mood,
                              color: Colors.green[500],
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'JOKE ${index + 1}',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          joke.content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}