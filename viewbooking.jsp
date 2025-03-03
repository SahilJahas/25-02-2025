<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>LOFT CITY | Responsive Travel & Tourism Template</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicons -->
    <link href="img/favicon.ico" rel="icon">
    <link href="img/apple-favicon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,700|Raleway:100,200,300,400,500,600,700,800,900" rel="stylesheet">

    <!-- Vendor CSS File -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="vendor/slick/slick.css" rel="stylesheet">
    <link href="vendor/slick/slick-theme.css" rel="stylesheet">
    <link href="vendor/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Main Stylesheet File -->
    <link href="css/hover-style.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>

<body>

    <!-- Header Section Start -->
    <header id="header">
        <a href="index.html" class="logo"><img src="img/logo.png" alt="logo"></a>
        <div class="phone"><i class="fa fa-phone"></i>+1 234 567 8900</div>
        <div class="mobile-menu-btn"><i class="fa fa-bars"></i></div>
        <nav class="main-menu top-menu">
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="about.html">About Us</a></li>
                <li><a href="room.html">Apartments</a></li>
                <li><a href="amenities.html">Amenities</a></li>
                <li><a href="booking.jsp">Booking</a></li>
                <li class="active"><a href="login.html">Login</a></li>
                <li><a href="contact.html">Contact Us</a></li>
            </ul>
        </nav>
    </header>    
    <!-- Header Section End -->

    <div class="container my-5">
        <div class="row">
            <div class="col-lg-8 mx-auto">
                <div class="card shadow-lg">
                    <div class="card-header bg-primary text-white text-center">
                        <h2>Booking Details</h2>
                    </div>
                    <div class="card-body">
                        <% 
                            if ("POST".equalsIgnoreCase(request.getMethod())) {
                                // Retrieve form values
                                String fname = request.getParameter("first_name");
                                String lname = request.getParameter("last_name");
                                String mobile = request.getParameter("mobile");
                                String email = request.getParameter("email");
                                String checkin = request.getParameter("check_in");
                                String checkout = request.getParameter("check_out");
                                String adult = request.getParameter("adult_count");
                                String kid = request.getParameter("kid_count");
                                String roomName = request.getParameter("room_name");
                                String numRooms = request.getParameter("num_rooms");

                                // Validate input fields (basic checks)
                                if (fname == null || lname == null || mobile == null || email == null || 
                                    checkin == null || checkout == null || adult == null || kid == null || 
                                    roomName == null || numRooms == null) {
                                    out.println("<div class='alert alert-danger text-center'>All fields must be filled out.</div>");
                                    return; // Stop execution if required fields are missing
                                }

                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;
                                String url = "jdbc:mysql://localhost:3306/apartment?useUnicode=true&characterEncoding=UTF-8";
                                String dbUser = "root";
                                String dbPassword = "";

                                try {
                                    // Ensure the driver is loaded
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection(url, dbUser, dbPassword);

                                    // Convert checkin and checkout dates into java.sql.Date
                                    java.sql.Date checkinDate = java.sql.Date.valueOf(checkin); // Ensure correct format
                                    java.sql.Date checkoutDate = java.sql.Date.valueOf(checkout);

                                    // Prepare SQL query for insertion
                                    String sql = "INSERT INTO bookings (first_name, last_name, mobile, email, check_in, check_out, adult_count, kid_count, room_name, num_rooms, created_at) "
                                               + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
                                    stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);  // Use RETURN_GENERATED_KEYS to get the booking ID
                                    stmt.setString(1, fname);
                                    stmt.setString(2, lname);
                                    stmt.setString(3, mobile);
                                    stmt.setString(4, email);
                                    stmt.setDate(5, checkinDate);
                                    stmt.setDate(6, checkoutDate);
                                    stmt.setInt(7, Integer.parseInt(adult));
                                    stmt.setInt(8, Integer.parseInt(kid));
                                    stmt.setString(9, roomName);  // Updated field
                                    stmt.setInt(10, Integer.parseInt(numRooms));

                                    // Execute the query and check for success
                                    int rowsAffected = stmt.executeUpdate();
                                    if (rowsAffected > 0) {
                                        rs = stmt.getGeneratedKeys();
                                        int bookingId = -1;
                                        if (rs.next()) {
                                            bookingId = rs.getInt(1);  // Get the generated booking ID
                                        }

                                        out.println("<div class='alert alert-success text-center'>Booking successful!</div>");
                                        
                                        // Display the booking details after successful booking
                                        out.println("<table class='table table-striped'>");
                                        out.println("<tr><th>Booking ID</th><td>" + bookingId + "</td></tr>");
                                        out.println("<tr><th>First Name</th><td>" + fname + "</td></tr>");
                                        out.println("<tr><th>Last Name</th><td>" + lname + "</td></tr>");
                                        out.println("<tr><th>Mobile</th><td>" + mobile + "</td></tr>");
                                        out.println("<tr><th>Email</th><td>" + email + "</td></tr>");
                                        out.println("<tr><th>Check-In</th><td>" + checkin + "</td></tr>");
                                        out.println("<tr><th>Check-Out</th><td>" + checkout + "</td></tr>");
                                        out.println("<tr><th>Adults</th><td>" + adult + "</td></tr>");
                                        out.println("<tr><th>Kids</th><td>" + kid + "</td></tr>");
                                        out.println("<tr><th>Room Name</th><td>" + roomName + "</td></tr>");  // Updated field
                                        out.println("<tr><th>Number of Rooms</th><td>" + numRooms + "</td></tr>");
                                        out.println("</table>");
                                        
                                        // Add Edit and Delete buttons
                                        out.println("<form action='editBooking.jsp' method='POST'>");
                                        out.println("<input type='hidden' name='id' value='" + bookingId + "' />");
                                        out.println("<button type='submit' class='btn btn-warning'>Edit</button>");
                                        out.println("</form>");
                                        
                                        out.println("<form action='deleteBooking.jsp' method='get'>");
                                        out.println("<input type='hidden' name='id' value='" + bookingId + "' />");
                                        out.println("<button type='submit' class='btn btn-danger'>Cancel Booking</button>");
                                        out.println("</form>");
                                    } else {
                                        out.println("<div class='alert alert-danger text-center'>Failed to make the booking. Please try again.</div>");
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<div class='alert alert-danger text-center'>Error: " + e.getMessage() + "</div>");
                                } finally {
                                    try {
                                        if (stmt != null) stmt.close();
                                        if (conn != null) conn.close();
                                    } catch (SQLException se) {
                                        se.printStackTrace();
                                    }
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer Section Start -->
    <div id="footer" class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center">
                    <div class="social mb-3">
                        <a href="https://instagram.com/yourprofile" target="_blank"><i class="fa fa-instagram mx-2"></i></a>
                        <a href="https://twitter.com/yourprofile" target="_blank"><i class="fa fa-twitter mx-2"></i></a>
                        <a href="https://facebook.com/yourprofile" target="_blank"><i class="fa fa-facebook-f mx-2"></i></a>
                    </div>
                    <ul class="nav justify-content-center">
                        <li class="nav-item"><a class="nav-link text-white" href="#">Home</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#">About</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#">Terms</a></li>
                        <li class="nav-item"><a class="nav-link text-white" href="#">Contact</a></li>
                    </ul>
                    <p class="mt-3">&copy; <a href="https://htmlcodex.com" class="text-white">HTML Codex</a> All Rights Reserved.</p>
                </div>
            </div>
        </div>
    </div>
    <!-- Footer Section End -->

    <a href="#" class="back-to-top"><i class="fa fa-chevron-up"></i></a>

    <!-- Vendor JavaScript Files -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="vendor/slick/slick.min.js"></script>
    <script src="vendor/tempusdominus/js/moment.min.js"></script>
    <script src="vendor/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

    <!-- Main Javascript File -->
    <script>
        $(document).ready(function () {
            $('#checkin').datetimepicker({
                format: 'YYYY/MM/DD' // Set to year/month/day format
            });
            $('#checkout').datetimepicker({
                format: 'YYYY/MM/DD', // Set to year/month/day format
                useCurrent: false // Important for "Check-Out" field to be after "Check-In"
            });

            $("#checkin").on("change.datetimepicker", function (e) {
                $('#checkout').datetimepicker('minDate', e.date); // Ensure checkout is after check-in
            });
        });
    </script>
</body>

</html>
