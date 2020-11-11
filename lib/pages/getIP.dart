import 'package:flutter/material.dart';

class GetIP extends StatefulWidget {
  @override
  _GetIPState createState() => _GetIPState();
}

class _GetIPState extends State<GetIP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Rpi Control'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: SizedBox(
          width: 300.0,
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: 'Enter IP address',
              labelStyle: TextStyle(
                color: Colors.blue[900],
              ),
              border: new UnderlineInputBorder(
                borderSide: new BorderSide(
                  color: Colors.red
                  ),
                ),
              ),
            onSubmitted: (String str) {
              print("submitted");
              print('$str');
              Navigator.pushNamed(context, '/home', arguments: {
              'ip': str,
              });
              },
          ),
        ),
      ),
    );
  }
}
