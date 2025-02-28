<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
    <style>
        /* Your custom styles */
    </style>
</head>

<body>

<div class="container">
    <h2 class="text-center mb-4">Search Results</h2>

    <%
        String checkInDate = request.getParameter("check_in");
        String checkOutDate = request.getParameter("check_out");
        String priceRange = request.getParameter("price");

        // Initialize minPrice and maxPrice
        int minPrice = 0;
        int maxPrice = Integer.MAX_VALUE;

        // Handle price range
        if ("Under 700".equals(priceRange)) {
            minPrice = 0;
            maxPrice = 700;
        } else if ("100-200".equals(priceRange)) {
            minPrice = 800;
            maxPrice = 1000;
        } else if ("200-300".equals(priceRange)) {
            minPrice = 1000;
            maxPrice = 1500;
        } else if ("300-400".equals(priceRange)) {
            minPrice = 1500;
            maxPrice = 2000;
        } else if ("400+".equals(priceRange)) {
            minPrice = 2000;
            maxPrice = Integer.MAX_VALUE;
        }

        // Database connection and query
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String url = "jdbc:mysql://localhost:3306/apartment?useUnicode=true&characterEncoding=UTF-8";
        String dbUser = "root";
        String dbPassword = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // SQL Query to fetch rooms based on price range
            String sql = "SELECT * FROM rooms WHERE price BETWEEN ? AND ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, minPrice);
            stmt.setInt(2, maxPrice);

            rs = stmt.executeQuery();

            if (rs.next()) {
                out.println("<div class='alert alert-success'>Rooms Found</div>");
                do {
                    String roomName = rs.getString("room_name");
                    double price = rs.getDouble("price");
                    int size = rs.getInt("size");
                    String bedType = rs.getString("bed_type");
                    String description = rs.getString("description");
                    out.println("<div class='room-card'>");
                    out.println("<h3>" + roomName + "</h3>");
                    out.println("<p>Price: ₹" + price + "</p>");
                    out.println("<p>Size: " + size + " sq ft</p>");
                    out.println("<p>Bed Type: " + bedType + "</p>");
                    out.println("<p>Description: " + description + "</p>");
                    out.println("</div>");
                } while (rs.next());
            } else {
                out.println("<div class='alert alert-danger'>No rooms found in this price range.</div>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    %>

</div>

</body>
</html>
