import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lessonName;
  int lessonCredit = 1;
  double lessonLetterGrade = 4;
  List<Ders> allLessons;
  var formKey = GlobalKey<FormState>();
  double average = 0;
  static int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLessons = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return uygulamaGovdesi();
        } else {
          return uygulamaGovdesiLandscape();
        }
      }),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //color: Colors.pink.shade100,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adı",
                      hintText: "Ders adını giriniz.",
                      hintStyle: TextStyle(fontSize: 18),
                      labelStyle: TextStyle(fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.purple.shade200, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.purple.shade200, width: 2),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else {
                        return "Ders adı boş olamaz";
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      lessonName = kaydedilecekDeger;
                      setState(() {
                        allLessons.add(Ders(lessonName, lessonLetterGrade, lessonCredit,
                            rastgeleRenkOlustur()));
                        average = 0;
                        ortalamaHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: dersKredileriItems(),
                            value: lessonCredit,
                            onChanged: (secilenKrediDegeri) {
                              setState(() {
                                lessonCredit = secilenKrediDegeri;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.purple.shade200, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: dersHarfDegerleriItems(),
                            value: lessonLetterGrade,
                            onChanged: (secilenHarf) {
                              setState(() {
                                lessonLetterGrade = secilenHarf;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.purple.shade200, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              border: BorderDirectional(
                top: BorderSide(color: Colors.blue, width: 2),
                bottom: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Ortalama ",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                    TextSpan(
                        text: allLessons.length == 0
                            ? "için lütfen ders ekleyiniz"
                            : "${average.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: allLessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  //color: Colors.pink.shade100,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ders Adı",
                            hintText: "Ders adını giriniz.",
                            hintStyle: TextStyle(fontSize: 18),
                            labelStyle: TextStyle(fontSize: 18),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.purple.shade200, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.purple.shade200, width: 2),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else {
                              return "Ders adı boş olamaz";
                            }
                          },
                          onSaved: (kaydedilecekDeger) {
                            lessonName = kaydedilecekDeger;
                            setState(() {
                              allLessons.add(Ders(lessonName, lessonLetterGrade,
                                  lessonCredit, rastgeleRenkOlustur()));
                              average = 0;
                              ortalamaHesapla();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: dersKredileriItems(),
                                  value: lessonCredit,
                                  onChanged: (secilenKrediDegeri) {
                                    setState(() {
                                      lessonCredit = secilenKrediDegeri;
                                    });
                                  },
                                ),
                              ),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple.shade200, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  items: dersHarfDegerleriItems(),
                                  value: lessonLetterGrade,
                                  onChanged: (secilenHarf) {
                                    setState(() {
                                      lessonLetterGrade = secilenHarf;
                                    });
                                  },
                                ),
                              ),
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple.shade200, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      border: BorderDirectional(
                        top: BorderSide(color: Colors.blue, width: 2),
                        bottom: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Ortalama ",
                                style: TextStyle(fontSize: 20, color: Colors.black)),
                            TextSpan(
                                text: allLessons.length == 0
                                    ? "için lütfen ders ekleyiniz"
                                    : "${average.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 20, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: allLessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Kredi",
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(DropdownMenuItem(
      child: Text(
        " AA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 4,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " BA ",
        style: TextStyle(fontSize: 20),
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " BB ",
        style: TextStyle(fontSize: 20),
      ),
      value: 3,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " CB ",
        style: TextStyle(fontSize: 20),
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " CC ",
        style: TextStyle(fontSize: 20),
      ),
      value: 2,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " DC ",
        style: TextStyle(fontSize: 20),
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " DD ",
        style: TextStyle(fontSize: 20),
      ),
      value: 1,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " FD ",
        style: TextStyle(fontSize: 20),
      ),
      value: 0.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        " FF ",
        style: TextStyle(fontSize: 20),
      ),
      value: 0,
    ));

    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    counter++;

    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLessons.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: allLessons[index].renk, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(
            Icons.school,
            size: 36,
            color: allLessons[index].renk,
          ),
          title: Text(allLessons[index].ad),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: allLessons[index].renk,
          ),
          subtitle: Text(allLessons[index].kredi.toString() +
              " kredi - Not değeri: " +
              allLessons[index].harf.toString()),
        ),
      ),
    );
  }

  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oankiders in allLessons) {
      var kredi = oankiders.kredi;
      var harf = oankiders.harf;
      toplamNot = toplamNot + (harf * kredi);
      toplamKredi += kredi;
    }

    average = toplamNot / toplamKredi;
  }

  Color rastgeleRenkOlustur() {
    return Color.fromARGB(
        150 + Random().nextInt(255),
        150 + Random().nextInt(255),
        150 + Random().nextInt(255),
        150 + Random().nextInt(255));
  }
}

class Ders {
  String ad;
  double harf;
  int kredi;
  Color renk;

  Ders(this.ad, this.harf, this.kredi, this.renk);
}
