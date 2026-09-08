class Validators {
  static bool isValidEmail(String email) { // calls this method directly on the class itself eg Validators.isValidEmail(...)
  
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');  //regular expressions
    return emailRegex.hasMatch(email); //checks whether the string matches the pattern 
  }

  static bool isStrongPassword(String password) {
    return password.length >= 8;
  }
}