import 'package:flutter/material.dart';

class ItemDetailsPage extends StatefulWidget {
  final Map item;

  const ItemDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late double rating;

  @override
  void initState() {
    super.initState();
    // Initialize the rating with the value from the item or default to 10
    rating = widget.item["rating"]?.toDouble() ?? 10.0;
  }

  @override
  Widget build(BuildContext context) {
    // Get values from the item map, with default values if null
    String name = widget.item["name"] ?? "Unknown Name";
    String imageUrl = widget.item["imatge"] ?? "https://via.placeholder.com/150"; // Default image if null

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Circular Image (Card image)
            ClipRRect(
              borderRadius: BorderRadius.circular(75), // Make it circular
              child: Image.network(
                imageUrl,
                width: 150, // Size of the image
                height: 150,
                fit: BoxFit.cover, // Ensure the image scales correctly within the circle
              ),
            ),
            const SizedBox(height: 20),

            // Name of the item (Card name)
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Rating (slider)
            Text(
              "Rating: ${rating.toStringAsFixed(1)}/10",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Slider(
              value: rating,
              min: 0,
              max: 10,
              divisions: 10,
              label: rating.toStringAsFixed(1),
              onChanged: (newRating) {
                setState(() {
                  rating = newRating; // Update the rating value when slider changes
                });
              },
            ),
            const SizedBox(height: 20),

            const Spacer(), // Push buttons to the bottom
            // Buttons: Save and Back
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Button to save changes and go back
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Return the updated item to the previous screen
                      Navigator.pop(context, {
                        ...widget.item,
                        "rating": rating, // Include updated rating
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Guardar",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}
