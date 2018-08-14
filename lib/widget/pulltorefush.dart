import 'package:flutter/material.dart';

class PullToRefushWidget<T> extends StatelessWidget {
  final List<T> list;
  final ScrollController _scrollController = new ScrollController();
  final Function loadMore;
  final RefreshCallback refush;
  final Widget loading;
  final IndexedWidgetBuilder itemBuilder;

  PullToRefushWidget(
      {this.list, this.loadMore, this.refush, this.loading, this.itemBuilder});

  Widget _buildLoading() {
    if (loading != null) {
      return loading;
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Text("loading..."),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });

    return new RefreshIndicator(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: list.length + 1,
            itemBuilder: (BuildContext context, int position) {
              if (position == list.length) {
                return _buildLoading();
              } else {
                return itemBuilder(context, position);
              }
            }),
        onRefresh: refush);
  }
}
