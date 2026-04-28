class Message {
  final String message;
  final String id;

  Message(this.message, this.id);

  factory Message.fromJson( jsonData) {
    if (jsonData is Map<String, dynamic>) {
      return Message(
        jsonData['message'] ?? '',
        jsonData['id'],
      );
    }
    
    return Message('Error occur!', 'Null');
  }
}
