import 'dart:convert';

import 'package:battleships/models/gameData.dart';
import 'package:battleships/utils/sessionmanager.dart';
import 'package:battleships/views/cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ViewGame extends StatefulWidget{

  final VoidCallback onTap;
  final String baseUrl;
  final int gameId;

  const ViewGame({super.key, required this.baseUrl,required this.onTap, required this.gameId});


  Future<GameData> getGame(gameId) async {
    final response = await http.get(Uri.parse('${baseUrl}/$gameId'),headers: {'Authorization' : 'Bearer ${await SessionManager.getSessionToken()}'});
    final game = json.decode(response.body);
    return GameData.fromJson(game);
  }

  Future<dynamic> putGame(int gameId,String shot) async {
    final response = await http.put(Uri.parse('${baseUrl}/$gameId'),body: jsonEncode({
      'shot': shot
    }),
    headers: {
      'Content-Type': 'application/json',
      'Authorization' : 'Bearer ${await SessionManager.getSessionToken()}'});
    final posts = json.decode(response.body);
    return posts;
  }

  @override
  State createState() => ViewGame2();
}


class ViewGame2 extends State<ViewGame> {
  Future<GameData>? futureGame;

  @override
  void initState() {
    super.initState();
    _getGame();
  }

  Future<void> _getGame() async {
    setState(() {
      futureGame = widget.getGame(widget.gameId);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Game'),
      ),
      body : FutureBuilder<GameData>(
        future: futureGame,
        initialData: null,
        builder: (context, snapshot) {
          var game = snapshot.data;
          if (snapshot.hasData) {
            Set shot = Set();
            return Column(
                children: [
                  Row(
                    children: List.generate(6, (index) => Cell(isNewGame: false, isCount: game!.ships.toSet(), isSelected: false,index: index ==0 ? 0 : 48+index,) ),
                  ),
                  for(int i=0;i<5;i++)
                    Row(
                      children: List.generate(6, (index) => Cell(wreck: game!.wrecks.toSet(),sunks: game.sunk.toSet(),shots: game.shots.toSet(),shot: shot, isNewGame: false, alpha: 65+i, isCount: game.ships.toSet(), isSelected: false,index: index==0 ? 65+i : index)),
                    ),
                  ElevatedButton(
                    onPressed: game!.turn != game.position || game.status==1 || game.status==2 ? null : () async {
                      print("submit");
                      widget.onTap();
                      var posts = await widget.putGame(game.id, shot.elementAt(0));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: posts['sunk_ship'] ? const Text('Ship sunk!') : const Text('No enemy ship hit')),
                      );
                      _getGame();
                      widget.onTap();
                      if(game.sunk.length==4 && posts['sunk_ship'])
                        showDialog(
                          context: context, 
                          builder: (context)=>AlertDialog(
                            title: Text('Game Over'),
                            content: Text('You won'),
                            actions: [
                              TextButton(onPressed: ()=> Navigator.pop(context), child: Text('OK'))
                            ],
                          ));
                    },
                    child: Text('Submit'),
                  ),
                      
                ],
              );
          }else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
    );
  }
}