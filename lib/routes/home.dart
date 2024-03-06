
import '../exports.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  final Map<int,Widget> bodyWidget = {
    0:const MainPage(),
    1:const OnlineMatchesScreen(),
    2:const Stats(),
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Container(
      decoration: const BoxDecoration(
        border: null,
        image: DecorationImage(
            image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: const Key("Home"),
        body: bodyWidget[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          height: 50,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          backgroundColor: const Color(0x89000000),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(icon: Icon(Icons.home), label: 'home'),
            NavigationDestination(icon: Icon(Icons.online_prediction), label: 'online'),
            NavigationDestination(icon: Icon(Icons.sports_cricket), label: 'stats'),
          ],
        ),
      ),
    ));
  }
}
