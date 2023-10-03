import 'dart:async';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';
// import 'package:konek_app/Config/Config.dart';
import '../providers/profileprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../content/dashboard.dart';
import '../../content/home.dart';
import '../../features/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/myprofile';
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int _currentStep = 0;

  bool editStatus = false;

  Uint8List? signature;

  var _selectedCivilStatus;
  var _civilStatus = ["single", "married", "widowed", "divorced"];

  var _selectedSex;
  var _sex = ["male", "female"];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  var isLoadingSend = false;

  bool isLoading = false;

  bool isPhoto = false;
  bool isESignature = false;
  bool isGovID = false;

  bool isCheckPhoto = false;
  bool isCheckPhotoGov = false;
  bool isCheckSignature = false;
  bool isCheckGov = false;

  bool isImageLoad = false;

  // PickedFile? _imageFileProfilePhoto;
  // PickedFile? _imageFileESignature;
  // PickedFile? _imageFileGovID;
  // AssetImage? retrieveImageProfile;

  bool hasPhoto = false;
  bool hasSignature = false;
  bool hasGovID = false;
  String? _retrieveDataError;

  var user;
  var farmer;
  var token;
  var profiling;

  String? _imageFileCamera;
  String? _imageFileSignature;
  String? _imageFileGovIDPath;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extracteduserData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;
    setState(() {
      farmer = extracteduserData['data'];
      token = extracteduserData['token'];
      if (extracteduserData['token'] == null) {
        token = farmer['token'];
      } else {
        token = extracteduserData['token'];
      }

      if (extracteduserData['data'] == null) {
        farmer = extracteduserData;
      } else {
        farmer = extracteduserData['data'];
      }

      // txtRSBSANumber.text = farmer['rsbsa_no'];
      // txtFirstName.text = farmer['first_name'];
      // txtMiddleName.text = farmer['middle_name'];
      // txtLastName.text = farmer['last_name'];
      // txtPhoneNumber.text = farmer['contact_number'];
      // txtBirthDate.text = farmer['birthdate'];
      // txtPlaceOfBirth.text = farmer['place_of_birth'];
      // _selectedSex = farmer['gender'];
      // _selectedCivilStatus = farmer['civil_status'];
      // txtTINnumber.text = farmer['tin_no'];
      // txtEducational.text = farmer['educational_attainment'];
      // txtDegree.text = farmer['degree_course'];
      // txtCompleteAddress.text = farmer['address'];

      // txtFamLastName.text = farmer['farmer_family_member_last_name'];
      // txtFamFirstName.text = farmer['farmer_family_member_first_name'];
      // txtFamMiddleName.text = farmer['farmer_family_member_middle_name'];
      // txtFamBirthDate.text = farmer['farmer_family_member_date_of_birth'];
      // txtFamPhoneNumber.text = farmer['farmer_family_member_contact_number'];
      // txtFamOccupation.text = farmer['farmer_family_member_occupation'];
      // txtFamEducational.text =
      //     farmer['farmer_family_member_educational_attainment'];
      // txtBankName.text = farmer['farmer_bank_information_bank_name'];
      // txtAccountName.text = farmer['farmer_bank_information_account_name'];
      // txtAccountNumber.text = farmer['farmer_bank_information_account_number'];


      // txtAccountName.text = farmer['first_name'] + ' ' + farmer['last_name'];
      isLoading = true;
    });
    // isLoading = false;

    // print(token);
    print(extracteduserData);
    print('here');
  }

