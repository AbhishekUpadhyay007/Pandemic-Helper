import 'package:covid/Screens/Dashboard.dart';
import 'package:covid/Screens/Profile.dart';
import 'package:covid/Screens/SignUpForm.dart';
import 'package:covid/Screens/Volunteer.dart';
import 'package:covid/http/LocationStats.dart';
import 'package:covid/http/NewsData.dart';
import 'package:covid/http/PostListener.dart';
import 'package:covid/http/UploadPost.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'Screens/NewsScreen.dart';
import './Screens/Statistics.dart';
import './Screens/Authentication.dart';
import './Screens/SplashScren.dart';
import './http/GetData.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import './helper/StateAlias.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => GetHttpData()),
          ChangeNotifierProvider(create: (ctx) => LocationStats()),
          ChangeNotifierProvider(create: (ctx) => NewsData()),
          ChangeNotifierProvider(create: (ctx) => UploadPost()),
          // ChangeNotifierProvider(create: (ctx) => PostListener())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Montserrat',
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headline2: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
              headline3: TextStyle(fontSize: 13, color: Colors.white),
              headline4: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              headline5: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              bodyText2: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
              bodyText1: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[500]),
            ),
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
          initialRoute: '/',
          routes: {
            DashboardScreen.routeName: (ctx) => DashboardScreen(),
            MyHomePage.routeName: (ctx) => MyHomePage(),
            Authentication.routeName: (ctx) => Authentication(),
            Profile.routeName: (ctx) => Profile(),
            SignUpForm.routeName: (ctx) => SignUpForm()
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/MyHomePage';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  // final pageController = PageController();

  var countryCode;
  var statename;
  var stateCode;
  var subAdmin;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    // pageController.dispose();
  }

  void getLocation() async {
    final location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      print('Service isn\'t enabled !');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
      print('Service Enabled!');
    }

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('permission granted!');
        return;
      }
    }

    print('getting location....');
    _locationData = await location.getLocation();
    final coordinates =
        Coordinates(_locationData.latitude, _locationData.longitude);
    print('here');
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    print('location successfully got.');
    countryCode = address[0].countryCode;
    statename = address[0].adminArea;
    subAdmin = address[0].subAdminArea;
    // print(subAdmin);
    stateCode = StateAlias.getStateAlias(statename);
    setState(() {
      Provider.of<GetHttpData>(context, listen: false)
          .getConfirmedStats(stateCode);
      Provider.of<GetHttpData>(context, listen: false)
          .getRecoverStats(stateCode);
      Provider.of<LocationStats>(context, listen: false)
          .fetchDistrictData(subAdmin, statename);
      Provider.of<GetHttpData>(context, listen: false).getCountryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      DashboardScreen(
        countryCode: countryCode,
        stateCode: stateCode,
        statename: statename,
        subAdmin: subAdmin,
      ),
      StatisticScreen(),
      VolunteerScreen(),
      NewsScreen(),
      Profile()
    ];

    return Scaffold(
      // body: PageView(
      //   physics: NeverScrollableScrollPhysics(),
      //   children: screens,
      //   controller: pageController,
      //   onPageChanged: changePage,
      // ),
      body: IndexedStack(
        children: screens,
        index: currentIndex,
      ),
      bottomNavigationBar: _bottomNavbar(),
    );
  }

  BubbleBottomBar _bottomNavbar() {
    return BubbleBottomBar(
      opacity: .2,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      elevation: 2,
      hasInk: true,
      items: [
        BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Colors.red,
            ),
            title: Text("Home")),
        BubbleBottomBarItem(
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.access_time,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.access_time,
              color: Colors.green,
            ),
            title: Text("Stats")),
        BubbleBottomBarItem(
            backgroundColor: Colors.purple[400],
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.purple,
            ),
            title: Text("Logs")),
        BubbleBottomBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(
              Icons.folder_open,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.folder_open,
              color: Colors.indigo,
            ),
            title: Text("News")),
        BubbleBottomBarItem(
            backgroundColor: Colors.pink[300],
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.account_circle_outlined,
              color: Colors.pink,
            ),
            title: Text("Profile")),
      ],
    );
  }
}
