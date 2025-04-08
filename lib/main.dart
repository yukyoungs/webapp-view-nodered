import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Node-RED Dashboard Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const NodeRedDashboard(),
    );
  }
}

class NodeRedDashboard extends StatefulWidget {
  const NodeRedDashboard({super.key});

  @override
  State<NodeRedDashboard> createState() => _NodeRedDashboardState();
}

class _NodeRedDashboardState extends State<NodeRedDashboard> {
  late final WebViewController controller;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
            print('Loading URL: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            print('Finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              errorMessage = '${error.errorType}: ${error.description}';
            });
            print('WebView error: ${error.errorType} - ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('http://192.168.30.221:1880/ui'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Node-RED Dashboard'),
        backgroundColor: Colors.white, // 하얀색으로 설정
        foregroundColor: Colors.black, // 텍스트, 아이콘을 검정색으로 설정 (가독성 확보)
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                errorMessage = null;
                isLoading = true;
              });
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (errorMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      '연결 오류',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          errorMessage = null;
                          isLoading = true;
                        });
                        controller.reload();
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
