import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PptViewerScreen extends StatefulWidget {
  final String pptUrl;

  const PptViewerScreen({super.key, required this.pptUrl});

  @override
  State<PptViewerScreen> createState() => _PptViewerScreenState();
}

class _PptViewerScreenState extends State<PptViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  WebViewController? _webViewController;
  bool isPpt = false;

  @override
  void initState() {
    super.initState();
    _checkFileTypeAndLoad();
  }

  Future<void> _checkFileTypeAndLoad() async {
    final extension = widget.pptUrl.split('.').last.toLowerCase();
    if (extension == 'ppt' || extension == 'pptx') {
      setState(() {
        isPpt = true;
        isLoading = false;
      });
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.parse(
            'https://docs.google.com/gview?embedded=true&url=${widget.pptUrl}',
          ),
        );
      _downloadToTemp();
    } else {
      _loadPdf();
    }
  }

  Future<void> _downloadToTemp() async {
    try {
      final filename = widget.pptUrl.split('/').last;
      final request = await http.get(Uri.parse(widget.pptUrl));
      final bytes = request.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);
      if (mounted) {
        setState(() {
          localPath = file.path;
        });
      }
    } catch (e) {
      debugPrint('Error downloading PPT for local path: $e');
    }
  }

  Future<void> _loadPdf() async {
    try {
      final filename = widget.pptUrl.split('/').last;
      final request = await http.get(Uri.parse(widget.pptUrl));
      final bytes = request.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);
      if (mounted) {
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error loading PDF: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadFile() async {
    if (localPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File not ready for download yet')),
      );
      return;
    }

    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }

          if (status.isPermanentlyDenied) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Storage permission permanently denied. Please enable it in settings.',
                  ),
                  action: SnackBarAction(
                    label: 'Open Settings',
                    onPressed: () => openAppSettings(),
                  ),
                ),
              );
            }
            return;
          }

          if (!status.isGranted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Storage permission denied')),
              );
            }
            return;
          }
        }
      }

      Directory? saveDir;
      if (Platform.isAndroid) {
        saveDir = Directory('/storage/emulated/0/Download');
        if (!await saveDir.exists()) {
          saveDir = await getExternalStorageDirectory();
        }
      } else {
        saveDir = await getApplicationDocumentsDirectory();
      }

      if (saveDir == null) {
        throw Exception('Could not find save directory');
      }

      final filename = widget.pptUrl.split('/').last;
      final newFile = File('${saveDir.path}/$filename');
      await File(localPath!).copy(newFile.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File saved to ${newFile.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentation Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadFile,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : isPpt
          ? WebViewWidget(controller: _webViewController!)
          : localPath != null
          ? PDFView(filePath: localPath!)
          : const Center(child: Text('No file to display')),
    );
  }
}
