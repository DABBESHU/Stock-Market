# Stock Market App

This project is a Stock Market application built using Flutter. It allows users to search for stocks, view detailed information about specific stocks, and visualize stock price trends over different time ranges.

## Features

**Login**: Users can log in to their accounts using email and password.
**Search Stocks**: Users can search for stocks by name or symbol.
**Stock Details**: View detailed information about a specific stock, including its industry, sector, market cap, employees, and description.
**Stock Price Graph**: Visualize stock price trends over different time ranges (1D, 1W, 1M, 1Y, 5Y).

## Project Structure

The project is organized into the following directories:

**lib/models**: Contains the data models used in the application.
  `stock_model.dart`: Defines the `Stock` model.
  
**lib/widgets**: Contains reusable UI components.
  `stock_detail_widget.dart`: A widget for displaying stock details.
  
**lib/screens**: Contains the main screens of the application.
  `login_screen.dart`: The login screen.
  `search_screen.dart`: The search screen where users can search for stocks.
  `stock_detail_screen.dart`: The screen for displaying detailed information about a specific stock.
  
**lib/api_service.dart**: Contains the API service for making network requests to the backend.

## Getting Started

To get started with the project, follow these steps:

1. **Clone the repository**:
   
   git clone https://github.com/your-username/stock_market.git
   cd stock_market
  

2. **Install dependencies**:
  
   flutter pub get
  

3. **Run the app**:
  
   flutter run
  

## Dependencies

The project uses the following dependencies:

`flutter`: The Flutter framework.
`http`: For making HTTP requests.
`shared_preferences`: For storing user data locally.
`fl_chart`: For displaying stock price graphs.

## API

The app communicates with a backend API hosted at `https://illuminate-production.up.railway.app/api`. The API provides endpoints for user authentication, stock search, stock details, and stock price graphs.

## Video

[Watch the screen recording](https://github.com/DABBESHU/Stock-Market/blob/b4737edca8afbc3378116db6c883ae29457b53b7/assets/screen%20record%20for%20stock%20market%20project.mp4)
