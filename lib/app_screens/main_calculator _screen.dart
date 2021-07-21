import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import '/app_screens/admob_helper.dart';

import 'file_utils.dart';
import 'package:flutter/material.dart';
import '/app_screens/main_drawer.dart';

import 'settings.dart'; //settings page
import 'package:math_expressions/math_expressions.dart';
import 'main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global_variables.dart';
import 'package:share/share.dart';
import 'package:another_flushbar/flushbar.dart';

class MainCalculatorScreen extends StatefulWidget {
  String content;
  MainCalculatorScreen(this.content);

  @override
  State<StatefulWidget> createState() {
    return _MainCalculatorState(this.content);
  }
}

class _MainCalculatorState extends State<MainCalculatorScreen> {
  BannerAd bAd = new BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.largeBanner,
      listener: BannerAdListener(onAdLoaded: (Ad ad) {
        print("ad loaded");
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print("ad failed to load");
        ad.dispose();
      }, onAdOpened: (Ad ad) {
        print("ad failed to load");
      }),
      request: AdRequest());

  AdmobHelper admobHelper = AdmobHelper();

  String content;
  _MainCalculatorState(this.content);

  String prior = '';
  String totaloutput = '0';
  bool isVisible = true;
  TextEditingController _controller = TextEditingController();
  bool readOnly = true;
  String state = '';
  List<TextEditingController> controllers = [];
  List<String> sums = [""];
  List<String> totals = [""];

  int currentIndex = 0;
  String cText = "";
  List<FocusNode> fNodes = [];
  final Fileutils fileutils = new Fileutils();

  @override
  void initState() {
    getData();
    for (var i = 0; i < sums.length; i++) {
      controllers.add(TextEditingController());
    }
    for (var i = 0; i < sums.length; i++) {
      fNodes.add(FocusNode());
      super.initState();
    }
    admobHelper.createInterad();
  }

  loadListfromFile() {
    print("content $content");
    //clear sums screen
    buttonPressed("AC");
    //remove the square brackets and split the string to a list
    content = content.replaceAll("[", "").replaceAll("]", "");
    List<String> contentsOfFile = content.split(",");
    //give conrentoffile to sums

    for (var i = 0; i < contentsOfFile.length; i++) {
      fNodes.add(FocusNode());
      controllers.add(TextEditingController());

      buttonPressed("=");
    }

    sums = contentsOfFile;
    for (var i = 0; i < sums.length; i++) {
      setState(() {
        evaluateSumOnLoad(sums[i], i);
        print("this sum at index $i is $sums[i] and total is $totals");
      });
    }
    //

    // //fNodes[sums.length - 1].unfocus();
    // pressABC();
    press123();
    fNodes[sums.length - 1].requestFocus();

    print(sums);

    print("contentsOfFile is $contentsOfFile");
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    font_size = prefs.getDouble("fontSize")!;
    pad_size = prefs.getDouble("keyboardSize")!;
    decimalPlaces = prefs.getInt("decimal")!;
    var colorValue = prefs.getInt("ThemeColor")!;
    my_color = Color(colorValue);
    sharePrefsetState();
  }

  sharePrefsetState() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

