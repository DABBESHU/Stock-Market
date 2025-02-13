import 'dart:async';
import 'package:flutter/material.dart';
import '../api_service.dart';
import 'stock_detail_screen.dart';
import 'login_screen.dart'; // Import the login screen for logout navigation

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> stocks = [];
  Timer? _debounce;
  bool _isSearching = false;

  void searchStocks() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        stocks = [];
        _isSearching = false;
      });
      return;
    }

    List<dynamic> results =
        await ApiService().searchStocks(_searchController.text);
    setState(() {
      stocks = results;
      _isSearching = true;
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), searchStocks);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildInvestmentOption(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionItem(String title, String subtitle, IconData icon) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // Logout logic
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset(0, kToolbarHeight), // Position below the app bar
          Offset(overlay.size.width, kToolbarHeight + 50),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
          value: "profile",
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.white),
            title: Text(
              "Privacy Policy",
              style: TextStyle(color: Colors.white),
            ),
          ),
          value: "privacy",
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
          ),
          value: "settings",
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red[300]),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.red[300]),
            ),
          ),
          value: "logout",
        ),
      ],
      elevation: 8,
      color: Colors.grey[900],
    ).then((value) {
      if (value == "logout") {
        _logout(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          "Stock Search",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _showPopupMenu(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => _isSearching = true),
              child: Center(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _isSearching
                      ? MediaQuery.of(context).size.width * 0.92
                      : MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white60),
                      SizedBox(width: 10),
                      Expanded(
                        child: _isSearching
                            ? TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search for stocks...",
                                  hintStyle: TextStyle(color: Colors.white60),
                                  border: InputBorder.none,
                                ),
                              )
                            : Text(
                                "Search for stocks...",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 16),
                              ),
                      ),
                      if (_isSearching)
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white60),
                          onPressed: () {
                            setState(() {
                              _isSearching = false;
                              _searchController.clear();
                              stocks = [];
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display search results below the search bar
            if (_isSearching && stocks.isNotEmpty)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 300,
                width: MediaQuery.of(context).size.width * 0.92,
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                ),
                child: ListView.builder(
                  itemCount: stocks.length,
                  itemBuilder: (context, index) {
                    final stock = stocks[index];
                    final String? imageUrl = stock["image"]?["url"];
                    final bool hasImage =
                        imageUrl != null && imageUrl.isNotEmpty;

                    return ListTile(
                      leading: ClipOval(
                        child: Image.network(
                          hasImage
                              ? imageUrl
                              : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.business, size: 50),
                        ),
                      ),
                      title: Text(
                        stock["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        stock["symbol"],
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StockDetailScreen(stockId: stock["id"]))),
                    );
                  },
                ),
              ),
            // Display other sections only when not searching
            if (!_isSearching) ...[
              // Investment Options Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Investment Options",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildInvestmentOption(
                              "Mutual Funds", Icons.attach_money, Colors.blue),
                          _buildInvestmentOption(
                              "UPI", Icons.payment, Colors.green),
                          _buildInvestmentOption(
                              "Stocks", Icons.trending_up, Colors.orange),
                          _buildInvestmentOption(
                              "Gold", Icons.monetization_on, Colors.yellow),
                          _buildInvestmentOption(
                              "FD", Icons.account_balance, Colors.purple),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Collections Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Collections",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCollectionItem("Top Gainers",
                              "Stocks gaining today", Icons.trending_up),
                          _buildCollectionItem("Top Losers",
                              "Stocks losing today", Icons.trending_down),
                          _buildCollectionItem("Most Active",
                              "High volume stocks", Icons.bar_chart),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Products Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Products",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildInvestmentOption(
                              "SIP", Icons.calendar_today, Colors.blue),
                          _buildInvestmentOption(
                              "Lumpsum", Icons.money, Colors.green),
                          _buildInvestmentOption(
                              "ETF", Icons.pie_chart, Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Tools Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tools",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildToolItem(
                              "Calculator", Icons.calculate, Colors.blue),
                          _buildToolItem(
                              "Charts", Icons.show_chart, Colors.green),
                          _buildToolItem("News", Icons.article, Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
