import 'package:flutter/material.dart';
import 'search.dart';
import 'create.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Application Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Text('Search Application'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormPage(id:'',serialNumber: '', brand: '', model: '', status: '', dataBought: '', isUpdate: false)),
                );
              },
              child: Text('Application'),
            ),
          ],
        ),
      ),
    );
  }
}

