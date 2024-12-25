import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';
import 'controllers/webview_controller.dart';
import 'widgets/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Main: Application starting');
  Get.put(WebViewController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Main: Building MyApp');
    return GetMaterialApp(
      title: 'Native WebView Window',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BrowserWindow(),
    );
  }
}

class BrowserWindow extends StatelessWidget {
  const BrowserWindow({super.key});

  @override
  Widget build(BuildContext context) {
    print('BrowserWindow: Building window');
    final controller = Get.find<WebViewController>();

    return Scaffold(
      body: Column(
        children: [
          BrowserNavigationBar(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Webview(
                    controller.webview,
                    permissionRequested: (String url, WebviewPermissionKind kind, bool isUserInitiated) {
                      print('BrowserWindow: Permission requested for URL: $url');
                      return Future.value(WebviewPermissionDecision.allow);
                    },
                  ),
                  Obx(() {
                    final isLoading = controller.isLoading.value;
                    print('BrowserWindow: Loading state changed: $isLoading');
                    return isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
