import 'package:flutter/material.dart';
import 'package:insight/src/modules/patient/quotes/quote_view_model.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import 'journal/journal_view.dart';
import 'journal/journal_view_model.dart';
import 'journey/journey_view.dart';
import 'journey/journey_view_model.dart';
import 'profile/profile_view.dart';
import 'safe_space/safe_space_view.dart';
import 'safe_space/safe_space_view_model.dart';
import 'tracker/patient_home_view.dart';

//Class to display the community member home page
class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

//List of pages to be displayed in the bottom navigation bar
  final List<Widget> _pages = [
    const PatientHomeView(),
    ChangeNotifierProvider(
      create: (context) => JournalViewModel(),
      child: const JournalView(),
    ),
    ChangeNotifierProvider(
      create: (context) => JourneyViewModel(),
      child: const JourneyView(),
    ),
    ChangeNotifierProvider(
      create: (context) => SafeSpaceViewModel(),
      child: const SafeSpaceView(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuoteViewModel()),
      ],
      child: Scaffold(
        backgroundColor: ColorsConstant.scaffoldBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('INSIGHT'),
          centerTitle: true,
          backgroundColor: ColorsConstant.primaryDark,
          elevation: 0.0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileView()));
              },
            )
          ],
        ),
        body: Center(
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,
                  color: Colors.black), 
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined,
                  color: Colors.black), 
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined,
                  color: Colors.black), 
              label: 'Journey',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_2_outlined,
                  color: Colors.black), 
              label: 'Safe Space',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
        ),
      ),
    );
  }
}
