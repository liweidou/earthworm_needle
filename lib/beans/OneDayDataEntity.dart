class OneDayDataEntity {
	List<OneDayDataData> data;
	dynamic warning;

	OneDayDataEntity({this.data, this.warning});

	OneDayDataEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			data = new List<OneDayDataData>();(json['data'] as List).forEach((v) { data.add(new OneDayDataData.fromJson(v)); });
		}
		warning = json['warning'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		data['warning'] = this.warning;
		return data;
	}
}

class OneDayDataData {
	double avg;
	int hour;
	String color;
	int level;

	OneDayDataData({this.avg, this.hour, this.color, this.level});

	OneDayDataData.fromJson(Map<String, dynamic> json) {
		avg = json['avg'];
		hour = json['hour'];
		color = json['color'];
		level = json['level'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['avg'] = this.avg;
		data['hour'] = this.hour;
		data['color'] = this.color;
		data['level'] = this.level;
		return data;
	}
}
