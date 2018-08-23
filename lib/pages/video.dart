import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui' show ImageFilter;
import '../data/movie.dart';
import '../data/movie_api.dart';
import '../data/movie_shared_preferences.dart';
import '../widget/pulltorefush.dart';
import '../widget/page_state.dart';
import 'package:flutter_simple_video_player/flutter_simple_video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // 1 电影 2连续剧 3 综艺 4动漫 5动作片 6喜剧 7爱情 8科幻 9恐怖
// 10 剧情 11战争 12 国产剧 13 香港剧 14韩国 15 欧美 16 台湾
// 17 日本 18 海外19记录 20 微电影 21 伦理片 22 福利
  List<_VidePageModel> _allPages = <_VidePageModel>[
    _VidePageModel(text: '电影', type: 1),
    _VidePageModel(text: '连续剧', type: 2),
    _VidePageModel(text: '综艺', type: 3),
    _VidePageModel(text: '动漫', type: 4),
    _VidePageModel(text: '动作片', type: 5),
    _VidePageModel(text: '喜剧片', type: 6),
    _VidePageModel(text: '爱情片', type: 7),
    _VidePageModel(text: '科幻片', type: 8),
    _VidePageModel(text: '恐怖片', type: 9),
    _VidePageModel(text: '剧情片', type: 10),
    _VidePageModel(text: '战争片', type: 11),
    _VidePageModel(text: '国产剧', type: 12),
    _VidePageModel(text: '香港剧', type: 13),
    _VidePageModel(text: '韩国剧', type: 14),
    _VidePageModel(text: '欧美剧', type: 15),
    _VidePageModel(text: '台湾剧', type: 16),
    _VidePageModel(text: '日本剧', type: 17),
    _VidePageModel(text: '海外剧', type: 18),
    _VidePageModel(text: '纪录片', type: 19),
    _VidePageModel(text: '微电影', type: 20),
    _VidePageModel(text: '伦理片', type: 21),
//    _VidePageModel(text: '福利片', type: 22),
  ];

  List<Widget> tabviews = [];

  @override
  void initState() {
    if (tabviews.isEmpty) {
      tabviews = _allPages.map((page) {
        return MovieList(page.type);
      }).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: _allPages.length,
        child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                isScrollable: true,
                tabs: _allPages.map((page) {
                  return Tab(text: page.text);
                }).toList(),
              ),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Search',
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoSearchPage()),
                    );
                  },
                )
              ],
            ),
            body: TabBarView(
              children: tabviews,
            )));
  }
}

class MovieList extends StatefulWidget {
  final int type;

  MovieList(this.type);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  PageLoadState pageLoadState;
  List<Movie> list;
  List<String> links;
  int current = 0;

  //刷新主页面
  Future<void> _refushList() async {
    if (links.isEmpty) {
      return null;
    }
    return getPageListMovie(links[0]).then((pageData) {
      setState(() {
        list = pageData;
        pageLoadState = PageLoadState.content;
      });
      current = 0;
    });
  }

  // 加载更多
  void _loadMore() async {
    if ((current + 1) < links.length) {
      getPageListMovie(links[current + 1]).then((pageData) {
        setState(() {
          list.addAll(pageData);
        });
        current++;
      });
    }
  }

  @override
  void initState() {
    initPage();
    super.initState();
  }

  void initPage() async {
    list = [];
    links = [];
    pageLoadState = PageLoadState.loading;
    getAllPageLink(type: widget.type).then((allLinks) {
      links = allLinks;
      _refushList();
    });
  }

  Widget buildListTile(BuildContext context, Movie item) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(item.name.substring(0, 1)),
      ),
      title: Text(item.name),
      subtitle: Text(item.date),
    );
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        list.map((Movie item) => buildListTile(context, item));
    return PageLoadStateWidget(
        pageLoadState: pageLoadState,
        content: PullToRefushWidget(
          list: list,
          loadMore: _loadMore,
          refush: _refushList,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListTile.divideTiles(context: context, tiles: listTiles)
                  .toList()[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoDetailPage(list[index].link, list[index].name)),
                );
              },
            );
          },
        ));
  }
}

class VideoDetailPage extends StatefulWidget {
  String link;
  String name;

