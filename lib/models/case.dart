class Case {
  final String name;
  final String description;
  final String state;
  final String tel;
  final String image;

  Case({this.name, this.description, this.state, this.tel, this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'state': state,
      'tel': tel,
      'image': image,

    };
  }}