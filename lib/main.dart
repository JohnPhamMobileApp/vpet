import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _hungerTimer;
  Timer? _winTimer;
  bool gameOver = false;
  bool gameWon = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  // Function to start the hunger timer
  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _increaseHunger();
      _checkLossCondition();
    });
  }

  // Function to increase hunger
  void _increaseHunger() {
    setState(() {
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      if (hungerLevel >= 100) {
        happinessLevel = (happinessLevel - 20).clamp(0, 100);
      }
    });
  }

  // Function to check for win condition
  void _checkWinCondition() {
    if (happinessLevel > 80) {
      _winTimer ??= Timer(Duration(minutes: 1), () {
        setState(() {
          gameWon = true;
        });
      });
    } else {
      _winTimer?.cancel();
      _winTimer = null; // Reset win timer
    }
  }

  // Function to check for loss condition
  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      setState(() {
        gameOver = true;
      });
      _hungerTimer?.cancel(); // Stop hunger timer on game over
    }
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _winTimer?.cancel();
    super.dispose();
  }

  // Function to determine the color based on happiness level
  Color _getHappinessColor() {
    if (happinessLevel > 70) {
      return Colors.green; // Happy
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral
    } else {
      return Colors.blue; // Sad
    }
  }

  // Function to get mood text and emoji based on happiness level
  String _getMoodText() {
    if (happinessLevel > 70) {
      return '😊 Happy'; // Happy
    } else if (happinessLevel >= 30) {
      return '😐 Neutral'; // Neutral
    } else {
      return '😢 Unhappy'; // Sad
    }
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _checkWinCondition(); // Check win condition after playing
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
    _checkWinCondition(); // Check win condition after feeding
  }

  // Text Controller
  final _controller = TextEditingController();

  // Update Pet Name
  void _updatePetName() {
    setState(() {
      petName = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Display Game Over message if the game is lost
    if (gameOver) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game Over')),
        body: const Center(
          child: Text(
            'Game Over! Your pet is too hungry!',
            style: TextStyle(fontSize: 24.0, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Display Win message if the game is won
    if (gameWon) {
      return Scaffold(
        appBar: AppBar(title: const Text('You Win!')),
        body: const Center(
          child: Text(
            'You Win! Your pet is very happy!',
            style: TextStyle(fontSize: 24.0, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Main game interface
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pet Name',
              ),
            ),
            ElevatedButton(
              onPressed: _updatePetName,
              child: const Text("Change Pet Name"),
            ),
            Text(
              'Name: $petName',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(
                fontSize: 20.0,
                color: _getHappinessColor(), // Set color dynamically
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              _getMoodText(), // Display mood text with emoji
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: const Text('Play with Your Pet'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: const Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
