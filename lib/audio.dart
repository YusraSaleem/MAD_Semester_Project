class Audio {
  final int? id;
  final String name;
  final String path;

  Audio({this.id, required this.name, required this.path});

  factory Audio.fromMap(Map map) {
    return Audio(
      id: map['id'],
      name: map['name'],
      path: map['path'],
    );
  }

  //this is a helper method
  toMap() {
    //we will already have an object so just simply call this method on that
    return {
      'id': id,
      'name': name,
      "path": path,
    };
  }
}
