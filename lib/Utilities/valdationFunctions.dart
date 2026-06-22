String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  String pattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  RegExp regex = nameRegex;
  if (!regex.hasMatch(value)) {
  return 'Enter a valid name';
  }
  return null;
}

String? validateFullName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Full name is required';
  }
  String pattern = r"^[a-zA-Z]+([',. -][a-zA-Z ]+)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid full name';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter a valid phone number';
  }
  return null;
}


RegExp emailExpression = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]{2}");
RegExp regex1 = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#\$&*~]).{8,}$');

RegExp Dobregex=RegExp(r'^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$');
// RegExp dateRegExp = RegExp(r'^(0[1-9]|1[0-9]|2[0-9]|3[01])-/.-/.$');
RegExp dateRegExp = RegExp(r'^(19|20)\d{2}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$');


RegExp passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');


RegExp regex = RegExp(r'^\w*$');
RegExp aadhaarRegex = RegExp(r'^[0-9]{4}\s[0-9]{4}\s[0-9]{4}$');
//( )|
RegExp nameRegex = RegExp(r'^[A-Za-z ]*$');
RegExp addressReg = RegExp(r'^[A-Za-z \d]*$');
RegExp pinCodeReg = RegExp(r'^\d{6}');

RegExp mobileRegex = RegExp(r'^\d*$');
RegExp regMobile = RegExp(r'^[6-9]{1}\d{9}');

RegExp aadhaarRegex1 = RegExp(r'^\d{12}');

RegExp regAccount = RegExp(r'\d{9,18}');
RegExp regVehicle = RegExp(r'^[A-Z]{2}\s[0-9]{2}\s[A-Z]{2}\s[0-9]{4}$');
RegExp regDL = RegExp(r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$');
RegExp regIFSC = RegExp(r"^[A-Z]{4}0[A-Z\d]{6}");


RegExp regPan = RegExp(r'[A-Z]{5}\d{4}[A-Z]{1}');

RegExp regUPI = RegExp('/[a-zA-Z0-9_]{3,}@[a-zA-Z]{3,}/');


RegExp regPincode=RegExp('[1-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}');

