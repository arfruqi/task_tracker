



class Task {
 final String id;
  final String title;
 final bool status;
 final DateTime duedate;



  Task ({
 required this.id,
  required this.title,
  required this.status ,
  required this.duedate,
});


factory Task.fromJson(Map <String, dynamic> json){
  return Task(
    id : json['id'],
    title : json ['title'],
    status : json ['status'],
    duedate : DateTime.parse(json ['duedate'] ),
  );
}

}

