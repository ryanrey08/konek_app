import 'dart:async';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';
// import 'package:konek_app/Config/Config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  const MyProfile({super.key});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int _currentStep = 0;

  bool editStatus = false;

  Uint8List? signature;

  var _selectedCivilStatus;
  final _civilStatus = ["single", "married", "widowed", "divorced"];

  var _selectedSex;
  final _sex = ["male", "female"];

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  var isLoadingSend = false;

  bool isLoading = true;

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

  var _jsonResult;

  List<dynamic> _region = [];
  List<dynamic> _province = [];
  List<dynamic> _municipality = [];
  List<dynamic> _barangay = [];

  List<dynamic> _regionsId = [];
  List<dynamic> _tempMunicipalityKeys = [];
  List<dynamic> _tempMunicipality = [];
  var _tempRegion = {};

  String? _regionId;
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedMunicipality;
  String? _selectedBarangay;

  getPH() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/address.json");
    _jsonResult = json.decode(data);
    getRegion();
    getProvince();
    getMunicipality();
    getBarangay();
  }

  getRegion() {
    var region = [];
    final regions = _jsonResult.values.toList();
    _regionsId = _jsonResult.keys.toList();
    for (var x = 0; x < regions.length; x++) {
      region.add(regions[x]['region_name']);
    }

    setState(() {
      _region = region;
      _selectedRegion = _region[0];
      _regionId = _regionsId[0];
      //print(_region);
      // if (_userData['region'] == null) {
      //   _selectedRegion = _region[0];
      //   _regionId = _regionsId[0];
      // }
    });
  }

  getRegionId() {
    int index = 0;
    for (var x = 0; x < _region.length; x++) {
      if (_selectedRegion == _region[x]) {
        index = x;
      }
    }

    setState(() {
      _regionId = _regionsId[index];
    });
  }

  getProvince() {
    var tempProvince;
    var provinces = [];
    var region = [];
    var tempRegion = {};
    region = _jsonResult.values.toList();
    for (var x = 0; x < region.length; x++) {
      if (region[x]['region_name'] == _selectedRegion) {
        tempRegion = region[x];
        tempProvince = region[x]['province_list'].keys.toList();
        for (var y = 0; y < tempProvince.length; y++) {
          provinces.add(tempProvince[y]);
        }
      }
    }

    setState(() {
      _tempRegion = tempRegion;
      _province = provinces;
      print(_province);
      _selectedProvince = _province[0];
    });
  }

  // getProvince() {
  //   var tempProvince;
  //   var provinces = [];
  //   var region = [];
  //   var tempRegion = {};
  //   region = _jsonResult.values.toList();
  //   for (var x = 0; x < region.length; x++) {
  //     tempProvince = region[x]['province_list'].keys.toList();
  //     for (var y = 0; y < tempProvince.length; y++) {
  //       provinces.add(tempProvince[y]);
  //     }
  //   }

  //   provinces.sort((a, b) {
  //     return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
  //   });

  //   print(provinces);

  //   setState(() {
  //     _tempRegion = tempRegion;
  //     _province = provinces;

  //     _selectedProvince = _province[0];
  //   });
  // }

  changeRegion() {
    getProvince();
    getMunicipality();
    getBarangay();
  }

  changeProvince() {
    getMunicipality();
    getBarangay();
  }

  getMunicipality() {
    var tempProvinceKeys;
    var tempProvince;
    var tempMunicipalitiesKeys;
    var tempMunicipalities;
    var municipalities = [];
    tempProvinceKeys = _tempRegion['province_list'].keys.toList();
    tempProvince = _tempRegion['province_list'].values.toList();

    for (var y = 0; y < tempProvinceKeys.length; y++) {
      if (tempProvinceKeys[y] == _selectedProvince) {
        tempMunicipalitiesKeys =
            tempProvince[y]['municipality_list'].keys.toList();
        tempMunicipalities =
            tempProvince[y]['municipality_list'].values.toList();

        for (var z = 0; z < tempMunicipalitiesKeys.length; z++) {
          municipalities.add(tempMunicipalitiesKeys[z]);
        }
        setState(() {
          _municipality = municipalities;

          _selectedMunicipality = municipalities[0];

          _tempMunicipalityKeys = tempMunicipalitiesKeys;
          _tempMunicipality = tempMunicipalities;
        });
      }
    }
  }

  getBarangay() {
    for (var a = 0; a < _tempMunicipalityKeys.length; a++) {
      if (_tempMunicipalityKeys[a] == _selectedMunicipality) {
        setState(() {
          _barangay = _tempMunicipality[a]['barangay_list'];
          _selectedBarangay = _barangay[0];
          isLoading = false;
        });
      }
    }
  }

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
  final txtOldPassword = TextEditingController();
  final txtNewPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  final txtEmailAddress = TextEditingController();

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

  final bool _isInit = false;
  var businessApplication;

  final bool _isKeptOn = false;
  final double _brightness = 1.0;
  static final int _currentPage = 0;
  final int _currentIndex = 0;

  final PageController _controller = PageController(
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
      return "${txtFirstName.text.replaceAll(' ', '') + "_" + txtLastName.text.replaceAll(' ', '') + "_" + ext}.pdf";
    } else {
      return "${txtFirstName.text.replaceAll(' ', '') + "_" + txtLastName.text.replaceAll(' ', '') + "_" + ext}.png";
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
          animType: AnimType.scale,
          dialogType: DialogType.success,
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("here");
    //getProfile();
    getPH();
  }

  getProfile() async {
    SharedPreferences sharedPreferences;

    sharedPreferences = await SharedPreferences.getInstance();

    // final extractedUserData =
    //     json.decode(sharedPreferences.getString('userData')!)
    //         as Map<String, dynamic>;
    // final data = extractedUserData['data']['user'] as Map<String, dynamic>;

    final extractedUserData =
        json.decode(sharedPreferences.getString('userData')!) as Map;
    if (extractedUserData['data']['user'] != null) {
      setState(() {
        txtFirstName.text =
            extractedUserData['data']['user']['first_name'] == null
                ? ''
                : extractedUserData['data']['user']['first_name'];
        txtMiddleName.text =
            extractedUserData['data']['user']['middle_name'] == null
                ? ''
                : extractedUserData['data']['user']['middle_name'];
        txtLastName.text =
            extractedUserData['data']['user']['last_name'] == null
                ? ''
                : extractedUserData['data']['user']['last_name'];
        txtEmailAddress.text =
            extractedUserData['data']['user']['email'] == null
                ? ''
                : extractedUserData['data']['user']['email'];
        txtPhoneNumber.text =
            extractedUserData['data']['user']['mobile_no'] == null
                ? ''
                : extractedUserData['data']['user']['mobile_no'];
      });
    } else {
      setState(() {
        txtFirstName.text =
            extractedUserData['data']['first_name'] == null
                ? ''
                : extractedUserData['data']['first_name'];
        txtMiddleName.text =
            extractedUserData['data']['middle_name'] == null
                ? ''
                : extractedUserData['data']['middle_name'];
        txtLastName.text =
            extractedUserData['data']['last_name'] == null
                ? ''
                : extractedUserData['data']['last_name'];
        txtEmailAddress.text =
            extractedUserData['data']['email'] == null
                ? ''
                : extractedUserData['data']['email'];
        txtPhoneNumber.text =
            extractedUserData['data']['mobile_no'] == null
                ? ''
                : extractedUserData['data']['mobile_no'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //getUser();
    editStatus = false;
    getProfile();
    // txtFirstName.text = 'John';
    // txtMiddleName.text = 'Black';
    // txtLastName.text = 'Doe';
    // txtEmailAddress.text = 'johndoe@me.com';
    // txtPhoneNumber.text = '09123456789';
  }

  @override
  void dispose() {
    super.dispose();
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
                  color: const Color.fromARGB(255, 55, 57, 175),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                  labelText: 'Voucher Code',
                  //prefixIcon: Icon(Icons.code),
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
              color: const Color.fromARGB(255, 55, 57, 175),
              pressEvent: () {
                dialog.dismiss();
              },
            )
          ],
        ),
      ),
    );

    dialog.show();
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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 55, 57, 175),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.keyboard_arrow_left,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Dashboard.routeName);
                  } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
            }),
            automaticallyImplyLeading: false,
            title: Text('My Profile',
                style: GoogleFonts.poppins(
                    fontSize: useMobileLayout ? 16 : 18, color: Colors.white)),
          ),
          body: isLoading
              ? Container(child: const Text("Loading..."))
              : Form(
                  key: _formKey1,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
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
                                  FocusScope.of(context)
                                      .requestFocus(mNameFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Middlename (optional)',
                                controller: txtMiddleName,
                                validator: (value) {
                                  return null;
                                },
                                initialValue: '',
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(lNameFocus);
                                },
                              ),
                              const SizedBox(height: 4),
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
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Email Address',
                                controller: txtEmailAddress,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(phoneFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your TIN No.';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
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
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Address',
                                controller: txtCompleteAddress,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(phoneFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your complete address';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              // CustomFormField(
                              //   status: editStatus,
                              //   label: 'City',
                              //   controller: txtEducational,
                              //   onFieldSubmitted: (_) {
                              //     FocusScope.of(context)
                              //         .requestFocus(degreeFocus);
                              //   },
                              //   validator: (value) {
                              //     if (value.isEmpty) {
                              //       return 'Please enter your education attainment.';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: '',
                              // ),
                              // SizedBox(height: 4),
                              // CustomFormField(
                              //   status: editStatus,
                              //   label: 'Province',
                              //   controller: txtDegree,
                              //   onFieldSubmitted: (_) {
                              //     // FocusScope.of(context)
                              //     //     .requestFocus(
                              //     //         entityFocus);
                              //   },
                              //   validator: (value) {
                              //     if (value.isEmpty) {
                              //       return 'Please enter your degree/course.';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: '',
                              // ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedRegion,
                                items: _region,
                                title: "Region",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRegion = value.toString();
                                    _regionId =
                                        _regionsId[_region.indexOf(value)];
                                    changeRegion();
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your region';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedProvince,
                                items: _province,
                                title: "Province",
                                onChanged: (value) {
                                  setState(() {
                                    print(_selectedProvince);
                                    _selectedProvince = value.toString();
                                    changeProvince();
                                    print(value);
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your province';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedMunicipality,
                                items: _municipality,
                                title: "Municipality",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMunicipality = value.toString();
                                    getBarangay();
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your city';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedBarangay,
                                items: _barangay,
                                title: "Barangay",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBarangay = value.toString();
                                    //_brgyId = (_barangay.indexOf(value) + 1).toString();
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your barangay';
                                  }
                                  return null;
                                },
                              ),

                              Container(
                                // height:  150,
                                //width: double.infinity,
                                width: useMobileLayout ? 600 : 700,

                                //height: useMobileLayout ? 90 : 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 15),
                                child: Container(
                                  child: SizedBox(
                                    width: useMobileLayout ? 130 : 180,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 55, 57, 175), // foreground
                                      ),
                                      onPressed: () {
                                        enterVoucherCode();
                                      },
                                      child: Text(
                                        //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                                        "VOUCHER CODE",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: useMobileLayout ? 14 : 25,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      // color: Colors.white,
                                      // textColor: Colors.black,
                                      // splashColor: Colors.yellowAccent[800],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 5,
                ),
                editStatus == false
                    ? Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              editStatus = true;
                            });
                            // _formKey1.currentState.validate();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Color.fromARGB(255, 55, 57, 175), // foreground
                            //                color: Colors.yellow,
                            // textColor: Colors.black,
                            // splashColor: Colors.yellowAccent[800],
                          ),
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
                          // color: Colors.green,
                          // textColor: Colors.black,
                          // splashColor: Colors.yellowAccent[800],
                        ),
                      )
                    : Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // _formKey1.currentState.validate();
                            proceed();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Color.fromARGB(255, 55, 57, 175), // foreground
                            //                color: Colors.yellow,
                            // textColor: Colors.black,
                            // splashColor: Colors.yellowAccent[800],
                          ),
                          child: Text(
                            "UPDATE",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
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
            animType: AnimType.scale,
            dialogType: DialogType.warning,
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
      animType: AnimType.scale,
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

  Container dropDown(
      String? value,
      List<dynamic> items,
      String title,
      String? Function(Object?) onChanged,
      String? Function(Object?) validator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map((text) => DropdownMenuItem(
                  value: text,
                  child: Text('$text'),
                ))
            .toList(),
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // OutlineInputBorder
          // UnderlineInputBorder
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1,
            ),
          ),
          errorStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.redAccent[700],
            ),
          ),
          labelText: value != null ? title : null,
          labelStyle: value != null
              ? GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : null,
          hintText: value == null ? title : null,
          hintStyle: value == null
              ? GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
