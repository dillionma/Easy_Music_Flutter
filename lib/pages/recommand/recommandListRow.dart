import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './../SongList/playList.dart';

class RecommandList extends StatelessWidget {
  var recommandList;

  String computePlayCount(int number) {
    return (number / 10000).toStringAsFixed(0);
  }

  RecommandList(this.recommandList);
  @override
  Widget build(BuildContext context) {
    return recommandList == null
    ?
    Container()
    :
    Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 5,
                    height: 20,
                    color: Colors.red,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      '最新歌单',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87
                      ),
                    ),
                  )
                ],
              ),
              Text(
                '更多',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(10),
            itemCount: recommandList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayList(id: recommandList[index]['id'])
                    )
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: recommandList[index]['coverImgUrl'],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black26, Colors.white24]
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              computePlayCount(recommandList[index]['playCount']) + '万',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.grey[200]
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 120,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          recommandList[index]['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                )
              );
            },
          ),
        )
      ],
    );
  }
}