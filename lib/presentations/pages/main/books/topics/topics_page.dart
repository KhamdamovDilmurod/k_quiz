import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k_quiz/config/app_theme_colors.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/study/learning_method_page.dart';
import 'package:k_quiz/presentations/pages/main/books/topics/topics_bloc.dart';
import 'package:k_quiz/presentations/ui/widget/topics_item_view.dart';

import '../../../../../data/bloc/base/base_state.dart';
import '../../../../../di/service_locator.dart';
import '../../../../ui/common/custom_appbar.dart';
import '../../../../ui/common/empty_state.dart';

class TopicsPage extends StatelessWidget {
  final int bookId;
  const TopicsPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopicsBloc(getIt.get(),bookId )..add(LoadTopicsEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Mavzular",
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.appColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<TopicsBloc, BaseState>(
          builder: (context, state) {
            if (state is ShowLoadingState && state.show) {
              return Center(child: CircularProgressIndicator());
            }
        
            if (state is LoadedState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TopicsBloc>().add(RefreshTopicsEvent());
                },
                child: ListView.builder(
                  itemCount: state.loadedData.length,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final topic = state.loadedData[index];
                    return TopicsItemView(
                      topic: topic,
                      onClicked: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LearningMethodScreen(topicId: topic.topicId,),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
        
            return  EmptyStateWidget(
              icon: Icons.topic_outlined,
              title: 'Mavzular topilmadi',
              subtitle: 'Hozircha mavzular yo\'q',
            );
          },
        ),
      ),
    );
  }
}
