import 'package:flutter/material.dart';
import 'loading_component.dart';
import 'error_component.dart';
import 'empty_component.dart';

enum PageLoadState { loading, error, empty, content }

class PageLoadStateWidget extends StatelessWidget {
  final PageLoadState pageLoadState;
  final Widget loading;
  final Widget error;
  final Widget empty;
  final Widget content;

  PageLoadStateWidget(
      {@required this.pageLoadState,
      @required this.content,
      this.loading,
      this.error,
      this.empty});

  Widget _buildLoading() {
    if (loading != null) {
      return loading;
    }
    return LoadingComponent();
  }

  Widget _buildError() {
    if (error != null) {
      return error;
    }
    return ErrorComponent();
  }

  Widget _buildEmpty() {
    if (empty != null) {
      return empty;
    }
    return EmptyComponent();
  }

  Widget _build() {
    if (pageLoadState == PageLoadState.loading) {
      return _buildLoading();
    } else if (pageLoadState == PageLoadState.empty) {
      return _buildEmpty();
    } else if (pageLoadState == PageLoadState.error) {
      return _buildError();
    } else {
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _build(),
    );
  }
}
