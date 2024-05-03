// Packages and Libraries

/* <======= END =======>*/

class User {
  final String rsbsa_no;
  final String first_name;
  final String last_name;
  final String middleName;
  final String contact_number;
  final String status;
  final String email;
  final String password;
  final String confirm_password;
  final String birthdate;

  User({
    required this.rsbsa_no,
    required this.first_name,
    required this.middleName,
    required this.last_name,
    required this.birthdate,
    required this.contact_number,
    required this.status,
    required this.email,
    required this.password,
    required this.confirm_password,
    // @required this.gender,
  });
}