class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String address;
  final String phone;
  final String accountType;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.accountType,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'phone': phone,
        'accountType': accountType,
      };
}
