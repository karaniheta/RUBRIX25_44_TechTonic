import 'package:anvaya/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Chatbotpage extends StatefulWidget {
  const Chatbotpage({super.key});

  @override
  State<Chatbotpage> createState() => _ChatbotpageState();
}

class _ChatbotpageState extends State<Chatbotpage> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _extraController = TextEditingController();
  String _response = '';
  List<String> _foodItems = [];
  List<String> _extraItems = [];
  String _selectedDietaryOption = 'None';
  String _selectedCuisine = 'None';

  final List<String> _dietaryOptions = [
    'None',
    'Vegan',
    'Vegetarian',
    'Non-Vegetarian',
    'Gluten-Free',
    'Keto',
  ];

  final List<String> _cuisines = [
    'None',
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'Mediterranean',
    'American',
  ];

  void _sendRequest() async {
    setState(() {
      _response = "Working on it...may take a few seconds";
    });

    String prompt = '''
      Food items: ${_foodItems.join(', ')},
      Extra items: ${_extraItems.join(', ')},
      Dietary requirements: $_selectedDietaryOption,
      Cuisine: $_selectedCuisine,
      Create a comprehensive meal plan based on these inputs so that there is minimal food wastage, keeping in mind things that can be made and stored somewhere.
    ''';

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyB9HDVp8c-wOlcmZUfwfDhtcRRNnM6y5kM',
    );

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      String formattedResponse =
          response.text?.replaceAll('*', '').trim() ?? 'No response';

      setState(() {
        _response = formattedResponse;
        _foodItems.clear();
        _extraItems.clear();
        _selectedDietaryOption = 'None';
        _selectedCuisine = 'None';
      });
    } catch (e) {
      setState(() {
        _response = 'Error generating recipe: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Display the customization container
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 204, 242, 244),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.titletext)
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Customize Your Recipe',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'interB',
                            color: AppColors.titletext),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.titletext)),
                        onPressed: _sendRequest,
                        child: const Text('Generate Recipe'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _foodController,
                          decoration: InputDecoration(
                            hintText: 'Enter food item',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          String input = _foodController.text.trim();
                          if (input.isNotEmpty) {
                            setState(() {
                              _foodItems.add(input);
                              _foodController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _extraController,
                          decoration: InputDecoration(
                            hintText: 'Enter extra item',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          String input = _extraController.text.trim();
                          if (input.isNotEmpty) {
                            setState(() {
                              _extraItems.add(input);
                              _extraController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Select Dietary Option:'),
                  DropdownButton<String>(
                    dropdownColor: AppColors.navbarcolorbg,
                    value: _selectedDietaryOption,
                    items: _dietaryOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDietaryOption = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Select Cuisine:'),
                  DropdownButton<String>(
                    dropdownColor: AppColors.navbarcolorbg,
                    value: _selectedCuisine,
                    items: _cuisines.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCuisine = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Selected Food Items:'),
                  Wrap(
                    children: _foodItems
                        .map((item) => Chip(
                              label: Text(item),
                              onDeleted: () {
                                setState(() {
                                  _foodItems.remove(item);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text('Selected Extra Items:'),
                  Wrap(
                    children: _extraItems
                        .map((item) => Chip(
                              label: Text(item),
                              onDeleted: () {
                                setState(() {
                                  _extraItems.remove(item);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display the response with the same scroll behavior
            Container(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 16,
                  color: AppColors.titletext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
