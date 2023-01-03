import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

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

  TextEditingValue insertAndMoveCursor(int offset, String insertText) {
    String temp;
    temp = _controller.text.substring(0, offset) +
        insertText +
        _controller.text.substring(offset, _controller.text.length);
    return TextEditingValue(
        text: temp,
        selection:
            TextSelection.collapsed(offset: offset + insertText.length ~/ 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TeXView(child: TeXViewDocument(_controller.text)),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text("TeX input"),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: kIsWeb
                                      ? const EdgeInsets.only(
                                          top: 20,
                                          left: 20,
                                          bottom: 20,
                                          right: 20)
                                      : const EdgeInsets.only(
                                          left: 20, bottom: 20, right: 20),
                                  suffix: Column(
                                    children: [
                                      Container(
                                        padding: kIsWeb
                                            ? const EdgeInsets.only(bottom: 8.0)
                                            : null,
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    Colors.teal[200]),
                                            onPressed: () {
                                              _controller.value =
                                                  insertAndMoveCursor(
                                                _controller
                                                    .selection.baseOffset,
                                                r" \(   \) ",
                                              );
                                            },
                                            child: const Text(
                                                r"Insert inline Tex : \(   \) ")),
                                      ),
                                      Container(
                                          padding: kIsWeb
                                              ? const EdgeInsets.only(
                                                  bottom: 8.0)
                                              : null,
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.teal[200]),
                                              onPressed: () {
                                                _controller.value =
                                                    insertAndMoveCursor(
                                                  _controller
                                                      .selection.baseOffset,
                                                  r" $$   $$ ",
                                                );
                                              },
                                              child: const Text(
                                                  r"Insert inline Tex : $$   $$ "))),
                                      Container(
                                          padding: kIsWeb
                                              ? const EdgeInsets.only(
                                                  bottom: 8.0)
                                              : null,
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.teal[200]),
                                              onPressed: () {
                                                _controller.value =
                                                    insertAndMoveCursor(
                                                  _controller
                                                      .selection.baseOffset,
                                                  r" \[   \] ",
                                                );
                                              },
                                              child: const Text(
                                                  r"Insert new line Tex : \[   \] "))),
                                    ],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              keyboardType: TextInputType.multiline,
                              minLines: 6,
                              maxLines: 10,
                              controller: _controller,
                              onChanged: (value) {
                                setState(() {
                                  texString = _controller.text;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
