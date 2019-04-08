import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoicePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class VoicePage extends StatefulWidget {
  final String title;

  VoicePage({Key key, this.title}) : super(key: key);

  @override
  VoicePageState createState() {
    return new VoicePageState();
  }
}

class VoicePageState extends State<VoicePage> {
  SpeechRecognition _speechrec;
  bool _isAvailable = false;
  bool _isListenting = false;

  String resultTest = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                child: Icon(Icons.cancel),
                mini: true,
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  if (_isListenting) {
                    _speechrec.cancel().then(
                          (result) => setState(() {
                                _isListenting = result;
                                resultTest = "";
                              }),
                        );
                  }
                },
              ),
              FloatingActionButton(
                child: Icon(Icons.mic),
                onPressed: () {
                  if (_isAvailable && _isListenting)
                    _speechrec
                        .listen(locale: "en_US")
                        .then((result) => print('$result'));
                },
              ),
              FloatingActionButton(
                child: Icon(Icons.stop),
                mini: true,
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  if (_isListenting) {
                    _speechrec.stop().then(
                        (result) => setState(() => _isListenting = result));
                  }
                },
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * .6,
            decoration: BoxDecoration(
              color: Colors.cyanAccent[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Text(resultTest),
          ),
        ],
      ),
    ));
  }

  void initSpeechRecognizer() {
    _speechrec = SpeechRecognition();
    _speechrec.setAvailabilityHandler((bool availabilityresult) =>
        setState(() => _isAvailable = availabilityresult));
    _speechrec.setRecognitionStartedHandler(
        () => setState(() => _isListenting = true));
    _speechrec.setRecognitionResultHandler(
        (String speech) => setState(() => resultTest = speech));
    _speechrec.setRecognitionCompleteHandler(
        () => setState(() => _isListenting = false));

    _speechrec
        .activate()
        .then((result) => setState(() => _isAvailable = result));
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.display1,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
