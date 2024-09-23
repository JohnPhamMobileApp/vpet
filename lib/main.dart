import 'package:flutter/material.dart';
import 'dart:async'; // Import the async package

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Timer? _timer; // Timer instance

  @override
  void initState() {
    super.initState();
    _startHungerTimer(); // Start the timer when the app initializes
  }

  // Function to start the hunger timer
  void _startHungerTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _increaseHunger();
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

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  // Function to determine the color based on happiness level
  Color _getHappinessColor() {
    if (happinessLevel > 70) {
      return Colors.green; // Happy
    } else if (happinessLevel >= 30) {
      return Colors.yellow; // Neutral
    } else {
      return Colors.red; // Sad
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
  }

  // Text Controller
  final _controller = TextEditingController();

  // Update Pet Name
  void _updatePetName(){
    setState(() {
      petName = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
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
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(
                fontSize: 20.0,
                color: _getHappinessColor(), // Set color dynamically
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              _getMoodText(), // Display mood text with emoji
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
