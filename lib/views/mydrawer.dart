import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final int selected;
  final String username;
  final void Function(int index) changeSelection;
  final VoidCallback toggleSelection;
  final VoidCallback doLogout;
  final void Function(String index) onTap;
  final bool showComplete;
  

  const MyDrawer({
    required this.selected, required this.changeSelection,
    super.key, required this.toggleSelection, required this.doLogout, required this.username, required this.showComplete, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Center( 
              child : ListTile(
                title: const Text(
                  "Battleships",
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.0,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Logged in as $username",
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.0,
                  style: const TextStyle(color: Colors.white,fontSize: 7),
                ),
              )),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("New game"),
            // selected: selected == 0,
            onTap: (){
              Navigator.pop(context);
              onTap("");
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy_outlined),
            title: const Text("New game (AI)"),
            // selected: selected == 1,
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context, 
                builder: (context)=>SimpleDialog(
                  title: const Text('Which AI do you want to play against?'),
                  contentPadding: const EdgeInsets.all(20.0),
                  //alignment: Alignment.centerLeft,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                      onTap('Random');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ), 
                    child: const Text('random',textAlign: TextAlign.left,),),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                      onTap('perfect');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ), 
                    child: const Text('Perfect', textAlign: TextAlign.left),),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                      onTap('oneship');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ), 
                    child: const Text('One ship (AI)', textAlign: TextAlign.left,),),
                  ],
                ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: Text(showComplete ? "Show ative agmes": "Show completed games"),
            // selected: selected == 2,
            onTap: () {
              changeSelection(2);
              toggleSelection();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            // selected: selected == 2,
            onTap: () {
              doLogout();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
