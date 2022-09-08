import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect 4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
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

  int currentPlayer = 1;
  int player1score = 0, player2score = 0;
  Color player1color = Colors.red, player2color = Colors.yellow;

  @override
  void initState() {
      super.initState();
      initGame();
  }

  initGame() {
    initGrid();
    setState(() {
      currentPlayer = (player1score + player2score) % 2 == 0 ? 1 : 2;
    });
  }

  resetGame() {
    initGrid();
    setState(() {
      player1score = 0;
      player2score = 0;
      currentPlayer = (player1score + player2score) % 2 == 0 ? 1 : 2;
    });
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
      gameGrid[auxIndex] = currentPlayer;
    });
    bool win = checkWin(lastIndex: auxIndex);
    if(win) {
      if(currentPlayer == 1) {
        player1score++;
      } else {
        player2score++;
      }

      initGame();
    } else {
      setState(() {
        currentPlayer = currentPlayer == 1 ? 2 : 1;
      });
    }
  }

  checkWin({required lastIndex}) {
    bool horizontalWin = checkHorizontalWin(lastIndex);
    if(horizontalWin) {
      return true;
    }

    bool verticalWin = checkVerticalWin(lastIndex);
    if(verticalWin) {
      return true;
    }

    return checkDiagonalWin(lastIndex);
  }

  checkHorizontalWin(lastIndex) {
    int leftCount = 0, rightCount = 0;
    int horizontalPosition = lastIndex % columns; // 0 is left

    while(horizontalPosition - leftCount - 1 >= 0 && gameGrid[lastIndex - leftCount - 1] == currentPlayer) {
      leftCount++;
    }
    while(horizontalPosition + rightCount + 1 < columns && gameGrid[lastIndex + rightCount + 1] == currentPlayer) {
      rightCount++;
    }
    // We add the 1 for the current position
    return (leftCount + rightCount + 1 >= 4);
  }

  checkVerticalWin(lastIndex) {
    int bottomCount = 0;
    int verticalPosition = (lastIndex ~/ columns); // 0 is top
    
    while(verticalPosition + bottomCount + 1 < rows && gameGrid[lastIndex + ((bottomCount + 1) * columns)] == currentPlayer) {
      bottomCount++;
    }
    // We add the 1 for the current position
    return (bottomCount + 1 >= 4);
  }

  checkDiagonalWin(lastIndex) {
    int topLeftCount = 0, bottomLeftCount = 0, topRightCount = 0, bottomRightCount = 0;
    int verticalPosition = (lastIndex ~/ columns); // 0 is top
    int horizontalPosition = lastIndex % columns; // 0 is left
    
    while(
      verticalPosition - topLeftCount - 1 >= 0 &&
      horizontalPosition - topLeftCount - 1 >= 0 &&
      gameGrid[lastIndex - ((topLeftCount + 1) * columns + (topLeftCount + 1))] == currentPlayer
    ) {
      topLeftCount++;
    }

    while(
      verticalPosition + bottomRightCount + 1 < rows &&
      horizontalPosition + bottomRightCount + 1 < columns &&
      gameGrid[lastIndex + ((bottomRightCount + 1) * columns + (bottomRightCount + 1))] == currentPlayer
    ) {
      bottomRightCount++;
    }
    
    if(topLeftCount + bottomRightCount + 1 >= 4) return true;

    while(
      verticalPosition + bottomLeftCount + 1 < rows &&
      horizontalPosition - bottomLeftCount - 1 >= 0 &&
      gameGrid[lastIndex + ((bottomLeftCount + 1) * columns - (bottomLeftCount + 1))] == currentPlayer
    ) {
      bottomLeftCount++;
    }
    
    while(
      verticalPosition - topRightCount - 1 >= 0 &&
      horizontalPosition + topRightCount + 1 < columns &&
      gameGrid[lastIndex - ((topRightCount + 1) * columns - (topRightCount + 1))] == currentPlayer
    ) {
      topRightCount++;
    }

    return (bottomLeftCount + topRightCount + 1 >= 4);
  }

  getPieceColor(pieceValue) {
    return pieceValue == 1 ? player1color : pieceValue == 2 ? player2color : Colors.white;
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        player1score.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: player1color,
                              width: 4.0
                            )
                          )
                        ),
                        child: Text(
                          'Player 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: currentPlayer == 1 ? FontWeight.bold : null
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        player2score.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: player2color,
                              width: 4.0
                            )
                          )
                        ),
                        child: Text(
                          'Player 2',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: currentPlayer == 2 ? FontWeight.bold : null
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
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
                      color: getPieceColor(gameGrid[index]),
                      border: Border.all(
                        color: Colors.black54
                      ),
                      borderRadius: BorderRadius.circular(40)
                    ),
                  ),
                );
              })
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: (){ initGame(); },
                  child: const Text('RESET CURRENT GAME')
                ),
                ElevatedButton(
                  onPressed: (){ resetGame(); },
                  child: const Text('RESET SCORES')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
