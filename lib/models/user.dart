class User {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String postalCode;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: '${json['firstName']} ${json['lastName']}', // Combine first and last name
      email: json['email'],
      avatar: json['image'], // Assure that the avatar URL matches the API response
      phone: json['phone'], // Added phone number
      address: json['address']['address'], // Full street address
      city: json['address']['city'], // City from address object
      state: json['address']['state'], // State from address object
      postalCode: json['address']['postalCode'], // Postal code from address object
    );
  }
}