  VideoDetailPage(this.link, this.name);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  String source;
  MovieDetail movieDetail;
  PageLoadState pageLoadState = PageLoadState.loading;
  TabController tabController;

  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    getMovieDetail(widget.link).then((detail) {
      setState(() {
        movieDetail = detail;
        pageLoadState = PageLoadState.content;
      });
    });
    super.initState();
  }

  Widget buildHead() {
    if (movieDetail == null) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(movieDetail.image),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Color.fromARGB(200, 20, 10, 40), BlendMode.srcOver)
          )
      ),
      child: Container(
        margin: EdgeInsets.only(top: 68.0),
        child: Row(
          children: <Widget>[
            Container(
              child: Image.network(
                movieDetail.image,
                width: 135.0,
                height: 192.0,
                fit: BoxFit.cover,
              ),
              padding: EdgeInsets.all(12.0),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: movieDetail.infoList.map((text) {
                      return Text(
                        text,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfo() {
    if (movieDetail == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Text(movieDetail.detail),
    );
  }

  Widget buildPlayList(){
    if(movieDetail == null){
      return Container();
    }
    return ListView(
        children: movieDetail.source.keys.toList().map((key){
          return ExpansionTile(
            title: Text("播放源：$key"),
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
            children: movieDetail.source[key].map((text){
              return ListTile(
                title: Text(text.split("\$")[0]),
                trailing: RaisedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoFullPage(text.split("\$")[1])
                    ),
                  );
                }, child: Text("Play"),
                ),
              );
            }).toList(),
          );
        }).toList(),
    );
  }

  Widget buildContent(BuildContext context) {
    if (movieDetail == null) {
      return Container();
    }
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text(widget.name),
            expandedHeight: 256.0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: buildHead(),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey,
                controller: tabController,
                tabs: [
                  Tab(text: "视频介绍"),
                  Tab(text: "播放列表"),
                ],
              ),
            ),
          )
        ];
      },
      body: TabBarView(controller: tabController, children: [
        buildInfo(),
        buildPlayList()
      ]),
    );
  }


  List<String> getPlayerSource() {
    List<String> categorys = movieDetail.source.keys.toList();
    if (categorys.contains("ckm3u8")) {
      return movieDetail.source["ckm3u8"];
    }
    return movieDetail.source[categorys[0]];
  }

  Widget getAppBar(){
    if(movieDetail == null){
      return AppBar(
        title: Text(widget.name),
      );
    }else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: PageLoadStateWidget(pageLoadState: pageLoadState, content: buildContent(context)),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _VidePageModel {
  _VidePageModel({this.text, this.type});

  String text;
  int type;
}

class VideoSearchPage extends StatefulWidget {
  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<VideoSearchPage> {
  TextEditingController controller;
  PageLoadState pageLoadState;
  List<String> links;
  int current = 0;
  List<Movie> list = [];
  List<String> historyList = [];
  bool isSearchResult = false;

  @override
  void initState() {
    controller = TextEditingController();
    pageLoadState = PageLoadState.content;
    getSearchHistory().then((historys) {
      if (historys != null && historys.isNotEmpty) {
        setState(() {
          historyList = historys;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //刷新主页面
  Future<void> _refushList() async {
    if (links.isEmpty) {
      return null;
    }
    return getPageListMovie(links[0]).then((pageData) {
      setState(() {
        list = pageData;
        pageLoadState = PageLoadState.content;
      });
      current = 0;
    });
  }

  // 加载更多
  void _loadMore() async {
    if ((current + 1) < links.length) {
      getPageListMovie(links[current + 1]).then((pageData) {
        setState(() {
          list.addAll(pageData);
        });
        current++;
      });
    }
  }

  void search(String query) async {
    print('Search key: $query');
    setState(() {
      isSearchResult = true;
      pageLoadState = PageLoadState.loading;
    });
    links = await getSearchPageLink(query);
    current = 0;
    print(links);
    if (links.isEmpty) {
      //无结果
      setState(() {
        pageLoadState = PageLoadState.empty;
      });
    } else {
      getPageListMovie(links[current]).then((result) {
        if (result != null && result.isNotEmpty) {
          setState(() {
            list = result;
            pageLoadState = PageLoadState.content;
          });
          addHistory(query);
        } else {
          setState(() {
            pageLoadState = PageLoadState.empty;
          });
        }
      });
    }
  }

  void addHistory(String query) {
    addSearchHistory(query).then((result) {
      debugPrint("add history success");
    });
  }

  Widget buildContent() {
    if (isSearchResult) {
      return PullToRefushWidget(
        list: list,
        loadMore: _loadMore,
        refush: _refushList,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile.divideTiles(
                    context: context,
                    tiles:
                        list.map((Movie item) => buildListTile(context, item)))
                .toList()[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoDetailPage(list[index].link, list[index].name)),
              );
            },
          );
        },
      );
    } else {
      return ListView.builder(
          itemCount: historyList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListTile(
                  title: Text(historyList[index]),
                  leading: Icon(Icons.history)),
              onTap: () {
                controller.text = historyList[index];
                FocusScope.of(context).requestFocus(new FocusNode());
                search(historyList[index]);
              },
            );
          });
    }
  }

  Widget buildListTile(BuildContext context, Movie item) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(item.name.substring(0, 1)),
      ),
      title: Text(item.name),
      subtitle: Text(item.date),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: IconTheme(
                data: Theme.of(context).iconTheme,
                child: Icon(Icons.arrow_back)),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Container(
          child: Center(
            child: TextField(
              controller: controller,
              autofocus: true,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: new InputDecoration.collapsed(hintText: "输入关键词"),
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontFamily: "Roboto"),
              onSubmitted: search,
            ),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            tooltip: 'Clear',
            icon: IconTheme(
                data: Theme.of(context).iconTheme,
                child: const Icon(Icons.clear)),
            onPressed: () {
              controller.clear();
            },
          )
        ],
      ),
      body: PageLoadStateWidget(
          pageLoadState: pageLoadState, content: buildContent()),
    );
  }
}
