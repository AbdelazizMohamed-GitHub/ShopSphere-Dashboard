import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/app/app_routes.dart';
import 'package:shop_sphere_dashboard/core/service/setup_locator.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';
import 'package:shop_sphere_dashboard/core/widget/custom_error_widget.dart';

import 'package:shop_sphere_dashboard/features/analytics/data/repo_impl/analytics_repo_impl.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/contoller/cubit/analytics_cubit.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/custom_chart_title.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/custom_order_over.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/custom_time_range.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/custom_total_card.dart';
import 'package:shop_sphere_dashboard/features/analytics/presention/view/widget/product_salse_chart_switcher.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveLayout.isDesktop(context);
    return BlocProvider(
      create: (context) =>
          AnalyticsCubit(analyticsRepo: getIt<AnalyticsRepoImpl>())
            ..getAnalyticsData(limit: 10),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: isDesktop
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
                    title: const Text('Analytics Dashboard'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context.read<AnalyticsCubit>().getAnalyticsData(
                            limit: 10,
                          );
                        },
                      ),
                    ],
                  ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time range selector
                  const SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CustomTimeRange()],
                    ),
                  ),
                  const SizedBox(height: 20),

                  BlocBuilder<AnalyticsCubit, AnalyticsState>(
                    builder: (context, state) {
                      return state is AnalyticsLoading
                          ? const Column(
                              children: [
                                SizedBox(height: 100),
                                Center(child: CircularProgressIndicator()),
                              ],
                            )
                          : state is AnalyticsError
                          ? CustomErrorWidget(
                              errorMessage: state.message.toString(),
                              onpressed: () async {
                                await context
                                    .read<AnalyticsCubit>()
                                    .getAnalyticsData(limit: 10);
                              },
                            )
                          : state is AnalyticsLoaded
                          ? state.ordersOver.isEmpty ||
                                    state.mostSoldProducts.isEmpty
                                ? const Center(child: Text("No Orders Found"))
                                : Column(
                                    children: [
                                      CustomTotalCard(
                                        totalOrder: state.ordersOver.fold(
                                          0,
                                          (sum, order) => sum + order.count,
                                        ),
                                        totalPrice: state.ordersOver.fold(
                                          0,
                                          (sum, order) => sum + order.totalCost,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // CustomChartTitle(
                                      //   title: "Orders Over",
                                      //   onViewAll: () {
                                      //     // Handle view all action
                                      //   },
                                      // ),
                                      CustomOrderOver(
                                        ordersOver: state.ordersOver,
                                        timeRangeIndex: context
                                            .read<AnalyticsCubit>()
                                            .timeRangeIndex,
                                      ),

                                      CustomChartTitle(
                                        title: "Most Sold Products",
                                        onViewAll: () {
                                          context.pushNamed(
                                            'productsMostSold',
                                            extra: state.mostSoldProducts,
                                          );
                                        },
                                      ),

                                      ProductSalesChartSwitcher(
                                        products: state.mostSoldProducts,
                                      ),
                                    ],
                                  )
                          : const Center(child: Text('No data available'));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
