import 'package:flutter/material.dart';
import 'package:localsqflite/helpers/word_helper.dart';
import 'package:localsqflite/main.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:localsqflite/models/word_model.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  TextEditingController _englishCtrl = TextEditingController();
  TextEditingController _khmerCtrl = TextEditingController();

  WordHelper _wordRepo = WordHelper();

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wordRepo.openDB().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildbody,
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      title: Text("Insert Word"),
      actions: [
        TextButton(
            onPressed: () {
              WordModel wordModel = WordModel(
                id: DateTime.now().microsecond,
                english: _englishCtrl.text.trim(),
                khmer: _khmerCtrl.text.trim(),
              );

              _wordRepo.insert(wordModel).then((value) {
                print("${value.id} inserted");
              });
            },
            child: Text("Done"))
      ],
    );
  }

  Widget get _buildbody {
    return Container(
      //color: Colors.grey,
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: _isLoading ? CircularProgressIndicator() : _buildPanel(),
    );
  }

  Widget _buildPanel() {
    return Column(
      children: [
        TextField(
          controller: _englishCtrl,
          decoration: InputDecoration(
            hintText: "Enter title",
            border: InputBorder.none,
          ),
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextField(
            controller: _khmerCtrl,
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
        ElevatedButton.icon(
            onPressed: () {}, icon: Icon(Icons.add), label: Text("Insert"))
      ],
    );
  }
}
