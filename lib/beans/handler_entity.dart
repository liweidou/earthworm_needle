class HandlerEntity {
	dynamic next;
	dynamic previous;
	int count;
	List<HandlerResult> results;

	HandlerEntity({this.next, this.previous, this.count, this.results});

	HandlerEntity.fromJson(Map<String, dynamic> json) {
		next = json['next'];
		previous = json['previous'];
		count = json['count'];
		if (json['results'] != null) {
			results = new List<HandlerResult>();(json['results'] as List).forEach((v) { results.add(new HandlerResult.fromJson(v)); });
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

class HandlerResult {
	String name;
	String mobile;
	int id;

	HandlerResult({this.name, this.mobile, this.id});

	HandlerResult.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		mobile = json['mobile'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['mobile'] = this.mobile;
		data['id'] = this.id;
		return data;
	}
}
