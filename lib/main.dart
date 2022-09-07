import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Connect 4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int columns = 6, rows = 7;

  List gameGrid = [];

  @override
  void initState() {
      super.initState();
      initGrid();
  }

  initGrid() {
    setState(() {
      gameGrid = List<int>.generate((columns * rows), (int index) => 0, growable: false);
    });
  }

  clickGridItem(index) {
    int auxIndex = index;
    if(gameGrid[auxIndex] == 0) { // Manage below rows
      while(auxIndex < gameGrid.length - columns && gameGrid[auxIndex + columns] == 0) {
        auxIndex += columns;
      }
    } else { // Manage above rows
      while(auxIndex >= columns && gameGrid[auxIndex - columns] != 0) {
        auxIndex -= columns;
      }
      if(auxIndex >= columns) {
        auxIndex -= columns;
      }
    }
    setState(() {
      gameGrid[auxIndex] = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: columns,
              children: List.generate(gameGrid.length,(index){
                return GestureDetector(
                  onTap: () {
                    clickGridItem(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: gameGrid[index] == 0 ? Colors.white : Colors.black,
                      border: Border.all(
                        color: Colors.black54
                      ),
                      borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                );
              })
            ),
            ElevatedButton(
              onPressed: (){ initGrid(); },
              child: const Text('RESET')
            )
          ],
        ),
      ),
    );
  }
}
