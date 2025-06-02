import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool hasPermission = false;
  bool isFlashOn = false;

  late MobileScannerController scannerController;

  @override
  void initState() {
    super.initState();
    scannerController = MobileScannerController(
      //detectionSpeed: DetectionSpeed.noDuplicates,
      //facing: CameraFacing.back,
    );
    _checkPermissions();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final status = await Permission.camera.request();
    setState(() {
      hasPermission = status.isGranted;
    });
  }

  Future<void> _processScannedData(String? data) async {
    if (data == null) return;

    scannerController.stop();

    String type = 'text';
    if (data.startsWith('BEGIN:VCARD')) {
      type = 'contact';
    } else if (data.startsWith('http://') || data.startsWith('https://')) {
      type = 'url';
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, controller) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),),
                Text("Scanned Result: ", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 16),

                Text("Type: ${type.toUpperCase()}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(data,
                          style: Theme.of(context).textTheme.bodyLarge),
                        SizedBox(height: 24),
                        if (type == 'url')
                          ElevatedButton.icon(onPressed: (){
                            _launchUrl(data);
                          },
                            icon: Icon(Icons.open_in_new),
                            label: Text("Open URL"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),),
                          ),
                        if (type == 'contact')
                          ElevatedButton.icon(onPressed: (){
                            _saveContact(data);
                          },
                            icon: Icon(Icons.open_in_new),
                            label: Text("Save Contact"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50),),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Share.share(data);
                        },
                        icon: Icon(Icons.share),
                        label: Text("Share"),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          scannerController.start();
                        },
                        icon: Icon(Icons.qr_code_scanner),
                        label: Text("Scan Again"),
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _saveContact(String vCardData) async {
    final lines = vCardData.split('\n');
    String? name, phone, email;
    for (var line in lines) {
      if (line.startsWith('FN:')) {
        name = line.substring(3).trim();
      } else if (line.startsWith('TEL:')) {
        phone = line.substring(4).trim();
      } else if (line.startsWith('EMAIL:')) {
        email = line.substring(5).trim();
      }
    }

    final contact = contacts.Contact()
      ..name.first = name ?? ''
      ..phones = [contacts.Phone(phone ?? '')]
      ..emails = [contacts.Email(email ?? '')];

    try {
      await contact.insert();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contact saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save contact: $e")),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // If permission is not granted, show the permission request screen
    if(!hasPermission) {
      return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text("QR Scanner"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 350,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text("Camera Permission Is Required"),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _checkPermissions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white
                          ),
                          child: Text("Grant Permission"),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            )
          ],
        )
      );
    } else {
      // If permission is granted, show the scanner
      return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text("QR Scanner"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: (){
                setState(() {
                  isFlashOn = !isFlashOn;
                  scannerController.toggleTorch();
                });
              }, icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  _processScannedData(code);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to read QR code")),
                  );
                }
              },
            ),

            Positioned(
              top: 24,
              left: 20,
              right: 20,
              child: Center(
                child: Text(
                  "Align the QR code within the frame",
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
            )
          ],
        )
      );
    }
  }
}