//remove all text leaving only numbers and operators
  stripstringToEvaluate(stringtoeval) {
    print("string before stripping is  : $stringtoeval");
    // take the textfield textand remove all the text leaving only numbers and maths signs
    final RegExp exp = RegExp(r"[a-z,A-Z,&,#,$,\s:,;_]");
    stringtoeval = (stringtoeval.replaceAll((exp), ""));

    print("stripped string :    $stringtoeval");
    return stringtoeval;
  }

  saveSheetAsText() {
    print(sums);
    print(totals);

    String sheetAsText = "";
    for (int i = 0; i < sums.length; i++) {
      if (sums[i] != "") {
        sheetAsText = sheetAsText + sums[i] + "\t= " + totals[i] + " \n";
      }
    }

    print("sheet of sums $sheetAsText");
    return sheetAsText;
  }

  evaluateSum(String stringtoeval) {
    stringtoeval = stripstringToEvaluate(stringtoeval);
    if (stringtoeval != "") {
      print("toeval $stringtoeval");
      Parser p = Parser();
      Expression exp = p.parse(stringtoeval);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      print('Expression: ${eval.toString()}');

      totals[currentIndex] = eval.toStringAsFixed(decimalPlaces);

      return;
    }
  }

  evaluateSumOnLoad(String stringtoeval, int index) {
    stringtoeval = stripstringToEvaluate(stringtoeval);
    if (stringtoeval != "") {
      print("toeval $stringtoeval");
      Parser p = Parser();
      Expression exp = p.parse(stringtoeval);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      print('Expression: ${eval.toString()}');

      totals[index] = eval.toStringAsFixed(decimalPlaces);

      return;
    }
  }

  evaluateABC(String sum) {
    sums[currentIndex] = controllers[currentIndex].text;
    evaluateSum(sums[currentIndex]);
    fNodes[currentIndex].unfocus();
    isVisible = true;
    //smPadVisible = false;

    fNodes[currentIndex].requestFocus();
    isVisible = false;
    smPadVisible = true;
  }

  pressABC() {
    setState(() {
      isVisible = false;
      smPadVisible = true;
      readOnly = false;
      FocusScope.of(context).requestFocus(fNodes[currentIndex]);
    });
    print("abc pressed");
    print(fNodes[currentIndex]);
  }

  press123() {
    setState(() {
      isVisible = true;
      smPadVisible = false;
      readOnly = false;
      sums[currentIndex] = controllers[currentIndex].text;

      evaluateSum(sums[currentIndex]);
      FocusScope.of(context).unfocus();
    });
    print("Keyboard pressed");
  }

  buttonPressed(String buttonText) {
    print(" buttonText pressed=  $buttonText");

    switch (buttonText) {
      case "=":
        {
          print("button press was equal");
          setState(() {
            controllers.add(TextEditingController());
            print(sums);
            sums.add("");
            totals.add("");
            fNodes.add(FocusNode());
            currentIndex = sums.length - 1;
            totaloutput = totaloutput + sums[currentIndex];
          });
        }
        break;
      case "<<<":
        {
          setState(() {
            print("button press was backspace");
            //trim whitspaces
            sums[currentIndex] = sums[currentIndex].trim();
            //remove the last character
            sums[currentIndex] =
                sums[currentIndex].substring(0, sums[currentIndex].length - 1);
            //check if last character is a maths operator ,,,if so do not evaluate
            // String lc =sums[currentIndex].substring(sums[currentIndex]length - 1);
            // if (lc != "+" || lc != "-" || lc != "*" || lc != "/") {
            evaluateSum(sums[currentIndex]);
            //fNodes[currentIndex].requestFocus();
          });
        }
        break;
      case "AC":
        {
          admobHelper.createInterad();
          print("sums before clear");
          print(sums);
          setState(() {
            print("button press was clearall");
            sums = [""];
            print("sums after clear");
            print(sums);
            currentIndex = 0;
            totals = [""];
            totaloutput = "";
          });
        }
        break;
      case "+":
        {
          print("button press was maths  +sign");
          sums[currentIndex] = controllers[currentIndex].text + " + ";
        }
        break;
      case "-":
        {
          print("button press was maths  = sign");
          sums[currentIndex] = controllers[currentIndex].text + " - ";
        }
        break;
      case "*":
        {
          print("button press was maths  *sign");
          sums[currentIndex] = controllers[currentIndex].text + " * ";
        }
        break;
      case "/":
        {
          print("button press was maths  / sign");
          sums[currentIndex] = controllers[currentIndex].text + " / ";
        }
        break;
      case "":
        {
          print("button press was space do nothing");
        }
        break;

      case ".":
        {
          if (sums[currentIndex].contains(".")) {
            final RegExp exp = RegExp(r"[*,/,+,-]");
            String replaacedsigns = (sums[currentIndex].replaceAll((exp), "!"));

            print("replaced with !  $replaacedsigns");

            if (replaacedsigns.contains("!")) {
              List<String> resultreplaced = (replaacedsigns.split("!"));
              String lastsum = resultreplaced.last;
              print("lastsum $lastsum");

              if (lastsum.contains(".")) {
                print("contains a dot already");
              } else {
                sums[currentIndex] = controllers[currentIndex].text + ".";
                evaluateSum(sums[currentIndex]);
              }
            }
          } else {
            sums[currentIndex] = controllers[currentIndex].text + ".";
            evaluateSum(sums[currentIndex]);
          }
        }
        break;
      case "C":
        {
          currentIndex = currentIndex - 1;
          sums.removeLast();
          totals.removeLast();
          controllers.removeLast();
          fNodes.removeLast();
          controllers.removeLast();
          //TODO: fix running total(totalsoutput)
        }
        break;

      default:
        {
          sums[currentIndex] = controllers[currentIndex].text + buttonText;
          print("current sum as of now  : ${sums[currentIndex]}");
          evaluateSum(sums[currentIndex]);
          setState(() {});
        }
    }

    setState(() {});
  }

  sumsForSaving(String fName) {
    String string = "";
    string = sums.toString();
    print("sums to string $string");
    for (var i = 0; i < sums.length; i++) {
      string = string + "\"" + sums[i].toString() + "\",";
    }
    string = "[" + string + "]";
    print("string with   is $string");
    fileutils.saveMyFile(string, fileName);
    return;
  }

  moveToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   FocusManager.instance.primaryFocus?.unfocus();
        // });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: my_color,
          title: Text("Note & Calculate"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => {
                    admobHelper.showInterad(),
                    Share.share(saveSheetAsText())
                  },
                  child: Icon(
                    Icons.share,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    _displayDialog(context);
                    if (fileName != "") {
                      print("filename   $fileName");
                      setState(() {
                        sumsForSaving(fileName);

                        showSimpleFlushbar(context, "file saved");
                        fileName = '';
                      });
                    }
                  },
                  child: Icon(
                    Icons.save_outlined,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => {moveToSettings()},
                  child: Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        drawer: MainDrawer(),
        body: Container(
          child: Column(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                child: ListView.separated(
                  itemCount: sums.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(sums[index]),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(() {
                            sums.removeAt(index);
                            totals.removeAt(index);
                            fNodes.remove(index);
                            controllers.remove(index);
                            isVisible = true;
                            smPadVisible = false;
                          });
                          fNodes[currentIndex].unfocus();
                          showSimpleFlushbar(context, "item removed ");
                        } else if (direction == DismissDirection.endToStart) {}
                      },
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.delete_forever_outlined,
                            color: Colors.white, size: 36.0),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        //textBaseline: TextAlignVertical.bottom,
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: readOnly,
                              showCursor: true,
                              focusNode: fNodes[index],
                              controller: controllers[index] =
                                  TextEditingController.fromValue(
                                      TextEditingValue(
                                          text: sums[index],
                                          selection: TextSelection.collapsed(
                                              offset: sums[index].length))),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              keyboardType: TextInputType.multiline,
                              maxLength: null,
                              maxLines: null,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: font_size),
                              onTap: () {
                                isVisible = false;
                                currentIndex = index;
                                print("textfild tapped");
                              },
                              onEditingComplete: () {
                                sums[currentIndex] =
                                    controllers[currentIndex].text;

                                print(sums);

                                setState(() {
                                  evaluateSum(sums[currentIndex]);
                                });

                                fNodes[currentIndex].requestFocus();
                              },
                            ),
                          ),
                          Text(""),
                          if (totals[index] != "")
                            Text(
                              "  =  " + totals[index] + "   ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: font_size),
                            ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                    color: my_color,
                    thickness: 0,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Visibility(
                  visible: smPadVisible,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    color: Colors.grey.shade300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            child: Text(" 1  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () => {
                                  controllers[currentIndex].text =
                                      controllers[currentIndex].text + "1",
                                  controllers[currentIndex].selection =
                                      TextSelection.collapsed(
                                          offset: controllers[currentIndex]
                                              .text
                                              .length),
                                }),
                        InkWell(
                            child: Text(" 2  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "2";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                        InkWell(
                            child: Text(" 3  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "3";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                        InkWell(
                            child: Text(" 4  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "4";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                        InkWell(
                            child: Text(" 5  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "5";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                        InkWell(
                            child: Text(" 6  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    ////fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "6";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text(" 7  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "7";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text(" 8  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "8";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                        InkWell(
                            child: Text(" 9  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "9";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                        InkWell(
                            child: Text(" 0 ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "0";

                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                              evaluateABC(controllers[currentIndex].text);
                            }),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: smPadVisible,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                    color: Colors.grey.shade300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            child: Text(" AC ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () {
                              buttonPressed("AC");
                            }),
                        InkWell(
                            child: Text(" C ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                            onTap: () => buttonPressed("C")),
                        InkWell(
                            child: Text("  .  ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 40)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + ".";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text(" / ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 26)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "  /  ";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text(" * ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "  *  ";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text(" -  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 35)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "  -  ";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text(" +  ",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                            onTap: () {
                              controllers[currentIndex].text =
                                  controllers[currentIndex].text + "  +  ";
                              controllers[currentIndex].selection =
                                  TextSelection.collapsed(
                                      offset: controllers[currentIndex]
                                          .text
                                          .length);
                            }),
                        InkWell(
                            child: Text("  =  ",
                                style: TextStyle(
                                    color: my_color,

                                    //fontWeight: FontWeight.bold,
                                    fontSize: 30)),
                            onTap: () {
                              sums[currentIndex] =
                                  controllers[currentIndex].text;
                              evaluateSum(sums[currentIndex]);
                              isVisible = true;
                              smPadVisible = false;
                              buttonPressed("=");
                              fNodes[currentIndex].unfocus();
                              isVisible = false;
                              smPadVisible = true;
                              fNodes[currentIndex].requestFocus();
                            }),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  //row to hold icons and final addition
                  color: Colors.grey.shade400,
                  margin: const EdgeInsets.all(1.0),
                  child: Row(
                    children: [
                      //hide show number pad
                      IconButton(
                        icon: Icon(Icons.keyboard_hide_outlined),
                        color: my_color,
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            loadListfromFile();
                            isVisible = !isVisible;
                            if (isVisible == true) {
                              Icon(Icons.keyboard_hide_outlined);
                            } else {
                              Icon(Icons.keyboard_alt_outlined);
                            }
                          });
                          print("Keyboard pressed");
                        },
                      ),
                      TextButton(
                        child: Text("abc",
                            style: TextStyle(fontSize: 18, color: my_color)),
                        onPressed: () {
                          pressABC();
                        },
                      ),
                      TextButton(
                        child: Text("123",
                            style: TextStyle(fontSize: 16, color: my_color)),
                        onPressed: () {
                          press123();
                        },
                      ),
                      //save a file
                      //save a file

                      Spacer(),
                      //container for holding sum total.
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          totaloutput,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildbutton('AC', Colors.grey.shade400,
                              Colors.red.shade700, 21.0),
                          buildbutton('C', Colors.grey.shade400,
                              Colors.red.shade700, 21.0),
                          buildbutton(
                              '<<<', Colors.grey.shade400, Colors.black, 21.0),
                          buildbutton(
                              "/", Colors.grey.shade400, Colors.black, 21.0),
                        ],
                      ),
                      Row(
                        children: [
                          buildbutton("7", Colors.grey.shade300),
                          buildbutton("8", Colors.grey.shade300),
                          buildbutton("9", Colors.grey.shade300),
                          buildbutton(
                              "*", Colors.grey.shade400, Colors.black, 21.0),
                        ],
                      ),
                      Row(
                        children: [
                          buildbutton("4", Colors.grey.shade300),
                          buildbutton("5", Colors.grey.shade300),
                          buildbutton("6", Colors.grey.shade300),
                          buildbutton(
                              "-", Colors.grey.shade400, Colors.black, 21.0),
                        ],
                      ),
                      Row(
                        children: [
                          buildbutton("1", Colors.grey.shade300),
                          buildbutton("2", Colors.grey.shade300),
                          buildbutton("3", Colors.grey.shade300),
                          buildbutton(
                              "+", Colors.grey.shade400, Colors.black, 21.0),
                        ],
                      ),
                      Row(
                        children: [
                          buildbutton(".", Colors.grey.shade300),
                          buildbutton("0", Colors.grey.shade300),
                          buildbutton("00", Colors.grey.shade300),
                          // buildbutton('CLEAR', Colors.grey.shade400),
                          buildbutton("=", my_color, Colors.white, 21.0),
                        ],
                      ),
                      Container(
                        height: 50,
                        child: AdWidget(ad: bAd..load()),
                      )
                    ],
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget buildbutton(String buttonVal, Color btnColor,
      [textcolor = Colors.black, textsize = 16.0]) {
    return new Expanded(
        child: Container(
      padding: EdgeInsets.all(pad_size),
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.all(4.0),
        child: Text(
          buttonVal,
          style: TextStyle(fontSize: textsize),
        ),
        onPressed: () => buttonPressed(buttonVal),
        textColor: textcolor
        //buttonPressed(ButtonVal)
        ,
      ),
    ));
  }

  void showSimpleFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.green,
      ),
      leftBarIndicatorColor: Colors.green,
    )..show(context);
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    var result = await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text('enter filename'),
              content: TextField(
                controller: _textFieldController,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "filename?"),
                onChanged: (text) {
                  fileName = _textFieldController.text;
                },
              ),
              actions: <Widget>[
                new ElevatedButton(
                  child: new Text('Save File'),
                  onPressed: () {
                    fileName = _textFieldController.text;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));

    if (result != "") {
      fileName = _textFieldController.text + ".txt";
      fileutils.saveMyFile(sums.toString(), fileName);
      showSimpleFlushbar(context, "file saved : $fileName ");
      fileName = '';
    } else {
      showSimpleFlushbar(context, "illegal name");
    }
  }
}
