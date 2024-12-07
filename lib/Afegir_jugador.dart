import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget {
  final Function(String name, String imageUrl, double rating) onAdd;

  const AddItemDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  double rating = 5.0; // Valor inicial del Slider

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Afegeix una nou jugador'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
              ),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: 'URL de la imatge',
              ),
            ),
            const SizedBox(height: 20),
            Text('Estrelles: ${rating.toInt()}'),
            Slider(
              value: rating,
              min: 0,
              max: 10,
              divisions: 10,
              label: rating.toInt().toString(),
              onChanged: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel·la'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              String imageUrl = imageController.text.trim();
              Uri? uri = Uri.tryParse(imageUrl);

              // Comprovar si la URL no és vàlida
              if (uri == null || !uri.hasAbsolutePath) {
                imageUrl =
                    "https://cdn.pixabay.com/photo/2014/03/25/15/19/cross-296507_960_720.png"; // Imatge predeterminada
              }

              widget.onAdd(
                nameController.text.trim(),
                imageUrl,
                rating,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Afegeix'),
        ),
      ],
    );
  }
}
