import 'package:abhi_assistance/featuresBox.dart';
import 'package:abhi_assistance/openapi_service.dart';
import 'package:abhi_assistance/pallets.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  final FlutterTts flutterTts = FlutterTts();
  final OpenAIServices openAIServices = OpenAIServices();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    inittextToSpeech();
  }

  Future<void> inittextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
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
    flutterTts.stop();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BounceInDown(
            delay: Duration(milliseconds: 300), child: Text("Abhishek")),
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ZoomIn(
              child: Stack(children: [
                Center(
                  child: Container(
                    height: 114,
                    width: 114,
                    margin: EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 118,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/virtualAssistant.png'))),
                )
              ]),
            ),
            FadeInRight(
              delay: const Duration(microseconds: 100),
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ).copyWith(top: 30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12))),
                  child: Text(
                    generatedContent == null
                        ? 'Good morning , What task can I do for you?'
                        : generatedContent!,
                    style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontSize: generatedContent == null ? 25 : 18,
                        color: Pallete.mainFontColor),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.network(generatedImageUrl!),
              ),
            SlideInLeft(
              delay: const Duration(microseconds: 100),
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 2, 0),
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        'Here are a few features',
                        style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cera Pro',
                          fontSize: 25,
                        ),
                      )),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInRight(
                    delay: Duration(microseconds: start),
                    child: const FeaturesBox(
                        color: Pallete.firstSuggestionBoxColor,
                        headtext: 'ChatGPT',
                        descriptiontext:
                            'A smarter way to  stay organized and informed with ChatGPT'),
                  ),
                  SlideInLeft(
                    delay: Duration(microseconds: start + delay),
                    child: const FeaturesBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headtext: 'Dell-E',
                        descriptiontext:
                            'Get inspired and stay creative with your personal assistant powered by Dall-E'),
                  ),
                  SlideInUp(
                    delay: Duration(microseconds: start + 2 * delay),
                    child: const FeaturesBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        headtext: 'Smart Voice Assistant',
                        descriptiontext:
                            'Get the best of the both worlds with a voice assistant powerrd by Dall-E and ChatGPT'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(microseconds: start + 2 * delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openAIServices.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemSpeak(speech);
              }
              print(speech);
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(
            speechToText.isListening ? Icons.stop : Icons.mic,
          ),
        ),
      ),
    );
  }
}
