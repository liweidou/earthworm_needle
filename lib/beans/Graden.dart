class Garden {
  int _count;
  int _next;
  int _previous;
  List<Results> _results;

  Garden({int count, int next, int previous, List<Results> results}) {
    this._count = count;
    this._next = next;
    this._previous = previous;
    this._results = results;
  }

  int get count => _count;

  set count(int count) => _count = count;

  int get next => _next;

  set next(int next) => _next = next;

  int get previous => _previous;

  set previous(int previous) => _previous = previous;

  List<Results> get results => _results;

  set results(List<Results> results) => _results = results;

  Garden.fromJson(Map<String, dynamic> json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    if (json['results'] != null) {
      _results = new List<Results>();
      json['results'].forEach((v) {
        _results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this._count;
    data['next'] = this._next;
    data['previous'] = this._previous;
    if (this._results != null) {
      data['results'] = this._results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int _id;
  String _name;
  Imagex _image;
  String _address;
  Subuser _subuser;
  Temperature _temperature;
  Fertility _fertility;
  Fertility _power;
  Fertility _moisture;

  Results(
      {int id,
      String name,
      Imagex image,
      String address,
      Subuser subuser,
      Temperature temperature,
      Fertility fertility,
      Fertility power,
      Fertility moisture}) {
    this._id = id;
    this._name = name;
    this._image = image;
    this._address = address;
    this._subuser = subuser;
    this._temperature = temperature;
    this._fertility = fertility;
    this._power = power;
    this._moisture = moisture;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get name => _name;

  set name(String name) => _name = name;

  Imagex get image => _image;

  set image(Imagex image) => _image = image;

  String get address => _address;

  set address(String address) => _address = address;

  Subuser get subuser => _subuser;

  set subuser(Subuser subuser) => _subuser = subuser;

  Temperature get temperature => _temperature;

  set temperature(Temperature temperature) => _temperature = temperature;

  Fertility get fertility => _fertility;

  set fertility(Fertility fertility) => _fertility = fertility;

  Fertility get power => _power;

  set power(Fertility power) => _power = power;

  Fertility get moisture => _moisture;

  set moisture(Fertility moisture) => _moisture = moisture;

  Results.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'] != null ? new Imagex.fromJson(json['image']) : null;
    _address = json['address'];
    _subuser =
        json['subuser'] != null ? new Subuser.fromJson(json['subuser']) : null;
    _temperature = json['temperature'] != null
        ? new Temperature.fromJson(json['temperature'])
        : null;
    _fertility = json['fertility'] != null
        ? new Fertility.fromJson(json['fertility'])
        : null;
    _power =
        json['power'] != null ? new Fertility.fromJson(json['power']) : null;
    _moisture = json['moisture'] != null
        ? new Fertility.fromJson(json['moisture'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    if (this._image != null) {
      data['image'] = this._image.toJson();
    }
    data['address'] = this._address;
    if (this._subuser != null) {
      data['subuser'] = this._subuser.toJson();
    }
    if (this._temperature != null) {
      data['temperature'] = this._temperature.toJson();
    }
    if (this._fertility != null) {
      data['fertility'] = this._fertility.toJson();
    }
    if (this._power != null) {
      data['power'] = this._power.toJson();
    }
    if (this._moisture != null) {
      data['moisture'] = this._moisture.toJson();
    }
    return data;
  }
}

class Imagex {
  int _id;
  String _image;

  Imagex({int id, String image}) {
    this._id = id;
    this._image = image;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get image => _image;

  set image(String image) => _image = image;

  Imagex.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['image'] = this._image;
    return data;
  }
}

class Subuser {
  int _id;
  String _name;
  String _mobile;

  Subuser({int id, String name, String mobile}) {
    this._id = id;
    this._name = name;
    this._mobile = mobile;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get name => _name;

  set name(String name) => _name = name;

  String get mobile => _mobile;

  set mobile(String mobile) => _mobile = mobile;

  Subuser.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['mobile'] = this._mobile;
    return data;
  }
}

class Temperature {
  dynamic _avg;

  Temperature({dynamic avg}) {
    this._avg = avg;
  }

  dynamic get avg => _avg;

  set avg(dynamic avg) => _avg = avg;

  Temperature.fromJson(Map<String, dynamic> json) {
    _avg = json['avg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg'] = this._avg;
    return data;
  }
}

class Fertility {
  dynamic _avg;
  String _color;
  int _count;

  Fertility({dynamic avg, String color, int count}) {
    this._avg = avg;
    this._color = color;
    this._count = count;
  }

  dynamic get avg => _avg;

  set avg(dynamic avg) => _avg = avg;

  String get color => _color;

  set color(String color) => _color = color;

  int get count => _count;

  set count(int count) => _count = count;

  Fertility.fromJson(Map<String, dynamic> json) {
    _avg = json['avg'];
    _color = json['color'];
    _count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg'] = this._avg;
    data['color'] = this._color;
    data['count'] = this._count;
    return data;
  }
}
