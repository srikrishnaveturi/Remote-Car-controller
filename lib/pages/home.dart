import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'dart:convert';
import 'package:easy_udp_socket/easy_udp_socket.dart';
import 'package:control_pad/control_pad.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  String streamurl;
  VlcPlayerController vlcPlayerController;
  String power = 'on';
  String instructionButton = ' ';
  String instructionJoystick = ' ';
  int port = 9999;
  var socket;
  String ipOfReceiver = '192.168.0.103';

  @override
  void initState() {
    super.initState();
    //streamurl = 'http://192.168.0.103:8081/';
    vlcPlayerController = new VlcPlayerController();
    createSocket();

  }


  void createSocket() async {
    socket = await EasyUDPSocket.bindBroadcast(port);
  }

  void sendPacket(socket) async{

    try {
      if (socket != null) {
        socket.send(ascii.encode('$instructionButton $instructionJoystick'), ipOfReceiver, port);
      }
      else {
        await socket.close();
      }
    } on Exception catch (e) {
      // `close` method of EasyUDPSocket is awaitable.
      await socket.close();
      print('Client $port closed');

      socket = await EasyUDPSocket.bindBroadcast(port);
    }
  }

  JoystickDirectionCallback onDirectionChanged(double degrees, double distance){
    instructionJoystick = '${degrees.toStringAsFixed(2)} ${distance.toStringAsFixed(2)}';
    print('$instructionButton $instructionJoystick');
    sendPacket(socket);
  }

  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? ModalRoute.of(context).settings.arguments : data;
    print("in home");
    print('got ${data['ip']}');
    streamurl = 'http://' + data['ip'] + ':8081/';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Rpi Control'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                    height: 320,
                    width: 640,
                    child: new VlcPlayer(
                      aspectRatio: 0.5,
                      url: streamurl,
                      options: [],
                      controller: vlcPlayerController,
                      placeholder: Center(child: CircularProgressIndicator()),
                    )
                ),
              ),
              SizedBox(height: 20.0,),

              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,10.0),
                      child: SizedBox(
                        height: 150.0,
                        child: JoystickView(
                          size: 150.0,
                          backgroundColor: Colors.blue[900],
                          innerCircleColor: Colors.black,
                          iconsColor: Colors.black,
                          onDirectionChanged: onDirectionChanged,),
                      ),
                    ),
                    //SizedBox(width: 10.0,),
                    RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          instructionButton = power;
                          power = power == 'on' ? 'off' : 'on';
                          print('$instructionButton $instructionJoystick');
                        });
                        sendPacket(socket);
                      },
                      elevation: 2.0,
                      fillColor: Colors.blue[900],
                      child: Icon(
                        Icons.lightbulb,
                        size: 35.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}


