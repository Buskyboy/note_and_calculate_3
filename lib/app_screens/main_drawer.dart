import 'package:flutter/material.dart';
import 'file_list.dart';
import 'global_variables.dart';
import 'admob_helper.dart';
import 'file_utils.dart';

class MainDrawer extends StatelessWidget {
  final Fileutils fileutils = new Fileutils();

  AdmobHelper admobHelper = AdmobHelper();

  @override
  Widget build(BuildContext context) {
    admobHelper.createInterad();
    return Drawer(
      child: Material(
        color: my_color,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(0),
              color: my_color,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://www.carlow.edu/app/uploads/2021/01/net-price-calculators.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          "Note & Calculate",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              leading: Icon(Icons.shop, color: Colors.white),
              title: Text(
                "Upgrade",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Upgrade()));
              },
            ),
            ListTile(
              leading: Icon(Icons.note, color: Colors.white),
              title: Text(
                "Load file",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                admobHelper.showInterad();
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoadFileList()));
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.white),
              title: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
