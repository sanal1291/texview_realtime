import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class TexString {
  final String string;
  final String hintText;
  final String keysString;
  final SingleActivator activator;

  TexString(
      {required this.string,
      required this.hintText,
      required this.keysString,
      required this.activator});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String texString = "";
  FocusNode focusNode = FocusNode();

  TextEditingValue insertTextAndMoveCursorToCenter(
      int offset, String insertText) {
    String temp;
    temp = _controller.text.substring(0, offset) +
        insertText +
        _controller.text.substring(offset, _controller.text.length);
    return TextEditingValue(
        text: temp,
        selection:
            TextSelection.collapsed(offset: offset + insertText.length ~/ 2));
  }

  List<TexString> texStrings = [
    TexString(
        string: r" \(   \) ",
        hintText: r" inline",
        keysString: "ctrl + alt + i",
        activator: const SingleActivator(LogicalKeyboardKey.keyI,
            control: true, alt: true)),
    TexString(
        string: r" $$   $$ ",
        hintText: r" newline",
        keysString: "ctrl + alt + n",
        activator: const SingleActivator(LogicalKeyboardKey.keyN,
            control: true, alt: true)),
    TexString(
        string: r" \[   \] ",
        hintText: r" newline",
        keysString: "ctrl + alt + m",
        activator: const SingleActivator(LogicalKeyboardKey.keyM,
            control: true, alt: true)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("TeX view"),
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: TeXView(child: TeXViewDocument(_controller.text))),
              const Text("TeX input"),
              CallbackShortcuts(
                bindings: kIsWeb
                    ? {
                        for (var v in texStrings)
                          v.activator: (() {
                            _controller.value = insertTextAndMoveCursorToCenter(
                              _controller.selection.baseOffset,
                              v.string,
                            );
                          })
                      }
                    : {},
                child: TextFormField(
                  autofocus: true,
                  minLines: 5,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  decoration: InputDecoration(
                      contentPadding: kIsWeb
                          ? const EdgeInsets.all(20)
                          : const EdgeInsets.only(
                              left: 20, bottom: 20, right: 20),
                      suffix: !kIsWeb
                          ? Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: texStrings
                                  .map((e) => TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.teal[200]),
                                      onPressed: () {
                                        _controller.value =
                                            insertTextAndMoveCursorToCenter(
                                          _controller.selection.baseOffset,
                                          e.string,
                                        );
                                      },
                                      child: Text(e.hintText)))
                                  .toList(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text("Key combinations"),
                                ...texStrings
                                    .map((e) =>
                                        Text("${e.keysString} : ${e.hintText}"))
                                    .toList()
                              ],
                            ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onChanged: (value) {
                    setState(() {
                      texString = _controller.text;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
