<?php
	function getDemographics($state, $mysqli) {

	   	echo "<script type = 'text/javascript' src='pie_graph.js'></script>";

	   	$arrays = array();
		for ($i = 0; $i < 9; $i++) {
			array_push($arrays, array());
		}
		
		$queryNum = 0;
	    if ($mysqli->multi_query("CALL GetStateIncome('%'); CALL GetStateDemographics('".$state."%');")) {
	        do {
	            if ($result = $mysqli->store_result()) {

	                $row = $result->fetch_row();
	                
	                if (strcmp($row[0], 'ERROR: ') == 0) {
	                    printf("ERROR!");
	                } else {
	                    do {
	                        for($i = 0; $i < sizeof($row); $i++){
	                            array_push($arrays[$i], $row[$i]);
	                        }
	                    } while($row = $result->fetch_row());
	                }
	                $result->close();
	            }
	            if ($queryNum == 0) {
	                echo "<script>";
	                	echo "var x = ".json_encode($arrays[0]).";";
	                	echo "var y = ".json_encode($arrays[1]).";";
	                	echo "var r = ".json_encode($arrays[2]).";";
	                	echo "var temp = getAverage(x, y, r);";
	                    echo "setStatePartyColors(temp[0], temp[2]);";
	                echo "</script>";
	                $arrays = array();
					for ($i = 0; $i < 9; $i++) {
						array_push($arrays, array());
					}
					$queryNum += 1;
            	} 
	        } while ($mysqli->next_result());
	    } 

	    mysqli_close($mysqli);

	   	echo "<script>createPieGraph(".json_encode($arrays).");</script>";
	}

?>
