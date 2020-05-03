 <head>
 <title>Income</title>
 </head>
 <body>
 <div id="chartContainer" style="height : 370px; width: 50%;"></div>
 <?php

include 'open.php';

ini_set('error_reporting', E_ALL); // report errors of all types
ini_set('display_errors', true);   // report errors to screen (don't hide from user)

$x = array();
$y = array();
if ($mysqli->multi_query("CALL GetIncome();")) {

    // Check if a result was returned after the call
    if ($result = $mysqli->store_result()) {

        $row = $result->fetch_row();

        if (strcmp($row[0], 'ERROR: ') == 0) {
            printf("ERROR!");
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

    echo "<script type='text/javascript' src='bar_graph.js'>var x = ".json_encode($x)."; var y = ".json_encode($y)."; createGraph();</script>";

} else {
        printf("<br>Error: %s\n", $mysqli->error);
}

mysqli_close($mysqli);

 ?>
 </body>
