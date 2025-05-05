import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  CameraDescription? _selectedCamera; // To store the selected camera

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitializeCamera();
  }

  Future<void> _requestPermissionAndInitializeCamera() async {
    var status = await Permission.camera.request();
    print("Camera Permission Status: $status");
    if (!mounted) return; // Avoid calling setState if widget is disposed
    setState(() {
      _cameraPermissionStatus = status;
    });

    if (status.isGranted) {
      _initializeCamera();
    } else if (status.isPermanentlyDenied) {
      print(
          "Camera permission permanently denied. User needs to go to settings.");
      _showSettingsDialog();
    } else if (status.isRestricted) {
      print("Camera permission restricted (e.g., parental controls).");
    } else {
      print("Camera permission was denied, but not permanently.");
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print("No cameras available");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('No cameras found on this device.')));
        }
        return;
      }

      _selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Dispose existing controller if any before creating a new one
      await _controller?.dispose();

      _controller = CameraController(
        _selectedCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();

      if (mounted) {
        setState(() {}); // Trigger rebuild to use the new future
      }
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error initializing camera: ${e.description}')));
      }
    } catch (e) {
      print('Unexpected error during camera setup: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not set up camera: $e')));
      }
    }
  }

  void _showSettingsDialog() {
    // Check if the dialog is already open
    if (ModalRoute.of(context)?.isCurrent != true) {
      Navigator.of(context).pop(); // Close any existing dialog first if needed
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Camera Permission'),
        content: const Text(
            'Camera permission is required. Please go to app settings to enable it.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // --- BUILD METHOD MODIFIED ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar can be removed if you want a full-screen preview
      // appBar: AppBar(title: const Text('Camera Preview')),
      backgroundColor:
          Colors.black, // Ensure background is black for camera feel
      body: Center(
        child: switch (_cameraPermissionStatus) {
          PermissionStatus.granted => FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _controller != null &&
                    _controller!.value.isInitialized) {
                  // --- Use a Stack to overlay controls ---
                  return Stack(
                    fit: StackFit.expand, // Make stack children fill the space
                    children: [
                      // Layer 1: Camera Preview
                      Center(
                        // Center the preview to handle aspect ratio differences
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      ),

                      // Layer 2: Control Buttons (Positioned at the bottom)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 30.0), // Adjust padding from bottom
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.4), // Semi-transparent background
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Row takes minimum width
                              children: [
                                // Switch Camera Button
                                IconButton(
                                  icon: const Icon(Icons.switch_camera,
                                      color: Colors.white, size: 28),
                                  tooltip: 'Switch Camera',
                                  onPressed:
                                      _switchCamera, // Use existing switch function
                                ),
                                const SizedBox(
                                    width: 40), // Spacing between buttons

                                // End Call Button
                                IconButton(
                                  icon: const Icon(Icons.call_end,
                                      color: Colors.red, size: 35),
                                  tooltip: 'End Call',
                                  onPressed: () {
                                    // Action: Pop the current screen
                                    Navigator.pop(context);
                                  },
                                ),
                                // Add other buttons here (mute, disable video etc.) if needed
                                const SizedBox(width: 40), // Spacing

                                // Placeholder for another button (e.g., Mute)
                                IconButton(
                                  icon: const Icon(Icons.mic_off,
                                      color: Colors.white, size: 28),
                                  tooltip: 'Mute (Placeholder)',
                                  onPressed: () {
                                    // TODO: Implement mute functionality if needed
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Mute button pressed (not implemented)')));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error initializing camera: ${snapshot.error}',
                      style: TextStyle(color: Colors.white));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          PermissionStatus.denied => const Text(
              'Camera permission is required. Please grant permission.',
              style: TextStyle(color: Colors.white)),
          PermissionStatus.permanentlyDenied => Column(
              // Use column to add button
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Camera permanently denied. Go to Settings.',
                    style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showSettingsDialog, // Reuse dialog function
                  child: const Text('Open Settings'),
                )
              ],
            ),
          PermissionStatus.restricted => const Text(
              'Camera access is restricted.',
              style: TextStyle(color: Colors.white)),
          _ => const CircularProgressIndicator(), // Initial check state
        },
      ),
      // Removed the floating action button as controls are now in the bottom bar
      // floatingActionButton: ...
    );
  }

  Future<void> _switchCamera() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) {
      print('Controller not ready or busy.');
      return;
    }

    final cameras = await availableCameras();
    if (cameras.length < 2) {
      print('Only one camera available, cannot switch.');
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No other camera to switch to.')));
      return;
    }

    CameraDescription newCamera;
    if (_selectedCamera!.lensDirection == CameraLensDirection.front) {
      newCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first); // Fallback just in case
    } else {
      newCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first);
    }

    // Don't dispose here, initializeCamera will handle it
    _selectedCamera = newCamera;
    // Re-initialize with the new camera description
    _initializeCamera();
  }
}
