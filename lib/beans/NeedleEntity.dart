class NeedleEntity {
	dynamic next;
	dynamic previous;
	int count;
	List<NeedleResult> results;

	NeedleEntity({this.next, this.previous, this.count, this.results});

	NeedleEntity.fromJson(Map<String, dynamic> json) {
		next = json['next'];
		previous = json['previous'];
		count = json['count'];
		if (json['results'] != null) {
			results = new List<NeedleResult>();(json['results'] as List).forEach((v) { results.add(new NeedleResult.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['next'] = this.next;
		data['previous'] = this.previous;
		data['count'] = this.count;
		if (this.results != null) {
      data['results'] =  this.results.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class NeedleResult {
	NeedleResultsFertility fertility;
	bool sandy;
	String name;
	NeedleResultsTemperature temperature;
	int location;
	int id;
	NeedleResultsPower power;
	NeedleResultsMoisture moisture;
	String serialno;

	NeedleResult({this.fertility, this.sandy, this.name, this.temperature, this.location, this.id, this.power, this.moisture, this.serialno});

	NeedleResult.fromJson(Map<String, dynamic> json) {
		fertility = json['fertility'] != null ? new NeedleResultsFertility.fromJson(json['fertility']) : null;
		sandy = json['sandy'];
		name = json['name'];
		temperature = json['temperature'] != null ? new NeedleResultsTemperature.fromJson(json['temperature']) : null;
		location = json['location'];
		id = json['id'];
		power = json['power'] != null ? new NeedleResultsPower.fromJson(json['power']) : null;
		moisture = json['moisture'] != null ? new NeedleResultsMoisture.fromJson(json['moisture']) : null;
		serialno = json['serialno'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.fertility != null) {
      data['fertility'] = this.fertility.toJson();
    }
		data['sandy'] = this.sandy;
		data['name'] = this.name;
		if (this.temperature != null) {
      data['temperature'] = this.temperature.toJson();
    }
		data['location'] = this.location;
		data['id'] = this.id;
		if (this.power != null) {
      data['power'] = this.power.toJson();
    }
		if (this.moisture != null) {
      data['moisture'] = this.moisture.toJson();
    }
		data['serialno'] = this.serialno;
		return data;
	}
}

class NeedleResultsFertility {
	double avg;
	String color;

	NeedleResultsFertility({this.avg, this.color});

	NeedleResultsFertility.fromJson(Map<String, dynamic> json) {
		avg = json['avg'];
		color = json['color'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['avg'] = this.avg;
		data['color'] = this.color;
		return data;
	}
}

class NeedleResultsTemperature {
	double avg;

	NeedleResultsTemperature({this.avg});

	NeedleResultsTemperature.fromJson(Map<String, dynamic> json) {
		avg = json['avg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['avg'] = this.avg;
		return data;
	}
}

class NeedleResultsPower {
	double avg;
	String color;

	NeedleResultsPower({this.avg, this.color});

	NeedleResultsPower.fromJson(Map<String, dynamic> json) {
		avg = json['avg'];
		color = json['color'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['avg'] = this.avg;
		data['color'] = this.color;
		return data;
	}
}

class NeedleResultsMoisture {
	double avg;
	String color;

	NeedleResultsMoisture({this.avg, this.color});

	NeedleResultsMoisture.fromJson(Map<String, dynamic> json) {
		avg = json['avg'];
		color = json['color'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['avg'] = this.avg;
		data['color'] = this.color;
		return data;
	}
}
