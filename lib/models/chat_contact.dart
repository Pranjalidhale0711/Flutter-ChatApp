class Chatcontact {
  final String name;
  final String profilepic;
  final String contactid;
  final DateTime timesent;
  final String lastmessage;
  Chatcontact(
      {required this.name,
      required this.profilepic,
      required this.contactid,
      required this.timesent,
      required this.lastmessage});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilepic,
      'contactId': contactid,
      'timeSent': timesent.millisecondsSinceEpoch,
      'lastMessage': lastmessage,
    };
  }
 factory Chatcontact.fromMap(Map<String, dynamic> map){
   return Chatcontact(
      name: map['name'] ?? '',
      profilepic: map['profilePic'] ?? '',
      contactid: map['contactId'] ?? '',
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastmessage: map['lastMessage'] ?? '',
    );
 }
}
