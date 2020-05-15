class UserEntity {
	dynamic next;
	dynamic previous;
	int count;
	List<UserResult> results;

	UserEntity({this.next, this.previous, this.count, this.results});

	UserEntity.fromJson(Map<String, dynamic> json) {
		next = json['next'];
		previous = json['previous'];
		count = json['count'];
		if (json['results'] != null) {
			results = new List<UserResult>();(json['results'] as List).forEach((v) { results.add(new UserResult.fromJson(v)); });
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

class UserResult {
	String name;
	String mobile;
	int id;
	bool is_deleted = false;

	UserResult({this.name, this.mobile, this.id});

	UserResult.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		mobile = json['mobile'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['mobile'] = this.mobile;
		data['id'] = this.id;
		data['is_deleted'] = this.is_deleted;
		return data;
	}
}