//Personal Information
  final txtRSBSANumber = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtMiddleName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtCompleteAddress = TextEditingController();
  final txtPhoneNumber = TextEditingController();
  final txtSex = TextEditingController();
  final txtBirthDate = TextEditingController();
  final txtCivilStatus = TextEditingController();
  final txtPlaceOfBirth = TextEditingController();
  final txtTINnumber = TextEditingController();
  final txtEducational = TextEditingController();
  final txtDegree = TextEditingController();

  final fNameFocus = FocusNode();
  final mNameFocus = FocusNode();
  final lNameFocus = FocusNode();
  final addressFocus = FocusNode();
  final phoneFocus = FocusNode();
  final birthFocu = FocusNode();
  final civilFocus = FocusNode();
  final placeBirthFocus = FocusNode();
  final tinFocus = FocusNode();
  final educationalFocus = FocusNode();
  final degreeFocus = FocusNode();

  bool _isInit = false;
  var businessApplication;

  bool _isKeptOn = false;
  double _brightness = 1.0;
  static int _currentPage = 0;
  int _currentIndex = 0;

  PageController _controller = PageController(
    initialPage: _currentPage,
  );

  // @override
  //  void didChangeDependencies() {
  //   print("update");
  //   if (!_isInit) {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //       final extractedUserData =
  //   //     json.decode(prefs.getString('userData')) as Map<String, Object>;
  //     profiling = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
  //     print(profiling);
  //     if (profiling != null) {
  //       assignDataBasicInfo(profiling['farmer']);
  //     }

  //     setState(() {
  //       _isInit = true;
  //     });
  //     //print(businessApplication['info']['basic_info']);

  //     print(businessApplication);
  //   }
  //   super.didChangeDependencies();
  // }

  //   void assignDataBasicInfo(Map<String, dynamic> basinInfo) {
  //   if (basinInfo['first_name'] != null) {
  //     txtFirstName.text = basinInfo['first_name'];
  //   }
  //   if (basinInfo['middle_name'] != null) {
  //     txtMiddleName.text = basinInfo['middle_name'];
  //   }

  // }

  String getImageName(filePath, ext) {
    var fileName = (filePath.path).split('/').last;
    if (fileName.contains('pdf')) {
      return txtFirstName.text.replaceAll(' ', '') +
          "_" +
          txtLastName.text.replaceAll(' ', '') +
          "_" +
          ext +
          ".pdf";
    } else {
      return txtFirstName.text.replaceAll(' ', '') +
          "_" +
          txtLastName.text.replaceAll(' ', '') +
          "_" +
          ext +
          ".png";
    }
  }

  void updateProfile() {
    // var userInfo = {
    //     'id' : user['user']['id'].toString(),
    //     'email':user['user']['email'].toString(),
    //     'contact_number' : user['user']['contact_number'].toString(),
    //     'system_access' : user['user']['system_access'].toString(),
    //     'status' : user['status'].toString(),
    //   // 'spouse_last_name': txtFamLastName.text,
    //   // 'spouse_first_name': txtFamFirstName.text,
    //   // 'spouse_middle_name': txtFamMiddleName.text,
    //   // 'spouse_date_of_birth': txtFamBirthDate.text,
    //   // 'spouse_contact_number': txtFamPhoneNumber.text,
    //   // 'spouse_occupation': txtFamOccupation.text,
    //   // 'spouse_educational_attainment': txtFamEducational.text,
    //   // 'bank_name': txtBankName.text,
    //   // 'account_name': txtAccountName.text,
    //   // 'account_number': txtAccountNumber.text
    // };

    var img1;
    var img2;
    var img3;
    var img1Name;
    var img2Name;
    var img3Name;

    var encodedProfile;
    var encodedSignature;
    var encodedGov;


    var farmerInfo = {
      'token': token,
      'farmer_id': farmer['farmer_id'].toString(),
      'user_id': farmer['user_id'].toString(),
      'rsbsa_no': farmer['rsbsa_no'].toString(),
      'landparcelInfo': farmer['landparcelInfo'].toString(),
      'address': txtCompleteAddress.text,
      'last_name': txtLastName.text,
      'first_name': txtFirstName.text,
      'middle_name': txtMiddleName.text,
      'suffix': '',
      'birthdate': txtBirthDate.text,
      'tin_no': txtTINnumber.text,
      'profile_picture': encodedProfile,
      'government_id': encodedGov,
      'e_signiture': encodedSignature,
      'contact_number': txtPhoneNumber.text,
      'place_of_birth': txtPlaceOfBirth.text,
      'gender': _selectedSex.toString(),
      'civil_status': _selectedCivilStatus.toString(),
      'educational_attainment': txtEducational.text,
      'degree_course': txtDegree.text,
    };
    updateFarmerProfile(token, farmerInfo);
  }

  void updateFarmerProfile(
      String token, Map<String, dynamic> farmerInfo) async {
    try {
      bool isSaved = await Provider.of<ProfileProvider>(context, listen: false)
          .updateProfiling(token, farmerInfo);
      print('error here');
      if (isSaved) {
        setState(() {
          isLoadingSend = false;
        });
        AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          onDismissCallback: (BuildContext) {
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          title: "Update farmer profile",
          desc: "Successfully Updated",
          btnOkOnPress: () {
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
        ).show();

        // setState(() {
        //   _currentStep += 1;
        // });
      }
    } catch (error) {
      print(error);
    }
  }


  @override
  void initState() {
    super.initState();
    //getUser();
    editStatus = false;
  }

  @override
  void dispose() {
    super.dispose();
  }



  // File? _imageGov;
  // final imagePickerGov = ImagePicker();
  // Future getImageGov() async {
  //   final imageGov = await imagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
  //   setState(() {
  //     _imageGov = File(imageGov!.path);
  //     isCheckPhotoGov = true;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 57, 175),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Dashboard.routeName);
                } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
          }),
          automaticallyImplyLeading: false,
          title: Text('My Profile',
              style: GoogleFonts.poppins(
                fontSize: useMobileLayout ? 16 : 18,
              )),
        ),
        body: Form(
          key: _formKey1,
          child: Column(
            children: <Widget>[
      
                 Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            // CustomFormField(
                            //   // initialValue: user['farmer']['rsbsa_no'],
                            //   status: editStatus,
                            //   label: 'RSBSA Number',
                            //   controller: txtRSBSANumber,
                            //   onFieldSubmitted: (_) {
                            //     FocusScope.of(context).requestFocus(fNameFocus);
                            //   },
                            //   validator: (value) {
                            //     if (value.isEmpty) {
                            //       return 'Please enter your first name';
                            //     }
                            //     return null;
                            //   },
                            //   initialValue: '',
                            // ),
                            CustomFormField(
                              status: editStatus,
                              label: 'First Name',
                              controller: txtFirstName,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(mNameFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              initialValue: '',
                            ),
                            CustomFormField(
                              status: editStatus,
                              label: 'Middlename (optional)',
                              controller: txtMiddleName,
                              validator: (value) {
                                return null;
                              },
                              initialValue: '',
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(lNameFocus);
                              },
                            ),
                            CustomFormField(
                              status: editStatus,
                              label: 'Lastname',
                              controller: txtLastName,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(addressFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your lasst name';
                                }
                                return null;
                              },
                              initialValue: '',
                            ),
                            CustomFormField(
                              status: editStatus,
                              label: 'Complete Address',
                              controller: txtCompleteAddress,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(phoneFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your complete address';
                                }
                                return null;
                              },
                              initialValue: '',
                            ),

                            SizedBox(height: 4),
                            CustomFormField(
                              status: editStatus,
                              label: 'TIN Number',
                              controller: txtTINnumber,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(phoneFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your TIN No.';
                                }
                                return null;
                              },
                              initialValue: '',
                            ),
                            CustomFormField(
                              status: editStatus,
                              label: 'Mobile Number',
                              controller: txtPhoneNumber,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(educationalFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your mobile number';
                                }
                                return null;
                              },
                              initialValue: '',
                            ),
                            CustomFormField(
                              status: editStatus,
                              label: 'Educational Attainment',
                              controller: txtEducational,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(degreeFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your education attainment.';
                                }
                                return null;
                              }, initialValue: '',
                            ),
                            CustomFormField(
                              status: editStatus,
                              label: 'Degree/Course',
                              controller: txtDegree,
                              onFieldSubmitted: (_) {
                                // FocusScope.of(context)
                                //     .requestFocus(
                                //         entityFocus);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your degree/course.';
                                }
                                return null;
                              }, initialValue: '',
                            ),
                          ],
                        ),
                      )),
                    )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 50,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Text(
                    "CHANGE PASSWORD",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onPressed: () {
                    _formKey1.currentState!.validate();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                    //                color: Colors.yellow,
                    // textColor: Colors.black,
                    // splashColor: Colors.yellowAccent[800],
                  ),
                  // color: Colors.green,
                  // textColor: Colors.black,
                  // splashColor: Colors.yellowAccent[800],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              editStatus == false
                  ? Expanded(
                      child: ElevatedButton(
                        child: Text(
                          "EDIT PROFILE",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            editStatus = true;
                          });
                          // _formKey1.currentState.validate();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                          //                color: Colors.yellow,
                          // textColor: Colors.black,
                          // splashColor: Colors.yellowAccent[800],
                        ),
                        // color: Colors.green,
                        // textColor: Colors.black,
                        // splashColor: Colors.yellowAccent[800],
                      ),
                    )
                  : Expanded(
                      child: ElevatedButton(
                        child: Text(
                          "UPDATE",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onPressed: () {
                          // _formKey1.currentState.validate();
                          proceed();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                          //                color: Colors.yellow,
                          // textColor: Colors.black,
                          // splashColor: Colors.yellowAccent[800],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  proceed() {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            onDismissCallback: (_) {
              //Navigator.of(context).pop();
            },
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.WARNING,
            title: "Warning",
            desc: "Update Profile?",
            btnOkOnPress: () {
              isLoadingSend = true;
              updateProfile();
            },
            btnCancelOnPress: () {
              // Navigator.of(context).pop();
            })
        .show();
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  void awesomeDialog(DialogType dialogType, String title, String message) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      onDismissCallback: (_) {
        Navigator.of(context).pop();
      },
      context: context,
      animType: AnimType.SCALE,
      dialogType: dialogType,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null!;
  }
}
