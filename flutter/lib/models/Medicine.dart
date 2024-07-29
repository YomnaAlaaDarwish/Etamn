class Medicine {
  int nationalId;
  String name;
  String img;
  String dose;
  int numOfTimes;

  Medicine({
    required this.nationalId,
    required this.name,
    required this.img,
    required this.dose,
    required this.numOfTimes,
  });

  Map<String, dynamic> toMap() {
    return {
      'nationalId': nationalId,
      'name': name,
      'img': img,
      'dose': dose,
      'numOfTimes': numOfTimes,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      nationalId: map['nationalId'],
      name: map['name'],
      img: map['img'],
      dose: map['dose'],
      numOfTimes: map['numOfTimes'],
    );
  }
}