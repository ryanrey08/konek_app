import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:konek_app/auth/providers/auth.dart';
import 'package:konek_app/config/notification.dart';
import 'package:konek_app/content/dashboard.dart';
import 'package:konek_app/content/provider/voucher.dart';
import 'package:konek_app/content/scan.dart';
import 'package:provider/provider.dart';
import 'package:scan/scan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../config/httpexception.dart';

class UploadPicture extends StatefulWidget {
  static const routeName = '/uploadpic';
  const UploadPicture({super.key});

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  List<XFile>? _mediaFileList;
  final _formKey = GlobalKey<FormState>();
  final txtCodeController = TextEditingController();

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  String _platformVersion = 'Unknown';

  String qrCode = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool isMultiImage = false,
    bool isMedia = false,
  }) async {
    if (context.mounted) {
      if (isMedia) {
        try {
          final List<XFile> pickedFileList = <XFile>[];
          final XFile? media = await _picker.pickMedia(
              // maxWidth: maxWidth,
              // maxHeight: maxHeight,
              // imageQuality: quality,
              );
          if (media != null) {
            pickedFileList.add(media);
            setState(() {
              _mediaFileList = pickedFileList;
            });
          }
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      } else {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            // maxWidth: maxWidth,
            // maxHeight: maxHeight,
            // imageQuality: quality,
          );
          setState(() async {
            if (pickedFile != null) {
              _setImageFileListFromFile(pickedFile);
              getQRCode(pickedFile);
            }
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      }
    }
  }

  void enterVoucherCode() {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Enter Voucher Code',
              // style: Theme.of(context).textTheme.titleLarge,
              style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 55, 57, 175),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: txtCodeController,
                  autofocus: true,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                    labelText: 'Voucher Code',
                    //prefixIcon: Icon(Icons.code),
                    errorStyle: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.redAccent[200],
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter voucher code';
                    }
                    // if (!value.contains('@')) {
                    //   return 'Invalid username';
                    // }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              isFixedHeight: false,
              text: 'OK',
              color: Color.fromARGB(255, 55, 57, 175),
              pressEvent: () {
                //dialog.dismiss();
                final isValid = _formKey.currentState!.validate();
                if (!isValid) {
                  return;
                } else {
                  setState(() {
                    qrCode = txtCodeController.text;
                    dialog.dismiss();
                  });
                }
              },
            )
          ],
        ),
      ),
    );

    dialog.show();
  }

  void getQRCode(pickedFile) async {
    String path = pickedFile!.path.toString();

    String? str = await Scan.parse(path);
    setState(() {
      if (str == null) {
        qrCode = 'Invalid Code';
      } else {
        qrCode = str.toString();
      }
    });
    print(str);
  }

  void submitVoucherCode() async {
    var errorMessage;
    try {
      Map<String, dynamic> vouchData = await Provider.of<Voucher>(context, listen: false)
          .registerVoucherCode(qrCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (vouchData['voucher_code'] != '') {
        // var data = json.decode(prefs.getString('voucherData')!) as Map<String, dynamic>;
        NotificationController.scheduleNewNotification(vouchData['description'], vouchData['expire_date']);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      }
      // var voucherData = {
      //   "voucher_code": "123",
      //   "duration": 0,
      //   "description": "1 DAY UNLI DATA-ABC",
      //   "amount": 0,
      //   "claimed_date": "2023-11-15 13:20:41",
      //   "expire_date": "2023-11-16 13:20:41",
      //   "status": "ggfgfgf"
      // };
      //   final preferences = await StreamingSharedPreferences.instance;
      //   preferences.setString('voucherData', json.encode(voucherData));
    } on HttpException catch (error) {
      print(error);
      showError(error.toString());
    } catch (error) {
      showError(error.toString());
    }
    // await Future.delayed(const Duration(seconds: 2));

    // setState(() {
    //   _isLoading = true;
    // });
  }

  void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff404747),
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Semantics(
          label: 'image_picker_example_picked_images',
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              final String? mime = lookupMimeType(_mediaFileList![index].path);

              // Why network for web?
              // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
              return Semantics(
                  label: 'image_picker_example_picked_image',
                  child: kIsWeb
                      ? Image.network(_mediaFileList![index].path)
                      : Image.file(
                          File(_mediaFileList![index].path),
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                                child:
                                    Text('This image type is not supported'));
                          },
                        ));
            },
            itemCount: _mediaFileList!.length,
          ),
        ),
      );
    } else if (_pickImageError != null) {
      // return Text(
      //   'Pick image error: $_pickImageError',
      //   textAlign: TextAlign.center,
      // );
      return Text(
        'QR scanned successfully.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            fontSize: 20,
            color: Color.fromARGB(255, 55, 57, 175),
            fontWeight: FontWeight.bold),
      );
    } else {
      if (qrCode != '') {
        return Text(
          'QR scanned successfully.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 20,
              color: Color.fromARGB(255, 55, 57, 175),
              fontWeight: FontWeight.bold),
        );
      }
      return Text(
        'No Image Uploaded.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
            fontSize: 20,
            color: Color.fromARGB(255, 55, 57, 175),
            fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Upload Image"),
      // ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Text(
                        'No Image Uploaded.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Color.fromARGB(255, 55, 57, 175),
                            fontWeight: FontWeight.bold),
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    case ConnectionState.active:
                      if (snapshot.hasError) {
                        // return Text(
                        //   'Pick image/video error: ${snapshot.error}}',
                        //   textAlign: TextAlign.center,
                        // );
                        return Text(
                          'No Image Uploaded.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Color.fromARGB(255, 55, 57, 175),
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text(
                          'No Image Uploaded.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Color.fromARGB(255, 55, 57, 175),
                              fontWeight: FontWeight.bold),
                        );
                      }
                  }
                },
              )
            : _handlePreview(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 55, 57, 175),
                  onPressed: () {
                    isVideo = false;
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  heroTag: 'image0',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo),
                ),
              ),
              if (_picker.supportsImageSource(ImageSource.camera))
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 55, 57, 175),
                    onPressed: () {
                      isVideo = false;
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    },
                    heroTag: 'image2',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 55, 57, 175),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanQR()),
                    );

                    setState(() {
                      _setImageFileListFromFile(null);
                      qrCode = result;
                    });

                    print(result);
                  },
                  heroTag: 'image3',
                  tooltip: 'Scan QR Code',
                  child: const Icon(Icons.qr_code),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 55, 57, 175),
                  onPressed: () async {
                    enterVoucherCode();
                  },
                  heroTag: 'image4',
                  tooltip: 'Enter Voucher Code',
                  child: const Icon(Icons.input),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 35),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 50,
              width: double.infinity,
              child: Text(
                qrCode != ''
                    ? (qrCode == 'Invalid Code' ? 'Invalid Code' : qrCode)
                    : '---',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 35),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Colors.white,
              ),
              height: 50,
              width: double.infinity,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: Text(
                    //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                    "SUBMIT",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: useMobileLayout ? 14 : 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    primary: Color.fromARGB(255, 55, 57, 175), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: qrCode.toString() == '' || qrCode == "Invalid Code"
                      ? null
                      : () {
                          // Navigator.pushReplacementNamed(
                          //     context, POS.routeName);
                          submitVoucherCode();
                        },
                  // color: Colors.white,
                  // textColor: Colors.black,
                  // splashColor: Colors.yellowAccent[800],
                ),
              ),
            ),
          )

          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       isVideo = false;
          //       _onImageButtonPressed(
          //         ImageSource.gallery,
          //         context: context,
          //         isMultiImage: true,
          //         isMedia: true,
          //       );
          //     },
          //     heroTag: 'multipleMedia',
          //     tooltip: 'Pick Multiple Media from gallery',
          //     child: const Icon(Icons.photo_library),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       isVideo = false;
          //       _onImageButtonPressed(
          //         ImageSource.gallery,
          //         context: context,
          //         isMedia: true,
          //       );
          //     },
          //     heroTag: 'media',
          //     tooltip: 'Pick Single Media from gallery',
          //     child: const Icon(Icons.photo_library),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       isVideo = false;
          //       _onImageButtonPressed(
          //         ImageSource.gallery,
          //         context: context,
          //         isMultiImage: true,
          //       );
          //     },
          //     heroTag: 'image1',
          //     tooltip: 'Pick Multiple Image from gallery',
          //     child: const Icon(Icons.photo_library),
          //   ),
          // ),
          // if (_picker.supportsImageSource(ImageSource.camera))
          //   Padding(
          //     padding: const EdgeInsets.only(left: 16.0),
          //     child: FloatingActionButton(
          //       onPressed: () {
          //         isVideo = false;
          //         _onImageButtonPressed(ImageSource.camera, context: context);
          //       },
          //       heroTag: 'image2',
          //       tooltip: 'Take a Photo',
          //       child: const Icon(Icons.camera_alt),
          //     ),
          //   ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: FloatingActionButton(
          //     backgroundColor: Colors.red,
          //     onPressed: () {
          //       isVideo = true;
          //       _onImageButtonPressed(ImageSource.gallery, context: context);
          //     },
          //     heroTag: 'video0',
          //     tooltip: 'Pick Video from gallery',
          //     child: const Icon(Icons.video_library),
          //   ),
          // ),
          // if (_picker.supportsImageSource(ImageSource.camera))
          //   Padding(
          //     padding: const EdgeInsets.only(top: 16.0),
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.red,
          //       onPressed: () {
          //         isVideo = true;
          //         _onImageButtonPressed(ImageSource.camera, context: context);
          //       },
          //       heroTag: 'video1',
          //       tooltip: 'Take a Video',
          //       child: const Icon(Icons.videocam),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
