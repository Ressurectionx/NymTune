import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nymtune/src/presentation/providers/search_song_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/input_decoration.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  TextField(
                    controller: searchProvider.searchController,
                    decoration: inputDecoration(),
                    onChanged: (searchTerm) =>
                        searchProvider.searchSongs(searchTerm),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: searchProvider.searchResults.isEmpty
                        ? Lottie.asset("assets/json_lottie/searching.json")
                        : ListView.builder(
                            itemCount: searchProvider.searchResults.length,
                            itemBuilder: (context, index) {
                              final song = searchProvider.searchResults[index];
                              return InkWell(
                                onTap: () {},
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      song.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                  title: Text(song.title),
                                  subtitle: Text(song.artist),
                                  trailing: Text(song.duration),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
