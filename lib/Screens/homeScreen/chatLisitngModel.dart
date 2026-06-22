class ChatListingModelN {
  bool? status;
  var message;
  List<ChatList>? data;

  ChatListingModelN({this.status, this.message, this.data});

  ChatListingModelN.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatList>[];
      json['data'].forEach((v) {
        data!.add(new ChatList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatList {
  var callDate;
  var astrId;
  var astroName;
  var astroNumber;
  var astroProfileImg;
  var userName;
  var astroDisplayName;
  var channelId;
  var fbChannelId;
  var rating;
  var review;

  ChatList(
      {this.callDate,
        this.astrId,
        this.astroName,
        this.astroNumber,
        this.astroProfileImg,
        this.userName,
        this.astroDisplayName,
        this.channelId,
        this.fbChannelId,
        this.rating,
        this.review
      });

  ChatList.fromJson(Map<String, dynamic> json) {
    callDate = json['callDate'];
    astrId = json['astrId'];
    astroName = json['astroName'];
    astroNumber = json['astroNumber'];
    astroProfileImg = json['astroProfileImg'];
    userName = json['userName'];
    astroDisplayName = json['astroDisplayName'];
    channelId = json['channelId'];
    fbChannelId = json['fbChannelId'];
    rating = json['rating'];
    review=json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callDate'] = this.callDate;
    data['astrId'] = this.astrId;
    data['astroName'] = this.astroName;
    data['astroNumber'] = this.astroNumber;
    data['astroProfileImg'] = this.astroProfileImg;
    data['userName'] = this.userName;
    data['astroDisplayName'] = this.astroDisplayName;
    data['channelId'] = this.channelId;
    data['fbChannelId'] = this.fbChannelId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    return data;
  }
}
