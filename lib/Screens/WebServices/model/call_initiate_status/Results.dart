
class StatusResults {
    String? id;
    String? status;

    StatusResults({this.id, this.status});

    factory StatusResults.fromJson(Map<String?, dynamic> json) {
        return StatusResults(
            id: json['_id'],
            status: json['status'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['_id'] = this.id;
        data['status'] = this.status;
        return data;
    }
}