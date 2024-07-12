import 'package:flutter/material.dart';
import 'package:shoping_gallery/model/product_model.dart';
import 'package:shoping_gallery/service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product?>> productData;
  Future<List<dynamic>>? categoriesFuture;
  late Future<List<Product?>> categoryData;
  Future<List<Product?>>? searchData;
  String? selectedCategory;
  String appBarTitle = "Product";
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productData = Api().getProductData();
    categoriesFuture = Api().getCategoriesList();
    // Initialize selectedCategory as null to show default product data
    selectedCategory = null;
  }

  void updateAppBarTitle(String title) {
    setState(() {
      appBarTitle = title;
    });
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void endSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      searchData = null;
    });
  }

  Future<void> performSearch(String query) async {
    try {
      List<Product?> searchResults = await Api().getSearch(query);
      setState(() {
        searchData = Future.value(searchResults);
      });
    } catch (error) {
      print("Error performing search: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.dehaze_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: isSearching
            ? TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Update search results based on user input
            performSearch(value);
          },
          onSubmitted: (value){
            performSearch(value);
          },
        )
            : Center(
               child: Text(
               appBarTitle,
               style: TextStyle(fontSize: 25),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (isSearching) {
                // If already searching, end search
                endSearch();
              } else {
                // Start search
                startSearch();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<List<dynamic>>(
          future: categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> categories = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                      ),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    );
                  } else {
                    var category = categories[index - 1];
                    return ListTile(
                      title: Text(category),
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          categoryData = Api().getCategories(selectedCategory!);
                          // Update app bar title
                          updateAppBarTitle(selectedCategory!);
                          // End search if it's active
                          endSearch();
                        });
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: FutureBuilder<List<Product?>>(
            future: isSearching ? searchData : selectedCategory != null ? categoryData : productData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<Product?> products = snapshot.data!;
                return Column(
                  children: [
                    for (int rowIndex = 0;
                    rowIndex < (products.length / 2).ceil();
                    rowIndex++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = rowIndex * 2;
                          i < (rowIndex * 2 + 2);
                          i++)
                            if (i < products.length)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle product tap if needed
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          child: Container(
                                            color: Colors.grey,
                                            height: 250,
                                            width: 200,
                                            child: Image.network(
                                              "${products[i]?.thumbnail}",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        products[i]?.title ?? "",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                  ],
                );
              } else {
                return Center(child: Text('No data available.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
