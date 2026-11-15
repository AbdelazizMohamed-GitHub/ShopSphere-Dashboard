import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere_dashboard/core/utils/responsive_layout.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = ResponsiveLayout.getHorizontalLargePadding(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Search"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              hintText: "Search for products...",
              onChanged: (query) {
                controller.openView();
              },
              onSubmitted: (query) {
                final normalizedQuery = query.trim();
                if (normalizedQuery.isEmpty) return;
                FocusScope.of(context).unfocus();
                context.pushNamed(
                  'dashboardSearchResult',
                  queryParameters: {'q': normalizedQuery},
                );
              },
              leading: const Icon(Icons.search),
            );
          },
          suggestionsBuilder: (context, controller) => const [],
        ),
      ),
    );
  }
}
