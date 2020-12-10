import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String result = 'Translated text...';
  LanguageIdentifier languageIdentifier;
  ModelManager modelManager;
  LanguageTranslator languageTranslator;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelManager = FirebaseLanguage.instance.modelManager();
    modelManager.downloadModel(SupportedLanguages.Urdu);
    languageIdentifier = FirebaseLanguage.instance.languageIdentifier();
  }

  translateText(String text) async {
    languageTranslator = FirebaseLanguage.instance.languageTranslator(
        SupportedLanguages.English, SupportedLanguages.Urdu);
    String res = await languageTranslator.processText(text);
    setState(() {
      result =res;
    });

    // List<String> a = await modelManager.viewModels();
    // for (String s in a) {
    //   print(a);
    // }

    final List<LanguageLabel> labels =
    await languageIdentifier.processText(result);
    for (LanguageLabel label in labels) {
      final String text = label.languageCode;
      final double confidence = label.confidence;
      setState(() {
        result +=" "+ text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Container(
            color: Colors.black12,
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: 50,
                  child: Card(
                    child: Row(
                      children: [
                        Text('English'),
                        Container(
                          height: 48,
                          width: 1,
                          color: Colors.black,
                        ),
                        Text('Urdu')
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(top: 20, left: 2, right: 2),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Type text here...',
                          filled: true,
                      border: InputBorder.none
                        ),
                        style: TextStyle(color: Colors.black),
                        maxLines: 100,
                      ),
                    ),
                  ),
                  width: double.infinity,
                  height: 250,
                ),


                Container(
                  margin: EdgeInsets.only(top: 15, left: 13, right: 13),
                  width: double.infinity,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.green,
                    child: Text('Translate'),
                    onPressed: () {
                      translateText(textEditingController.text);
                    },
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Card(
                    color: Colors.white,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          result,
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  width: double.infinity,
                  height: 250,
                ),


              ],
            ),
          ))),
    );
  }
}
