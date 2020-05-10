<?php
	function getDemographics($state, $mysqli) {

		$arrays = array();

		for ($i = 0; $i < 9; $i++) {
			array_push($arrays, array());
		}

	    if ($mysqli->multi_query("CALL GetStateDemographics('".$state."%');")) {
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

	        } while ($mysqli->next_result());
	    } 

	    mysqli_close($mysqli);

	   	echo "<script type = 'text/javascript' src='pie_graph.js'></script>";
	   	echo "<script>createPieGraph(".json_encode($arrays).");</script>";
	}

?>
