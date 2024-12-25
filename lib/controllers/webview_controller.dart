import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';

class WebViewController extends GetxController {
  final webview = WebviewController();
  final RxString currentUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool canGoBack = false.obs;
  final RxBool canGoForward = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('WebViewController: onInit called');
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print('WebViewController: Starting platform initialization');
    try {
      print('WebViewController: Initializing webview');
      await webview.initialize();
      print('WebViewController: Webview initialized successfully');

      await webview.setBackgroundColor(Colors.white);
      print('WebViewController: Background color set');

      webview.url.listen((url) {
        print('WebViewController: URL changed to: $url');
        currentUrl.value = url;
      });

      webview.loadingState.listen((state) {
        print('WebViewController: Loading state changed to: $state');
        isLoading.value = state == LoadingState.loading;
      });

      print('WebViewController: Loading initial URL');
      await loadUrl('https://google.com');
      print('WebViewController: Initial URL loaded');
    } catch (e) {
      print('WebViewController: Error in initialization: $e');
      print('WebViewController: Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> loadUrl(String url) async {
    print('WebViewController: Attempting to load URL: $url');
    if (!url.startsWith('http')) {
      url = 'https://$url';
      print('WebViewController: Modified URL to: $url');
    }
    try {
      print('WebViewController: Calling webview.loadUrl()');
      await webview.loadUrl(url);
      print('WebViewController: URL load request completed');
    } catch (e) {
      print('WebViewController: Error loading URL: $e');
      print('WebViewController: Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> reload() async {
    print('WebViewController: Reloading page');
    await webview.reload();
  }

  Future<void> goBack() async {
    print('WebViewController: Going back');
    try {
      await webview.goBack();
    } catch (e) {
      print('WebViewController: Error going back: $e');
    }
  }

  Future<void> goForward() async {
    print('WebViewController: Going forward');
    try {
      await webview.goForward();
    } catch (e) {
      print('WebViewController: Error going forward: $e');
    }
  }

  @override
  void onClose() {
    print('WebViewController: Disposing webview');
    webview.dispose();
    super.onClose();
  }
}
