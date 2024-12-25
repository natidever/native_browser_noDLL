import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/webview_controller.dart';

class BrowserNavigationBar extends StatelessWidget {
  final WebViewController controller = Get.find();
  final TextEditingController urlController = TextEditingController();

  BrowserNavigationBar({super.key});

  void _handleSearch() {
    print('NavigationBar: Search button clicked');
    if (urlController.text.isNotEmpty) {
      print('NavigationBar: Loading URL: ${urlController.text}');
      controller.loadUrl(urlController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('NavigationBar: Building navigation bar');
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => IconButton(
                          icon: Icon(Icons.arrow_back, 
                            color: controller.canGoBack.value 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface.withOpacity(0.38)),
                          onPressed: () {
                            print('NavigationBar: Back button clicked');
                            controller.goBack();
                          },
                        )),
                    Obx(() => IconButton(
                          icon: Icon(Icons.arrow_forward,
                            color: controller.canGoForward.value 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.onSurface.withOpacity(0.38)),
                          onPressed: () {
                            print('NavigationBar: Forward button clicked');
                            controller.goForward();
                          },
                        )),
                    IconButton(
                      icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
                      onPressed: () {
                        print('NavigationBar: Refresh button clicked');
                        controller.reload();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                            hintText: 'Search or enter URL',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, 
                              color: theme.colorScheme.onSurfaceVariant),
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _handleSearch,
                            ),
                          ),
                          onSubmitted: (url) {
                            print('NavigationBar: URL submitted via keyboard: $url');
                            controller.loadUrl(url);
                          },
                        ),
                      ),
                      MaterialButton(
                        onPressed: _handleSearch,
                        color: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(() => controller.isLoading.value
              ? LinearProgressIndicator(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                )
              : const SizedBox(height: 4)),
        ],
      ),
    );
  }
}
