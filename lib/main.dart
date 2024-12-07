import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Afegir_jugador.dart';
import 'Detall_Cards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NBA JSON',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _items = [];
  bool _isLoading = false;

  Future<void> readJson() async {
    setState(() {
      _isLoading = true;
    });

    final String response = await rootBundle.loadString('assets/nba.json');
    final data = await json.decode(response);

    setState(() {
      _items = data["items"];
      _isLoading = false;
    });
  }

 Future<void> _addNewItem() async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddItemDialog(
        onAdd: (String name, String imageUrl, double rating) { // Afegeix 'rating'
          setState(() {
            _items.add({
              "id": _items.length + 1,
              "name": name,
              "imatge": imageUrl,
              "rating": rating, // Guarda també el valor del rating
            });
          });
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 8,
        title: const Text(
          'All-Star Salesians Sarria 2024-2025',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: readJson,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.deepPurple,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Obra el planter',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  )
                : _items.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
  return Card(
    key: ValueKey(_items[index]["id"]),
    margin: const EdgeInsets.symmetric(vertical: 10),
    elevation: 5,
    shadowColor: Colors.deepPurpleAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _items[index]["imatge"],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        _items[index]["name"],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
      // Substituïm la "ID" per 10 estrelles i puntuació
      subtitle: Row(
        children: List.generate(
          (_items[index]["rating"] ?? 10).toInt(), // Convertim a enter
          (i) => const Icon(Icons.star, size: 20, color: Colors.amber),
        ),
      ),
      onTap: () async {
        // Passar l'ítem a ItemDetailsPage i esperar un resultat
        final updatedItem = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsPage(item: _items[index]),
          ),
        );

        if (updatedItem != null) {
          // Actualitzar l'estat amb la nova puntuació
          setState(() {
            _items[index] = updatedItem;
          });
        }
      },
    ),
  );
}

                        ),
                      )
                    : const Center(
                        child: Text(
                          'No s’ha trobat cap dada. Obra el planter!!',
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add), // Ícono del botón
                        label: Text('Afegeix jugador'), // Texto del botón
                        onPressed: _addNewItem, // Acción al presionar el botón
                      )
          ],
        ),
      ),
    );
  }
} 