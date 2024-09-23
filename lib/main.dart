import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Digital Pet'),
    );
  }
}

class Pet {
  int happiness;
  int hunger;
  int energy;

  Pet({this.happiness = 100, this.hunger = 100, this.energy = 100});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Pet pet;

  @override
  void initState() {
    super.initState();
    pet = Pet();
    _startTimer();
  }

  void _startTimer() {
    // Update pet status every minute
    Future.delayed(Duration(minutes: 1), () {
      setState(() {
        pet.happiness -= 5;
        pet.hunger -= 10;
        pet.energy -= 5;
      });
      _startTimer(); // Restart the timer
    });
  }

  void _feedPet() {
    setState(() {
      pet.hunger = (pet.hunger + 20).clamp(0, 100);
    });
  }

  void _playWithPet() {
    setState(() {
      pet.happiness = (pet.happiness + 15).clamp(0, 100);
      pet.energy = (pet.energy - 10).clamp(0, 100);
    });
  }

  void _groomPet() {
    setState(() {
      pet.happiness = (pet.happiness + 10).clamp(0, 100);
      pet.energy = (pet.energy - 5).clamp(0, 100);
    });
  }

  void _trainPet() {
    setState(() {
      pet.happiness = (pet.happiness + 5).clamp(0, 100);
      pet.energy = (pet.energy - 15).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Happiness: ${pet.happiness}'),
            Text('Hunger: ${pet.hunger}'),
            Text('Energy: ${pet.energy}'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _feedPet, child: const Text('Feed')),
            ElevatedButton(onPressed: _playWithPet, child: const Text('Play')),
            ElevatedButton(onPressed: _groomPet, child: const Text('Groom')),
            ElevatedButton(onPressed: _trainPet, child: const Text('Train')),
          ],
        ),
      ),
    );
  }
}
