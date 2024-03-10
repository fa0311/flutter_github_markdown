import 'package:flutter/material.dart';
import 'package:flutter_github_markdown/flutter_github_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const text =
      'https://raw.githubusercontent.com/flutter/flutter/master/README.md';

  String body = "loading...";
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    final url = Uri.parse(text);

    http.get(url).then((response) {
      setState(() => body = response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  onPressed: () {
                    setState(() => isDark = !isDark);
                  },
                ),
              ],
            ),
            Expanded(
              child: FlutterGithubMarkdown(
                body: body,
                onTapUrl: (text) async {
                  final url = Uri.parse(text);
                  if (!await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
