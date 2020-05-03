 <head>
 <title>Income</title>
 </head>
 <body>
<script type="text/javascript" src="bar_graph.js"></script>
<div id="chartContainer" style="height : 370px; width: 50%;"></div>
 <?php


// Open a database connection
// The call below relies on files named open.php and dbase-conf.php
// It initializes a variable named $mysqli, which we use below
include 'open.php';

// Configure error reporting settings
ini_set('error_reporting', E_ALL); // report errors of all types
ini_set('display_errors', true);   // report errors to screen (don't hide from user)

// Collect the data input posted here from the calling page
// The associative array called S_POST stores data using names as indices

// Call the stored procedure named ShowRawScores
// "multi_query" executes given (multiple-statement) MySQL query
// It returns true if first statement executed successfully; false otherwise.
// Results of first statement are retrieved via $mysqli->store_result()
// from which we can call ->fetch_row() to see successive rows
if ($mysqli->multi_query("CALL GetIncome();")) {

    // Check if a result was returned after the call
    if ($result = $mysqli->store_result()) {

        $row = $result->fetch_row();
	$x = array();
	$y = array();
        // If the first row of result begins with 'ERROR: ', then our
        // stored procedure produced a relation that indicates error(s)
        if (strcmp($row[0], 'ERROR: ') == 0) {
            echo "<tr><th> Result </th></tr>";
            do {
                echo "<tr><td>" ;
                for($i = 0; $i < sizeof($row); $i++){
                    echo $row[$i];
                }
                echo "</td></tr>";
            } while ($row = $result->fetch_row());

        } else {

            do {
                for($i = 0; $i < sizeof($row); $i++){
		    if ($i%2 == 0) {
                       array_push($x, $row[$i]);
		    }
		    else {
		       array_push($y, $row[$i]);
		    }
                }
            } while($row = $result->fetch_row());
        }
        $result->close();
    }
    echo "<script>console.log('$x')</script>";
    echo "<script type='text/javascript'>createGraph('$x', '$y');</script>";
// The "multi_query" call did not end successfully, so report the error
// This might indicate we've called a stored procedure that does not exist,
// or that database connection is broken
} else {
        printf("<br>Error: %s\n", $mysqli->error);
}

// Close the connection created above by including 'open.php' at top of this file
mysqli_close($mysqli);


 ?>
 </body>
