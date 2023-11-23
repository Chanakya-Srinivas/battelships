import 'package:battleships/views/cell.dart';
import 'package:flutter/material.dart';

class NewGame extends StatefulWidget {

  final void Function(Set ships,String ai) addGame;
  final String ai;

  const NewGame({super.key, required this.addGame, required this.ai});

  @override
  State createState() => NewGame2();
}


class NewGame2 extends State<NewGame> {

  var colors = List.generate(6, (_) => List.generate(6,(_) => false));
  var isSelected = List.generate(6, (_) => List.generate(6,(_) => false));
  var isCount = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place ships'),
      ),
      body: Column(
        children: [
          Row(
            children: List.generate(6, (index) => Cell(isNewGame: true, isCount: isCount, isSelected: isSelected[0][index],index: index ==0 ? 0 : 48+index,) ),
          ),
          Row(
            children: List.generate(6, (index) => Cell(isNewGame: true, alpha: 65, isCount: isCount, isSelected: isSelected[1][index],index: index==0 ? 65 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Cell(isNewGame: true, alpha: 66, isCount: isCount, isSelected: isSelected[2][index],index: index==0 ? 66 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Cell(isNewGame: true, alpha: 67, isCount: isCount, isSelected: isSelected[3][index],index: index==0 ? 67 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Cell(isNewGame: true, alpha: 68, isCount: isCount, isSelected: isSelected[4][index],index: index==0 ? 68 : index)),
          ),
          Row(
            children: List.generate(6, (index) => Cell(isNewGame: true, alpha: 69, isCount: isCount, isSelected: isSelected[5][index],index: index==0 ? 69 : index)),
          ),
          ElevatedButton(
            onPressed: () {
             if(isCount.length<5){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You must place five ships')),
              );
             }else {
              Navigator.pop(context);
              String k = "[\"${isCount.join("\", \"")}\"]";
              print(k);
              widget.addGame(isCount,widget.ai);
             }
            },
            child: Text('Submit'),
          )
          
        ],
      ),
    );
  }

}