import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_easier/widgets_easier.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Widgets Easier',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _githubRepoLink =
      'https://github.com/jacklee1995/widgets_easier';
  final String _pubLink = 'https://pub.dev/packages/widgets_easier';

  Future<void> _goto(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.info,
              color: Colors.amber,
              size: 80,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'In order to reduce the package size, the sample is moved to Widgets Easier Repository, please visit the Repository to get the sample code.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ), // 设置文本颜色为白色
              ),
            ),
            SemanticButton(
              text: 'View on Github',
              onTap: () => _goto(_githubRepoLink),
              type: SemanticEnum.success,
              radius: 8,
              fontSize: 16,
              prefixIcon: const Icon(
                Icons.code,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: 30),
            SemanticButton(
              text: 'View on Pub',
              onTap: () => _goto(_pubLink),
              type: SemanticEnum.primary,
              radius: 8,
              fontSize: 16,
              prefixIcon: const Icon(
                Icons.code,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
