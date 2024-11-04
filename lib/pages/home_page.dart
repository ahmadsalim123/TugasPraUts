import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_edit_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body).take(0).toList();
      });
    }
  }

  void deleteItem(int id) async {
    await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));
    setState(() {
      items.removeWhere((item) => item['id'] == id);
    });
  }

  void addItem(Map<String, dynamic> newItem) {
    setState(() {
      items.add(newItem); // Tambah data baru secara lokal
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD App')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['title']),
            subtitle: Text(items[index]['body']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditPage(item: items[index]),
                      ),
                    ).then((value) {
                      if (value != null) {
                        fetchData();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteItem(items[index]['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditPage()),
          );

          if (newItem != null) {
            addItem(newItem); // Panggil fungsi addItem untuk menambah data ke list lokal
          }
        },
      ),
    );
  }
}
