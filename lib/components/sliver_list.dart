import 'package:flutter/material.dart';
import '../services/database.dart';

class UsersList extends StatefulWidget {
  final List users;
  final List userNames;
  final String searchedName;
  final String uid;
  UsersList({this.users,this.searchedName,this.userNames,this.uid});
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {

  Database db = Database();
  List<bool> boolList = [];
  void search(){
    boolList = [];
    widget.userNames.forEach((element) {
      boolList.add(element.toString().toLowerCase().contains(widget.searchedName.toLowerCase()));
    });
    print(boolList);
  }
  @override
  Widget build(BuildContext context) {
    search();
    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {

                  if(widget.searchedName == ''){return null;}
              return boolList[index]? Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: ListTile(
                  onTap: (){

                  },
                  leading: CircleAvatar(
                    backgroundImage:
                    NetworkImage(widget.users[index].photoUrl),
                  ),
                  title: Text(widget.users[index].name),
                  trailing: FlatButton(
                    color: Colors.blue,
                    child: Text(
                      'Reach Out!'
                    ),
                    onPressed: (){
                      db.addFollower(widget.uid, widget.users[index].uid);
//                    print(widget.users[index].uid);
                    },
                  ),
                  ),
              ): null;
            }, childCount: widget.users.length),
      )
    ]);
  }
}



