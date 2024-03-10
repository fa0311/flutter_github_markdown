import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';

String wrapInHtml({required String colorScheme, required String body}) {
  return '''
<!doctype html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimal-ui">
    <title>flutter_github_markdown</title>
    <meta name="color-scheme" content="$colorScheme">
    <link rel="stylesheet"
        href="https://raw.githubusercontent.com/sindresorhus/github-markdown-css/gh-pages/github-markdown.css">
</head>

<body>
    <article class="markdown-body">
        $body
    </article>
</body>
''';
}

class FlutterGithubMarkdown extends StatelessWidget {
  const FlutterGithubMarkdown({
    super.key,
    required this.body,
    this.onTapUrl,
  });

  final String body;
  final void Function(String url)? onTapUrl;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).colorScheme.brightness;
    final isDarkMode = brightness == Brightness.dark;
    final template = wrapInHtml(
      colorScheme: isDarkMode ? 'dark' : 'light',
      body: markdownToHtml(body),
    );

    final navigation = NavigationDelegate(
      onNavigationRequest: (url) {
        onTapUrl?.call(url.url);
        return NavigationDecision.prevent;
      },
    );

    final controller = WebViewController()
      ..loadHtmlString(template)
      ..setNavigationDelegate(navigation);

    return WebViewWidget(
      controller: controller,
    );
  }
}
