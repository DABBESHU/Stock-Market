import 'package:flutter/material.dart';
import '../models/stock_model.dart';

class StockDetailWidget extends StatelessWidget {
  final Stock stock;
  final double? priceChangePercentage;
  final bool isDescriptionExpanded;
  final VoidCallback onToggleDescription;

  StockDetailWidget({
    required this.stock,
    required this.priceChangePercentage,
    required this.isDescriptionExpanded,
    required this.onToggleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Name
        Text(
          stock.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),

        // Symbol and Price
        Text(
          "Symbol: ${stock.symbol}",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              "\$${stock.price?.toStringAsFixed(2) ?? "N/A"}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (priceChangePercentage ?? 0) >= 0
                    ? Colors.green
                    : Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${priceChangePercentage?.toStringAsFixed(2) ?? "N/A"}%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Stock Details
        Text(
          "Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildDetailRow("Industry", stock.industry),
        _buildDetailRow("Sector", stock.sector),
        _buildDetailRow("Market Cap", "\$${stock.marketCap}"),
        _buildDetailRow("Employees", stock.employees.toString()),

        // Description with "Read More" option
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Description:",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              isDescriptionExpanded
                  ? stock.description
                  : stock.description.split(' ').take(20).join(' ') + "...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            if (stock.description.split(' ').length > 20)
              TextButton(
                onPressed: onToggleDescription,
                child: Text(
                  isDescriptionExpanded ? "Read Less" : "Read More",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
