import 'package:cloud_firestore/cloud_firestore.dart';

class userData {
  String username;
  List<String> noteBookList = [];
  var databaseReference = Firestore.instance;

  userData(this.username) {}

  String getUsername() {
    return this.username;
  }

  void setUsername(String u) {
    print("Setting username to $u");
    this.username = u;
  }

  void fetchUserData() {
    databaseReference
        .collection('users')
        .document('${this.getUsername()}')
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
      print("document:****");
      print("got some data!");
      print(ds['description']);
    });
  }

  void setData() async {
    await databaseReference
        .collection("users")
        .document('${this.getUsername()}')
        .setData({
      'title': 'This is from the class!',
      'description': 'Programming Guide for Dart'
    });
  }

  Future<List> getNoteBookList() async {
    List<String> lst;

    await databaseReference
        .collection('users')
        .document('${this.getUsername()}')
        .get()
        .then((DocumentSnapshot ds) {
      //print(ds['info']);
      lst = List.from(ds['notebooks']);
      print("from database:");
      lst.forEach((notebooks) => print(notebooks));
      print("from local:");
      print(this.noteBookList);
      this.noteBookList = lst;
    });
    //await Future<List>.delayed(const Duration(seconds: 2));
    return lst;
    //return ["Hello","List"];
  }

  void initiateNoteBook(String name) async {
    List notebooks = await getNoteBookList();

    for (final i in notebooks) {
      print('$i');
      if (i == name) {
        print("cannot duplicate notebooks");
        //alert_CannotDuplicatePages();
        return;
      }
    }

    notebooks.add(name);

    await databaseReference
        .collection("users")
        .document('${this.getUsername()}')
        .updateData({
      'notebooks': notebooks,
    });

    createNotebookArray(name);
  }

  void deleteNoteBook(String name) async {
    List notebooks = await getNoteBookList();

    notebooks.remove(name);
    //alert_CannotDuplicatePages();
    notebooks.forEach((notebooks) => print(notebooks));

    await databaseReference
        .collection("users")
        .document('${this.getUsername()}')
        .updateData({
      'notebooks': notebooks,
    });

    await databaseReference
        .collection("users")
        .document('${this.getUsername()}')
        .updateData({
      '$name': null,
    });
  }

  void createDocumentforUser() async {
    print("Creating a new document for ${this.getUsername()}");
    await databaseReference
        .collection("users")
        .document("${this.getUsername()}")
        .setData({
      'notebooks': [],
    });
  }

  Map<String, Map<String, Map<String, String>>> generateNotebookMap() {
    //create an empty notebook map
    var today = new DateTime.now();

    Map<String, Map<String, Map<String, String>>> map = {
      '${today.year}': {},
    };

    for (var i = 1; i <= 12; i++) {
      map['${today.year}']['$i'] = {};
      for (var d = 1; d <= 31; d++) {
        map['${today.year}']['$i']['$d'] = "";
      }
    }

    return map;
  }

  void createNotebookArray(String notebook) async {
    Map<String, Map<String, Map<String, String>>> map = generateNotebookMap();

    print("Creating a notebook array for exercise for ${this.getUsername()}");
    await databaseReference
        .collection("users")
        .document('${this.getUsername()}')
        .updateData({
      '$notebook': map,
    });
  }

  Future<Map> getNoteBookContent(String notebook) async {
    Map<String, dynamic> data;
    var today = new DateTime.now();

    print("getting notebook content");

    await databaseReference
        .collection('users')
        .document('${this.getUsername()}')
        .get()
        .then((DocumentSnapshot ds) {
      print(ds);
      Map<String, dynamic> map = ds.data;
      data = ds.data;
    });

    return data['$notebook'];
  }

  Future<Map> getNoteBookContentMonth(
      String notebook, int year, int month) async {
    Map<String, dynamic> data;
    var today = new DateTime.now();

    print("getting notebook content");

    await databaseReference
        .collection('users')
        .document('${this.getUsername()}')
        .get()
        .then((DocumentSnapshot ds) {
      print(ds);
      Map<String, dynamic> map = ds.data;
      data = ds.data;
    });

    return data['$notebook']['$year']['$month'];
  }

  void updateNotebookData(
      String notebook, int year, int month, int day, String value) async {
    Map currentNotebook = await getNoteBookContent(notebook);
    currentNotebook['$year']['$month']['$day'] = value;

    await databaseReference
        .collection("users")
        .document('${this.getUsername()}')
        .updateData({
      '$notebook': currentNotebook,
    });
  }
}
