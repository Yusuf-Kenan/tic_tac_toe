import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tictac/player_enum.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  static const Players playerX = Players.X;
  static const Players playerY = Players.Y;

  late Players currentPlayer;
  late bool gameOver;
  late List<Players> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = playerY;
    gameOver = false;
    occupied = [
      Players.undefined,
      Players.undefined,
      Players.undefined,
      Players.undefined,
      Players.undefined,
      Players.undefined,
      Players.undefined,
      Players.undefined,
      Players.undefined,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic Tac Toe"),
      ),
      body: Center(
        child: Column(children: [
          _header(),
          _gameContainer(),
          _resetButton(),
        ]),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        const Text(
          "Start to Play",
          style: TextStyle(
              fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w600),
        ),
        Text(
          "$currentPlayer turn",
          style: const TextStyle(
              fontSize: 20, color: Colors.amber, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.height * 0.5,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _box(index);
          }),
    );
  }

  Widget _box(int index) {
    return InkWell(
      onTap: () {
        if (!gameOver || occupied[index] == Players.undefined) {
          setState(() {
            occupied[index] = currentPlayer;
            changeTurn();
            checkWinner();
          });
        }
      },
      child: Container(
        color: occupied[index] == Players.undefined
            ? Colors.black38
            : occupied[index] == playerX
                ? Colors.teal
                : Colors.amber,
        margin: const EdgeInsets.all(8),
        child: Center(
            child: Text(
          occupied[index] == Players.X
              ? "X"
              : occupied[index] == Players.Y
                  ? "O"
                  : "",
          style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  void changeTurn() {
    print(currentPlayer);
    print(playerX);
    print(playerY);
    if (currentPlayer == Players.X) {
      currentPlayer = Players.Y;
    } else {
      currentPlayer = Players.X;
    }
  }

  void checkWinner() {
    List<List<int>> winnerList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 4, 8],
      [2, 4, 6],
      [0, 3, 6],
      [2, 5, 8],
      [1, 4, 7],
    ];

    for (var win in winnerList) {
      Players winner0 = occupied[win[0]];
      Players winner1 = occupied[win[1]];
      Players winner2 = occupied[win[2]];

      if (winner0 != Players.undefined) {
        if (winner0 == winner1 && winner0 == winner2) {
          gameOverMassage("Player $winner0 won the game");
          gameOver = true;
          return;
        }
      }
    }
  }

  _resetButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text("Reset"));
  }

  gameOverMassage(String massage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.lightBlueAccent,
        content: Text(
          "Game Over\n $massage",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
          ),
        )));
  }
}
