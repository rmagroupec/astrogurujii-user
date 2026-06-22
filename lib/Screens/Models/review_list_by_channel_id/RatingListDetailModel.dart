
class RatingListDetailModel {
    bool? status;
    String? message;
    List<Results>? results;

    RatingListDetailModel({this.status, this.message, this.results});

    RatingListDetailModel.fromJson(Map<String, dynamic> json) {
        status = json['status'];
        message = json['message'];
        if (json['results'] != null) {
            results = <Results>[];
            json['results'].forEach((v) {
                results!.add(new Results.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        data['message'] = this.message;
        if (this.results != null) {
            data['results'] = this.results!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Results {
    String? channelId;
    String? id;
    String? name;
    String? profileImg;
    String? astroName;
    String? astroProfileImg;
    var rating;
    String? review;
    String? astrComment;
    String? createdDate;

    Results(
        {this.channelId,
            this.id,
            this.name,
            this.profileImg,
            this.astroName,
            this.astroProfileImg,
            this.rating,
            this.review,
            this.astrComment,
            this.createdDate});

    Results.fromJson(Map<String, dynamic> json) {
        channelId = json['channel_id'];
        id = json['id'];
        name = json['name'];
        profileImg = json['profile_img'];
        astroName = json['astro_name'];
        astroProfileImg = json['astro_profile_img'];
        rating = json['rating'];
        review = json['review'];
        astrComment = json['astr_comment'];
        createdDate = json['Created_date'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['channel_id'] = this.channelId;
        data['id'] = this.id;
        data['name'] = this.name;
        data['profile_img'] = this.profileImg;
        data['astro_name'] = this.astroName;
        data['astro_profile_img'] = this.astroProfileImg;
        data['rating'] = this.rating;
        data['review'] = this.review;
        data['astr_comment'] = this.astrComment;
        data['Created_date'] = this.createdDate;
        return data;
    }
}
