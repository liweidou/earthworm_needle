class DaysDataEntity {
	List<DaysDataData> data;
	num warning = -1;

	DaysDataEntity({this.data, this.warning});

	DaysDataEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			data = new List<DaysDataData>();(json['data'] as List).forEach((v) { data.add(new DaysDataData.fromJson(v)); });
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

class DaysDataData {
	num avg;
	String color;
	num level;
	num day;

	DaysDataData({this.avg, this.color, this.level, this.day});

	DaysDataData.fromJson(Map<String, dynamic> json) {
		avg = json['avg'];
		color = json['color'];
		level = json['level'];
		day = json['day'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['avg'] = this.avg;
		data['color'] = this.color;
		data['level'] = this.level;
		data['day'] = this.day;
		return data;
	}
}
