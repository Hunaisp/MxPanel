import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

void main() async {
  // Ensures Flutter is properly initialized before using asynchronous operations.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Mixpanel with the provided project token and sets default tracking behavior.
  Mixpanel mixpanel = await Mixpanel.init("4221c1caf1f11651054c15081d96062d", optOutTrackingDefault: false, trackAutomaticEvents: true);

  // Runs the main application and passes the initialized Mixpanel instance.
  runApp(MyApp(mixpanel: mixpanel));
}


class MyApp extends StatelessWidget {
  final Mixpanel mixpanel;

  const MyApp({Key? key, required this.mixpanel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sets the title of the application displayed in the app switcher.
      title: 'Mixpanel Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Defines the default screen of the app and passes the Mixpanel instance to it.
      home: HomeScreen(mixpanel: mixpanel),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Mixpanel mixpanel;

  const HomeScreen({Key? key, required this.mixpanel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mixpanel Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Tracks a custom event 'Button Clicked' with additional properties for analysis.
                mixpanel.track('Button Clicked', properties: {
                  'button_name': 'Track Event',
                  'screen': 'HomeScreen',
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Event Tracked!')),
                );
              },
              child: Text('Track Event'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigates to the User Profile screen while passing the Mixpanel instance.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen(mixpanel: mixpanel)),
                );
              },
              child: Text('Go to User Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigates to the Settings screen while passing the Mixpanel instance.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(mixpanel: mixpanel)),
                );
              },
              child: Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final Mixpanel mixpanel;

  const UserProfileScreen({Key? key, required this.mixpanel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Identifies the user in Mixpanel with a unique ID.
                mixpanel.identify('user_12345');
                // Updates the user's profile in Mixpanel with provided attributes like name and email.
                mixpanel.getPeople().set("name", "John Doe");
                mixpanel.getPeople().set("email", "john.doe@example.com");
                mixpanel.getPeople().set("subscription", "premium");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User Profile Updated!')),
                );
              },
              child: Text('Identify User'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final Mixpanel mixpanel;

  const SettingsScreen({Key? key, required this.mixpanel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Registers super properties that will be included with all tracked events.
                mixpanel.registerSuperProperties({
                  'platform': 'flutter',
                  'app_version': '1.0.0',
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Super Properties Registered!')),
                );
              },
              child: Text('Register Super Properties'),
            ),
            ElevatedButton(
              onPressed: () {
                // Disables Mixpanel tracking for the user.
                mixpanel.optOutTracking();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opted Out of Tracking!')),
                );
              },
              child: Text('Opt Out of Tracking'),
            ),
            ElevatedButton(
              onPressed: () {
                // Re-enables Mixpanel tracking for the user.
                mixpanel.optInTracking();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opted In to Tracking!')),
                );
              },
              child: Text('Opt In to Tracking'),
            ),
          ],
        ),
      ),
    );
  }
}
