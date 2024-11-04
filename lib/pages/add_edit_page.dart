import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEditPage extends StatefulWidget {
  final Map<String, dynamic>? item;

  AddEditPage({this.item});

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      titleController.text = widget.item!['title'];
      bodyController.text = widget.item!['body'];
    }
  }

  void saveItem() async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      body: jsonEncode({
        'title': titleController.text,
        'body': bodyController.text,
        'userId': 1,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      final newItem = json.decode(response.body);
      Navigator.pop(context, newItem); // Kembali ke halaman sebelumnya dengan data baru
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item == null ? 'Tambah Item' : 'Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveItem,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
