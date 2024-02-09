class Manager_Modal {
  final String name;
  final String email;
  final String pass;

  Manager_Modal(
  {
    required this.name,
    required this.email,
    required this.pass
}
      );

  toJson(){
    return {
      'Name':name,
      'Email':email,
      'Password':pass
    };

  }
}