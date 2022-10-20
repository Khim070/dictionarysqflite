import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:localsqflite/helpers/word_helper.dart';
import 'package:localsqflite/main.dart';
import 'package:localsqflite/models/word_model.dart';
import 'package:localsqflite/pages/main_page.dart';

class UpdatePages extends StatefulWidget {
  String eng;
  String kh;
  UpdatePages({required this.eng, required this.kh, super.key});

  @override
  State<UpdatePages> createState() => _UpdatePagesState();
}

class _UpdatePagesState extends State<UpdatePages> {
  TextEditingController _updateenglish = TextEditingController();
  TextEditingController _updatekhmer = TextEditingController();

  bool _isLoading = true;

  WordHelper _wordRepo = WordHelper();

  late Future<List<WordModel>> _wordModelList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wordRepo.openDB().then((value) {
      setState(() {
        _isLoading = false;
        _updateenglish.text = widget.eng;
        _updatekhmer.text = widget.kh;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      title: Text('Updates Pages'),
    );
  }

  Widget get _buildBody {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child:
          _isLoading ? CircularProgressIndicator() : _updatePanel(WordModel()),
    );
  }

  Widget _updatePanel(WordModel item) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          children: [
            TextFormField(
              controller: _updateenglish,
              decoration: InputDecoration(hintText: "${item.english}"),
            ),
            TextFormField(
              controller: _updatekhmer,
              decoration: InputDecoration(hintText: "${item.khmer}"),
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  // WordModel wordModel = WordModel(
                  //   id: DateTime.now().microsecond,
                  //   english: _updateenglish.text.trim(),
                  //   khmer: _updatekhmer.text.trim(),
                  // );

                  // _wordRepo.insert(wordModel).then((value) {
                  //   print("${value.id} inserted");
                  // });
                  // _wordRepo.delete(item.id);
                  // setState(() {
                  //   _wordModelList = _wordRepo.selectAll();
                  // });

                  await WordHelper()
                      .update(WordModel(
                        id: DateTime.now().microsecond,
                        english: _updateenglish.text,
                        khmer: _updatekhmer.text,
                      ))
                      .whenComplete(() => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                          (route) => false));
                  _wordRepo.update(item).then((value) {
                    print("${value} updated");
                  });
                  setState(() {
                    _wordModelList = _wordRepo.selectAll();
                  });
                },
                icon: Icon(Icons.update),
                label: Text("Update"))
          ],
        ),
      ),
    );
  }
}
