class UserModel {
  final String idNumber;

  UserModel(this.idNumber);

  bool isValidId() {
    return idNumber.isNotEmpty && idNumber.length >= 10;
  }
}
