import 'package:covid/Screens/Symptoms.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import '../../helper/Helpline_number.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageCarousel extends StatelessWidget {
  final String stateName;
  ImageCarousel(this.stateName);

  void _openBrowser(context) {
    var url = 'https://www.cowin.gov.in/';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Notice', style: TextStyle(fontWeight: FontWeight.bold)),
        content:
            Text('You\'re leaving the app. Are you sure want to continue?'),
        actions: [
          TextButton(
              onPressed: () async {
                await canLaunch(url)
                    ? await launch(url).then((value) => Navigator.pop(context))
                    : throw 'Could not launch $url';
              },
              child: Text(
                'Lets\'s proceed',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('close',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .33,
      width: double.infinity,
      child: Carousel(
        dotSize: 4.0,
        dotIncreaseSize: 1.8,
        dotSpacing: 12,
        dotVerticalPadding: 0,
        dotBgColor: Colors.transparent,
        autoplayDuration: Duration(milliseconds: 3000),
        animationDuration: Duration(milliseconds: 600),
        images: [
          GestureDetector(
            onTap: () {
              print('image 1');
              showModalBottomSheet(
                  context: context,
                  builder: (context) => HelpLineBottomSheet(stateName));
            },
            child: Image(
              image: AssetImage('assets/images/dashone.png'),
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SymptomsScreen(),
                ),
              );
            },
            child: Image(
              image: AssetImage('assets/images/dashtwo.png'),
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: () => _openBrowser(context),
            child: Image(
              image: AssetImage('assets/images/dashthree.png'),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class HelpLineBottomSheet extends StatelessWidget {
  final String stateName;
  HelpLineBottomSheet(this.stateName);

  Widget getNumberTile(String number, String title) {
    return ListTile(
      title: Text(
        number,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(title, style: TextStyle(fontSize: 15)),
      trailing: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.red)),
            ),
          ),
          onPressed: () async {
            var _url = 'tel://$number';
            await canLaunch(_url)
                ? await launch(_url)
                : throw 'Could not launch $_url';
          },
          icon: Icon(Icons.call, color: Colors.red),
          label: Text(
            'Call',
            style: TextStyle(color: Colors.red),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> helpline =
        HelplineNumbers.getHelplineNumber(stateName) as List<String>;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        // height: MediaQuery.of(context).size.height * .48,
        child: Column(
          children: [
            Text(
              'Helpline number(s) are available according to your location.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Text('$stateName helpline number(s): ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 2,
                ),
                Icon(Icons.local_hospital_outlined, color: Colors.red)
              ],
            ),
            ListView.builder(
                itemCount: helpline.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return ListTile(
                    title: Text(
                      helpline.elementAt(i),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    subtitle: Text(
                      "Official $stateName helpline",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: ElevatedButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red)),
                        onPressed: () async {
                          var _url = 'tel://${helpline.elementAt(i)}';
                          await canLaunch(_url)
                              ? await launch(_url)
                              : throw 'Could not launch $_url';
                        },
                        icon: Icon(Icons.call),
                        label: Text('Call')),
                  );
                }),
            Divider(
              thickness: 1,
            ),
            Text(
              'Covid - 19 National Helpline Numbers',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            getNumberTile('1075', "National Helpline Number"),
            getNumberTile('1098', "Child Helpline Number"),
            getNumberTile('1443', "Ayush Covid Helpline"),
            getNumberTile('14567', "Senior Citizen Helpline"),
          ],
        ),
      ),
    );
  }
}
