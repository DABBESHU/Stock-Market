import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/stock_model.dart';
import '../widgets/stock_detail_widget.dart';
import 'package:fl_chart/fl_chart.dart';

class StockDetailScreen extends StatefulWidget {
  final int stockId;
  StockDetailScreen({required this.stockId});

  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  Stock? stockDetails;
  List<FlSpot> stockGraph = [];
  double? priceChange;
  double? priceChangePercentage;
  bool isLoading = true;
  String errorMessage = '';
  bool isDescriptionExpanded = false; // To toggle description expansion
  String selectedRange = '1D'; // Default range

  final List<String> rangeOptions = ['1D', '1W', '1M', '1Y', '5Y'];

  @override
  void initState() {
    super.initState();
    loadStockData();
    loadStockGraph(selectedRange);
  }

  void loadStockData() async {
    try {
      final stock = await ApiService().getStockById(widget.stockId);
      setState(() {
        stockDetails = stock != null ? Stock.fromJson(stock) : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load stock data: $e';
        isLoading = false;
      });
    }
  }

  void loadStockGraph(String range) async {
    try {
      final graphData = await ApiService().getStockGraph(widget.stockId, range);

      setState(() {
        stockGraph = graphData
            .map((e) => FlSpot(
                  DateTime.parse(e['Timestamp'])
                      .millisecondsSinceEpoch
                      .toDouble(),
                  e['ClosePrice'].toDouble(),
                ))
            .toList();

        if (stockGraph.isNotEmpty) {
          double startPrice = stockGraph.first.y;
          double endPrice = stockGraph.last.y;
          priceChange = endPrice - startPrice;
          priceChangePercentage = (priceChange! / startPrice) * 100;
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load stock graph: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(stockDetails?.name ?? "Stock Details"),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (stockDetails != null)
                        StockDetailWidget(
                          stock: stockDetails!,
                          priceChangePercentage: priceChangePercentage,
                          isDescriptionExpanded: isDescriptionExpanded,
                          onToggleDescription: () {
                            setState(() {
                              isDescriptionExpanded = !isDescriptionExpanded;
                            });
                          },
                        ),
                      SizedBox(height: 20),

                      // Range Selection Buttons in a Row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: rangeOptions.map((range) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedRange = range;
                                    loadStockGraph(selectedRange);
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: selectedRange == range
                                      ? Colors.blue
                                      : Colors.grey[800],
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  range,
                                  style: TextStyle(
                                    color: selectedRange == range
                                        ? Colors.white
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Stock Graph
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(16),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 0.5,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 0.5,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            minX:
                                stockGraph.isNotEmpty ? stockGraph.first.x : 0,
                            maxX: stockGraph.isNotEmpty ? stockGraph.last.x : 0,
                            minY: stockGraph.isNotEmpty
                                ? stockGraph.map((e) => e.y).reduce(
                                    (value, element) =>
                                        value < element ? value : element)
                                : 0,
                            maxY: stockGraph.isNotEmpty
                                ? stockGraph.map((e) => e.y).reduce(
                                    (value, element) =>
                                        value > element ? value : element)
                                : 0,
                            lineBarsData: [
                              LineChartBarData(
                                spots: stockGraph,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(0.3),
                                      Colors.blue.withOpacity(0.0)
                                    ],
                                    stops: [0.5, 1.0],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (LineBarSpot touchedSpot) =>
                                    Colors.blueAccent,
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    final date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            spot.x.toInt());
                                    return LineTooltipItem(
                                      '${date.toString()}\n\$${spot.y.toStringAsFixed(2)}',
                                      TextStyle(color: Colors.white),
                                    );
                                  }).toList();
                                },
                              ),
                              handleBuiltInTouches: true,
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
