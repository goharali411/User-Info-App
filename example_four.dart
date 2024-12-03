import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleFour extends StatefulWidget {
  const ExampleFour({super.key});

  @override
  State<ExampleFour> createState() => _ExampleFourState();
}

class _ExampleFourState extends State<ExampleFour> {
  var data;
  Future<void> getUserApi() async {
    final response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          'User Info',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFEFF6EE), // Soft mint green background
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: getUserApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load data: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Text(
                                data[index]['name'][0],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              radius: 30,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableRow(
                                    title: 'Name',
                                    value: data[index]['name'].toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Username',
                                    value: data[index]['username'].toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Address',
                                    value: data[index]['address']['street']
                                        .toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Geo Location',
                                    value:
                                    'Lat: ${data[index]['address']['geo']['lat']}, Lng: ${data[index]['address']['geo']['lng']}',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
