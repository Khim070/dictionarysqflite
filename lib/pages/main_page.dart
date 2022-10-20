import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:localsqflite/helpers/word_helper.dart';
import 'package:localsqflite/models/word_model.dart';
import 'package:localsqflite/pages/insert_page.dart';
import 'package:localsqflite/pages/update_page.dart';

class MainPageState extends StatefulWidget {
  const MainPageState({super.key});

  @override
  State<MainPageState> createState() => _MainPageStateState();
}

class _MainPageStateState extends State<MainPageState> {
  WordHelper _wordRepo = WordHelper();

  bool _isloading = true;

  late Future<List<WordModel>> _wordModelList;

  void initWork() async {
    _wordRepo.openDB().then((value) {
      setState(() {
        _isloading = false;
      });
      _wordModelList = _wordRepo.selectAll();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initWork();
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
      title: Text("Notes"),
      actions: [
        IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => InsertPage()));
            },
            icon: Icon(Icons.add))
      ],
    );
  }

  Widget get _buildBody {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey,
      child: _isloading ? CircularProgressIndicator() : _buildFuture(),
    );
  }

  Widget _buildFuture() {
    return FutureBuilder<List<WordModel>>(
        future: _wordModelList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildListView(snapshot.data ?? []);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildListView(List<WordModel> items) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _wordModelList = _wordRepo.selectAll();
        });
      },
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: ((context, index) {
            return _buildItem(items[index]);
          })),
    );
  }

  Widget _buildItem(WordModel item) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => UpdatePages(
                      eng: item.english,
                      kh: item.khmer,
                    ))));
      },
      child: Card(
        child: ListTile(
          title: Text(
            "${item.english}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            onPressed: () async {
              await _wordRepo.delete(item.id);
              setState(() {
                _wordModelList = _wordRepo.selectAll();
              });
            },
            icon: Icon(Icons.delete_forever),
          ),
        ),
      ),
    );
  }
}
