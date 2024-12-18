import 'package:flutter/material.dart';
import 'package:news_applicaation/API/injection.dart';
import 'package:news_applicaation/MODALS/Getnewslistmodal.dart';
import 'package:url_launcher/url_launcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  GetNewsListModal? getNewsListModal;
  List articles = [];
  List filteredArticles = [];
  String searchQuery = "";

  Future<void> getNews() async {
    await restClient.getlistapimethod().then((value) {
      setState(() {
        getNewsListModal = value;
        articles = value.articles!;
        filteredArticles = articles;
      });
    }).onError(
      (error, stackTrace) {
        print('Error: $error');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  void filterArticles(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        filteredArticles = articles
            .where((article) =>
                article.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredArticles = articles;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'TechNews',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterArticles,
                decoration: InputDecoration(
                  hintText: "Search for a keyword or phrase",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: getNewsListModal == null
                    ? Center(child: CircularProgressIndicator())
                    : filteredArticles.isEmpty
                        ? Center(
                            child: Text(
                              "No news found",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: getNews,
                            child: ListView.separated(
                              itemCount: filteredArticles.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 20,
                                color: Colors.blue[200],
                              ),
                              itemBuilder: (context, index) {
                                final article = filteredArticles[index];
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 150,
                                      child: article.urlToImage != null &&
                                              article.urlToImage!.isNotEmpty
                                          ? Image.network(
                                              article.urlToImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/placeholder_image.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title ?? "No Title",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            article.publishedAt ?? "No Date",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: GestureDetector(
                                        onTap: () async {
                                          final url = article.url ?? "";
                                          if (url.isNotEmpty &&
                                              (url.startsWith('http://') ||
                                                  url.startsWith('https://'))) {
                                            final Uri uri = Uri.parse(url);
                                            try {
                                              bool launched = await launchUrl(
                                                uri,
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                              if (!launched) {
                                                print(
                                                    "Could not launch $url");
                                              }
                                            } catch (e) {
                                              print("Error launching URL: $e");
                                            }
                                          } else {
                                            print("Invalid URL: $url");
                                          }
                                        },
                                        child: Text(
                                          article.url?.isNotEmpty == true
                                              ? article.url!
                                              : "No URL",
                                          style: TextStyle(color: Colors.blue),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
