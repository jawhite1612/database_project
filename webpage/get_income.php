<head>
<title>Income</title>
 </head>
 <body>
    <div id="chartContainer" style="height : 370px; width: 50%;"></div>
    <script type="text/javascript" src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
<?php

    include 'open.php';

    ini_set('error_reporting', E_ALL); // report errors of all types
    ini_set('display_errors', true);   // report errors to screen (don't hide from user)

    $x = array();
    $y = array();
    $r = array();
    if ($mysqli->multi_query("CALL GetIncome();")) {

        // Check if a result was returned after the call
        if ($result = $mysqli->store_result()) {

            $row = $result->fetch_row();
	    $turn = -1;
            if (strcmp($row[0], 'ERROR: ') == 0) {
                printf("ERROR!");
            } else {
                do {
		   
                    for($i = 0; $i < sizeof($row); $i++){
		    $turn = $turn + 1;
		    	   if ($turn == 0) {
                            array_push($x, $row[$i]);
            		    }
            		    else if ($turn == 1){
                            array_push($y, $row[$i]);
            		    } else {
			    array_push($r, $row[$i]);
			    $turn = -1;
			    }
                    }
                } while($row = $result->fetch_row());
            }
            $result->close();
        }

	echo "<script type = 'text/javascript' src='bar_graph.js'></script>";
        echo "<script type='text/javascript'>var x = ".json_encode($x)."; var y = ".json_encode($y)."; var r = ".json_encode($r).";createGraph(x,y,r);</script>";

    } else {
            printf("<br>Error: %s\n", $mysqli->error);
    }

    mysqli_close($mysqli);

     ?>
 </body>
