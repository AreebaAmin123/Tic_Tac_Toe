import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String playerSide;
  final bool isAI;

  const GameScreen({super.key, required this.playerSide, required this.isAI});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String winner = '';
  int playerScore = 0;
  int aiScore = 0;
  String playerOneName = 'Player';
  String playerTwoName = 'AI';

  @override
  void initState() {
    super.initState();

    if (widget.playerSide == 'O' && widget.isAI) {
      currentPlayer = 'X';
      aiMove();
    }

    if (!widget.isAI) {
      playerOneName = 'Player 1';
      playerTwoName = 'Player 2';
    }
  }

  @override
  Widget build(BuildContext context) {
    String opponentSide = widget.playerSide == 'X' ? 'O' : 'X';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (currentPlayer == widget.playerSide)
                          Icon(Icons.directions_run, color: Colors.green),
                        GestureDetector(
                          onTap: () => changePlayerName(1),
                          child: Row(
                            children: [
                              Text(
                                playerOneName,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Image.asset(
                                widget.playerSide == 'X' ? 'assets/cross.png' : 'assets/circle.png',
                                width: 20,
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 30,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '$playerScore - $aiScore',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        if (currentPlayer != widget.playerSide)
                          Icon(Icons.directions_run, color: Colors.green),
                        GestureDetector(
                          onTap: () => changePlayerName(2),
                          child: Row(
                            children: [
                              Text(
                                playerTwoName,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Image.asset(
                                opponentSide == 'X' ? 'assets/cross.png' : 'assets/circle.png',
                                width: 30,
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double gridSize = constraints.maxWidth;

                        return SizedBox(
                          width: gridSize,
                          height: gridSize,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => makeMove(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: index < 6
                                          ? BorderSide(width: 3, color: Colors.green)
                                          : BorderSide.none,
                                      right: index % 3 != 2
                                          ? BorderSide(width: 3, color: Colors.red)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Center(
                                    child: board[index] == 'X'
                                        ? Image.asset('assets/cross.png', width: gridSize / 4)
                                        : board[index] == 'O'
                                        ? Image.asset('assets/circle.png', width: gridSize / 3)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  winner,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shadowColor: Colors.grey,
                    minimumSize: Size(300, 50),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: resetBoard,
                  child: Text(
                    'Reset game',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner(currentPlayer)) {
          winner = currentPlayer == widget.playerSide
              ? '$playerOneName Wins!'
              : '$playerTwoName Wins!';
          if (currentPlayer == widget.playerSide) {
            playerScore++;
          } else {
            aiScore++;
          }
        } else if (isDraw()) {
          winner = 'Draw Match!';
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          if (widget.isAI && currentPlayer != widget.playerSide) {
            Future.delayed(Duration(milliseconds: 300), () => aiMove());
          }
        }
      });
    }
  }

  void aiMove() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = currentPlayer;
        if (checkWinner(currentPlayer)) {
          setState(() {
            winner = '$playerTwoName Wins!';
            aiScore++;
          });
          return;
        }
        board[i] = '';
      }
    }

    String opponent = widget.playerSide;

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = opponent;
        if (checkWinner(opponent)) {
          setState(() {
            board[i] = currentPlayer;
          });
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          return;
        }
        board[i] = '';
      }
    }

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        setState(() {
          board[i] = currentPlayer;
          if (checkWinner(currentPlayer)) {
            winner = '$playerTwoName Wins!';
            aiScore++;
          } else if (isDraw()) {
            winner = 'Draw Match!';
          } else {
            currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          }
        });
        break;
      }
    }
  }

  bool checkWinner(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  bool isDraw() => !board.contains('') && winner == '';

  void resetBoard() {
    setState(() {
      board = List.filled(9, '');
      winner = '';
      currentPlayer = 'X';
      if (widget.playerSide == 'O' && widget.isAI) {
        aiMove();
      }
    });
  }

  void changePlayerName(int playerNumber) async {
    TextEditingController controller = TextEditingController();

    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Player $playerNumber Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Player $playerNumber'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        if (playerNumber == 1) {
          playerOneName = newName;
        } else {
          playerTwoName = newName;
        }
      });
    }
  }
}
