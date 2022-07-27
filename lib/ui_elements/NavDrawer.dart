import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shopping_list/ui_elements/Styles.dart';

class NaveDrawer extends StatelessWidget {
  const NaveDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.red,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildHeader(context), buildMenuItems(context)],
        ),
      ),
    );
  }

  buildHeader(BuildContext context) => Container(
        // color: Colors.blue[300],
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              "App Information",
              style: TextStyle(fontSize: 28, color: Colors.blue[400]),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.black54,
            ),
            SizedBox(height: 15),
          ],
        ),
      );

  buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 18, top: 10),
        child: Wrap(
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            NavItems("App Name", "Task List", Icons.task_alt),
            NavItems("Develop By", "Sanaulla Shaikh", Icons.portrait_rounded),
            NavItems("Email", "srshaikh.work@gmail.com" , Icons.email_outlined),
            NavItems("Contact No", "+91 74 9960 4663" , Icons.contact_phone_outlined),
            NavItems("Website", "www.sanaulla-solapur.in" , Icons.web_sharp),
            NavItems("Publish On", "01 Aug 2022" , Icons.public_sharp),
            
          ],
        ),
      );

  NavItems(String title, String subtitle, IconData icons) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icons, size: 30,color: Colors.blue[400],),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: NavTitle()),
            SizedBox(height: 5),
            Text(subtitle,
              style: NavSubTitle(),
            )
          ],
        )
      ],
    );
  }
}
