String databaseName = "db_dictionary";
int databaseVersion = 1;
String tableName = "tbl_word";
String columnId = "id";
String columnEnglish = "english";
String columnKhmer = "khmer";

class WordModel {
  int id;
  String english;
  String khmer;

  WordModel({
    this.id = 0,
    this.english = "no english",
    this.khmer = "no khmer",
  });

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map[columnId],
      english: map[columnEnglish],
      khmer: map[columnKhmer],
    );
  }

  Map<String, dynamic> get toMap => {
        columnId: id,
        columnEnglish: english,
        columnKhmer: khmer,
      };
}
