import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nymtune/src/bloc/presentation/widgets/hw_header.dart';
import 'package:nymtune/src/bloc/presentation/widgets/trending_now.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../bussiness_logic/blocs/home_blocs.dart';
import '../../bussiness_logic/states/home_state.dart';
import '../widgets/hw_search_bar.dart';
import '../widgets/top_picks.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            backgroundColor: Colors.black,
            title: HWHeader(),
            floating: true,
            snap: false,
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          const HWSearchBar(),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "top picks for you",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subHeader.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TopPicks(),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "trending now",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subHeader.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          TrendingNow(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
