class User {
  String image;
  String name;
  String email;
  String phone;
  String department;
  String designation;
  String otherrole;

  // Constructor
  User({
     this.image,
     this.name,
     this.email,
     this.phone,
     this.department,
     this.designation,
     this.otherrole,
  });

  User copy({
    String imagePath,
    String name,
    String phone,
    String email,
    String department,
    String designation,
    String otherrole,
  }) =>
      User(
        image: imagePath ?? image,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        department: department ?? this.department,
        designation: designation ?? this.designation,
        otherrole: otherrole ?? this.otherrole,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        image: json['imagePath'],
        name: json['name'],
        email: json['email'],
        department: json['department'],
        phone: json['phone'],
        designation: json['designation'],
        otherrole: json['otherrole'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': image,
        'name': name,
        'email': email,
        'department': department,
        'phone': phone,
        'designation': designation,
        'otherrole': otherrole,
      };
}
