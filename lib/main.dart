import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher-js/core/channels/channel.dart';
import 'package:pusher_channels_flutter/pusher-js/core/pusher.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BallScreen(),
    );
  }
}

class BallScreen extends StatefulWidget {
  @override
  _BallScreenState createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen> {
  double _ballLeft = 0.0;
  double _ballTop = 0.0;
  late double _screenWidth;
  late double _screenHeight;

  late Pusher pusher;
  late Channel channel;

  @override
  void initState() {
    super.initState();

    // setup Pusher
    Future<void> initState() async {
      PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
      try {
        await pusher.init(
          apiKey: "259797bf5d7537a90b43",
          cluster: "ap1",
        );
        await pusher.subscribe(channelName: 'presence-chatbox');
        await pusher.connect();
      } catch (e) {
        print("ERROR: $e");
      }
    }

    channel = pusher.subscribe('movement_channel');
    channel.bind('move', (data) {
      var eventData = data['data'];
      switch (eventData['direction']) {
        case 'UP':
          _ballTop -= 50.0;
          break;
        case 'DOWN':
          _ballTop += 50.0;
          break;
        case 'LEFT':
          _ballLeft -= 50.0;
          break;
        case 'RIGHT':
          _ballLeft += 50.0;
          break;
        default:
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    if (_ballLeft < 0) {
      _ballLeft = 0;
    } else if (_ballLeft + 50.0 > _screenWidth) {
      _ballLeft = _screenWidth - 50.0;
    }

    if (_ballTop < 0) {
      _ballTop = 0;
    } else if (_ballTop + 50.0 > _screenHeight) {
      _ballTop = _screenHeight - 50.0;
    }

    return Scaffold(
      body: Container(
        width: _screenWidth,
        height: _screenHeight,
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              left: _ballLeft,
              top: _ballTop,
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
