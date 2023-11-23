import 'dart:convert';
import 'package:battleships/views/loginscreen.dart';
import 'package:battleships/views/mydrawer.dart';
import 'package:battleships/views/newgame.dart';
import 'package:battleships/views/viewGame.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/sessionmanager.dart';

class HomeScreen extends StatefulWidget {
  final String baseUrl = 'http://165.227.117.48/games';

  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>>? futurePosts;
  String userName='';

  int _selectedIndex = 0;
  bool _showComplete = false;

  void _changeSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSelection() {
    setState(() {
      _showComplete = !_showComplete;
    });
    _refreshPosts();
  }

  @override
  void initState() {
    super.initState();
    futurePosts = _loadGames();
    _showComplete = false;
    _selectedIndex = 0;
  }

  Future<void> _getUserName() async {
    final name = await SessionManager.getSessionUserName();
    setState(() {
      userName = name;
    });
  }

  Future<List<dynamic>> _loadGames() async {
    final response = await http.get(Uri.parse(widget.baseUrl),headers: {'Authorization' : 'Bearer ${await SessionManager.getSessionToken()}'});
    final posts = json.decode(response.body);
    return posts['games'];
  }


  Future<void> _addGame(Set game,String ai) async {
    var body = (ai=='') ? jsonEncode({'ships': game.map((e) => e).toList(),}) : jsonEncode({
        'ships': game.map((e) => e).toList(),
        'ai' : ai
      });
    await http.post(Uri.parse(widget.baseUrl),body: body, headers: {
        'Content-Type': 'application/json',
        'Authorization' : 'Bearer ${await SessionManager.getSessionToken()}'
        });
    _refreshPosts();
  }

  Future<void> _deleteGame(gameId) async {
    final response = await http.delete(Uri.parse('${widget.baseUrl}/$gameId'),headers: {'Authorization' : 'Bearer ${await SessionManager.getSessionToken()}'});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game forfeited')),
      );
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      futurePosts = _loadGames();
    });
  }

  Future<void> _doLogout() async {
    await SessionManager.clearSession();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _getUserName();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battlehips"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshPosts(),
          ),
        ],
      ),
      drawer: MyDrawer(
        selected: _selectedIndex, 
        changeSelection: _changeSelection, 
        toggleSelection: _toggleSelection,
        doLogout: _doLogout,
        username: userName, showComplete: _showComplete,
        onTap: (String ai) {
          Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NewGame(addGame: _addGame,ai: ai);
            }
          ),
        );},
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePosts,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var snapFilter = snapshot.data!.where((e) =>_showComplete ?  e['status']==1 || e['status']==2 : e['status']==0 || e['status']==3).toList();
            return ListView.builder(
              itemCount: snapFilter.length,
              itemBuilder: (context, index) {
                final post = snapFilter[index];
                return Dismissible(
                  direction: _showComplete ? DismissDirection.none : DismissDirection.horizontal,
                  key: Key(post['id'].toString()),
                  onDismissed: _showComplete ? null : (_) {
                    snapshot.data!.remove(snapFilter[index]);
                    snapFilter.removeAt(index);
                    _deleteGame(post['id']);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(Icons.delete),
                  ),
                  
                  child: ListTile(
                    onTap: () async {
                      // GameData game = await _getGame(post['id']);
                      // Set shot = Set();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewGame(baseUrl: widget.baseUrl, onTap: (){
                              _refreshPosts();
                            }, gameId: post['id'],);
                          }
                        ),
                      );
                    },
                    leading: Text(post['status'] == 0 ? '#${post['id']} Waiting for opponent' : '#${post['id']} ${post['player1']} vs ${post['player2']}', style: const TextStyle(fontSize: 15),),
                    trailing: Text(post['status'] == 0 ? 'matchmaking' : post['turn']==0 ? post['position'] == post['status'] ? 'gameWon' : 'gameLost' : post['turn'] == post['position'] ? 'myTurn' : 'opponentTurn'),
                  ),);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

}
