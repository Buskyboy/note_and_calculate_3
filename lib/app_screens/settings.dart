import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global_variables.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  //save persistant settings
  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("fontSize", font_size);
    prefs.setDouble("keyboardSize", pad_size);
    int myColorInteger = my_color.value;
    prefs.setInt("ThemeColor", myColorInteger);
    prefs.setInt("decimal", decimalPlaces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: my_color,
        title: Text('settings'),
        leading: GestureDetector(
            onTap: () {
              setState(() {
                Navigator.of(context).pop();
              });
            },
            child: Icon(Icons.close)),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.grey.shade700,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.color_lens_outlined, color: Colors.white),
              title: Text(
                "theme color",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                showColorDialog(context);
                setState(() {
                  savePreferences();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: (20.0)),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.text_format,
                color: Colors.white,
              ),
              title: Text(
                "font size : $font_size px",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  showFontSizeDialog(context);
                  savePreferences();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: (20.0)),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.precision_manufacturing,
                color: Colors.white,
              ),
              title: Text(
                "show decimal places : $decimalPlaces",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  showDecimalsDialog(context);
                  savePreferences();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: (20.0)),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            ListTile(
              leading: Icon(Icons.color_lens_outlined, color: Colors.white),
              title: Text(
                "keyboard size : $kbs",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  showKeyboardDialog(context);

                  savePreferences();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: (20.0)),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            ListTile(
              leading: Icon(Icons.keyboard_alt_rounded, color: Colors.white),
              title: Text(
                "reset all to default",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  pad_size = 1;
                  my_color = Colors.green;
                  font_size = 14;
                  decimalPlaces = 2;
                  savePreferences();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: (20.0)),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showKeyboardDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Choose KeyBoard Size"),
          children: [
            SimpleDialogOption(
              child: Text('Large'),
              onPressed: () {
                setState(() {
                  print('You have selected the large keyboard');
                  pad_size = 16;
                  kbs = "Large";
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Medium'),
              onPressed: () {
                setState(() {
                  print('You have selected the medium keyboard');
                  pad_size = 6;
                  kbs = "Medium";

                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Small'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  pad_size = 1;
                  kbs = "Small";
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        ),
      );
  showFontSizeDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Choose a font size"),
          children: [
            SimpleDialogOption(
              child: Text('Font size:26'),
              onPressed: () {
                // Do something
                print('You have selected font 26');
                font_size = 26;
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:24'),
              onPressed: () {
                // Do something
                print('You have selected font 24');
                font_size = 24;
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:22'),
              onPressed: () {
                // Do something
                print('You have selected font 22');
                font_size = 22;
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:20'),
              onPressed: () {
                // Do something
                print('You have selectedfont 20');
                font_size = 20;

                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:18'),
              onPressed: () {
                // Do something
                print('You have selected font 18');
                font_size = 18;
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:16'),
              onPressed: () {
                // Do something
                print('You have selected font 16');
                font_size = 16;
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:14'),
              onPressed: () {
                // Do something
                print('You have selected font14');
                font_size = 14;
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('Font size:12'),
              onPressed: () {
                // Do something
                print('You have selected font12');
                font_size = 12;
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );

  showColorDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("Select a theme color"),
          children: [
            SimpleDialogOption(
              child: Text('Purple'),
              onPressed: () {
                setState(() {
                  print('You have selected the large keyboard');
                  my_color = Colors.purple.shade700;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Blue'),
              onPressed: () {
                setState(() {
                  print('You have selected the medium keyboard');
                  my_color = Colors.blue;

                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('GreyBlue'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  my_color = Colors.blueGrey.shade700;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Deep Orange'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  my_color = Colors.deepOrange;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Cyan'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  my_color = Colors.cyan;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      );

  showDecimalsDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text("no of decimal places to show"),
          children: [
            SimpleDialogOption(
              child: Text('00'),
              onPressed: () {
                setState(() {
                  decimalPlaces = 0;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('00.0'),
              onPressed: () {
                setState(() {
                  decimalPlaces = 1;

                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('00.00'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  decimalPlaces = 2;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('00.000'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  decimalPlaces = 3;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('00.0000'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  decimalPlaces = 4;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('00.00000'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  decimalPlaces = 5;
                  Navigator.of(context).pop();
                });
              },
            ),
            SimpleDialogOption(
              child: Text('00.000000'),
              onPressed: () {
                setState(() {
                  print('You have selected the small keyboard');
                  decimalPlaces = 6;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      );
}
