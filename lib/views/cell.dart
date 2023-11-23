import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  
  bool isSelected;
  int index;
  Set isCount;
  int? alpha;
  bool isNewGame;
  Set? shot;
  Set? shots;
  Set? sunks;
  Set? wreck;

  Cell({super.key,this.shots,this.sunks,this.wreck,required this.isSelected,required this.index,required this.isCount,this.alpha,required this.isNewGame,this.shot});

  @override
  State createState() => CellUnit();
}

class CellUnit extends State<Cell> {

  bool color = false;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
              onHover: (isHover){
                if(widget.index<6) {
                  setState(() {
                    color = !color;
                  });
                }
              },
              onTap: (){
                if(widget.index<6 && (widget.sunks==null || widget.sunks!.length < 5 && widget.wreck!.length < 5 && !widget.shots!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))){
                  setState(() {
                    if(widget.isSelected == true){
                      widget.isSelected = !widget.isSelected;
                      widget.isNewGame ?
                      widget.isCount.remove(String.fromCharCode(widget.alpha!)+widget.index.toString()) :
                      widget.shot!.remove(String.fromCharCode(widget.alpha!)+widget.index.toString());
                    }else if((widget.isNewGame && widget.isCount.length<5 )||( !widget.isNewGame && widget.shot!.isEmpty)) {
                      widget.isSelected = !widget.isSelected;
                      widget.isNewGame ?
                      widget.isCount.add(String.fromCharCode(widget.alpha!)+widget.index.toString()) :
                      widget.shot!.add(String.fromCharCode(widget.alpha!)+widget.index.toString());
                    }
                  });
                }
              },
              child: Container(
                color: color ? widget.isSelected ? widget.isNewGame ? Colors.purple[400] : Colors.red[500] : Colors.grey[300]: widget.isSelected ? widget.isNewGame? Colors.blue : Colors.red[300] : Colors.grey[50],
                height:  ((MediaQuery.of(context).size.height ~/ 7) - 7).toDouble(),
                width:  ((MediaQuery.of(context).size.width ~/ 6)).toDouble(),
                child: Center( child : (widget.alpha!=null && !widget.isNewGame) ? Row ( 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(widget.index>6)
                      Text(String.fromCharCode(widget.index)),
                    if(widget.isCount.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const Icon(IconData(0xefc2, fontFamily: 'MaterialIcons'))
                    else if(widget.wreck!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const ImageIcon(AssetImage('assets/bubbles.png')),
                    if(widget.sunks!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const ImageIcon(AssetImage('assets/explosion.png'))
                    else if(widget.shots!.contains(String.fromCharCode(widget.alpha!)+widget.index.toString()))
                      const ImageIcon(AssetImage('assets/bomb.png')),
                  ]) : 
                Text(widget.index<6 ?  "" : String.fromCharCode(widget.index))),
              ),
            ) ;
  }
  
}