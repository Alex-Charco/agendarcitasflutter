class UserModel {
  final String idNumber;

  UserModel(this.idNumber);

  bool isValidId() {
    if (idNumber.isEmpty) return false;
    if (idNumber.length < 10) return false;
    if (!RegExp(r'^\d+$').hasMatch(idNumber)) return false; // Verifica que solo contenga números
    return true;
  }
}
