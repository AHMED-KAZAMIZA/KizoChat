 class UserModel {
    String? id;
    String? username;
    String? email;
    String? password;
    String? number;
    String? status;
    String? image;

  UserModel({
  this.id,
  this.username,
  this.email,
  this.password,
  this.number,
  this.status,
  this.image
});



UserModel.fromJson(Map<String, dynamic> document) {
  id = document['id'];
  username = document['username'];
  email = document['email'];
  password = document['password'];
  number = document['number'];
  status = document['status'];
  image = document['image'];
}

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'number': number,
    'status': status,
    'image': image,
  };
}
}