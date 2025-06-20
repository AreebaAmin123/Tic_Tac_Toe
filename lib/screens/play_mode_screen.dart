import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';

class PlayModeScreen extends StatefulWidget {
  const PlayModeScreen({super.key});

  @override
  State<PlayModeScreen> createState() => _PlayModeScreenState();
}

class _PlayModeScreenState extends State<PlayModeScreen> {
  String? playerSide;

  void _navigateToGameScreen(bool isAI) async {
    final selectedSide = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Your Side'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'X'),
              child: Text('X'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'O'),
              child: Text('O'),
            ),
          ],
        ),
      ),
    );

    if (selectedSide != null && (selectedSide == 'X' || selectedSide == 'O')) {
      setState(() {
        playerSide = selectedSide;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            playerSide: selectedSide,
            isAI: isAI,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/cross.png', width: 100),
                   // SizedBox(width: 20),
                    Image.asset('assets/circle.png', width: 150),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Choose Your Play Mode',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              if (playerSide != null) ...[
                SizedBox(height: 10),
                Text(
                  'You chose: $playerSide',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
              SizedBox(height: 50),
              _buildModeButton('Play With AI', true, Colors.blue, Colors.white),
              SizedBox(height: 30),
              _buildModeButton('Play With Friend', false, Colors.white, Colors.black),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildModeButton(String label, bool isAI, Color bgColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            offset: Offset(0, -1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            offset: Offset(0, 4),
            blurRadius: 9,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shadowColor: Colors.white10,
          minimumSize: Size(300, 50),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
        onPressed: () => _navigateToGameScreen(isAI),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
