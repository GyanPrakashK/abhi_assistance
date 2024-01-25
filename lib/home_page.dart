import 'package:abhi_assistance/featuresBox.dart';
import 'package:abhi_assistance/pallets.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Abhishek"),
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Center(
                child: Container(
                  height: 114,
                  width: 114,
                  margin: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 118,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/virtualAssistant.png'))),
              )
            ]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Text(
                'Good morning , What task can I do for you?',
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 25,
                    color: Pallete.mainFontColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22, 8, 2, 0),
              child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Here are a few features',
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cera Pro',
                      fontSize: 25,
                    ),
                  )),
            ),
            Column(
              children: [
                FeaturesBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headtext: 'ChatGPT',
                    descriptiontext:
                        'A smarter way to  stay organized and informed with ChatGPT'),
                FeaturesBox(
                    color: Pallete.secondSuggestionBoxColor,
                    headtext: 'Dell-E',
                    descriptiontext:
                        'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                FeaturesBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headtext: 'Smart Voice Assistant',
                    descriptiontext:
                        'Get the best of the both worlds with a voice assistant powerrd by Dall-E and ChatGPT')
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(Icons.mic),
      ),
    );
  }
}
