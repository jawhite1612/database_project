<head>
<title>Income</title>
<style> 

    .data {
        display: inline-block;
    }

    #chartContainer {
        display: inline-block;
    }

    #tableContainer {
        display: inline-block;
        overflow: scroll;
        overflow-x: hidden; 
        
    }

    #tableContainer table {
        display: flex;
        align-items: center;
        justify-content: center;
        margin: auto;

    }

    .container {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        margin: auto;
    }

    form {
        margin-left: 200px;
        margin-top: 10px;
    }

    td {
        border-color: black;
        border-width: 1px;
        border-style: solid;
    }

    th {
        text-align: left
    }

    #map {
        margin-top: 20px;
        margin: auto;
        margin-bottom: -100px;
    }
</style>
 </head>
 <body>
    <script type="text/javascript" src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
    <script type = "text/javascript" src="bar_graph.js"></script>
    <script src="../map/lib/raphael.js"></script>
    <script src="../map/us-map.js"></script>
    <script type="text/javascript">

        $(document).ready(function() {
             $('#map').usmap({
              click: function(event, data) {
                console.log(data.name);
              }
            });
        });


        function getInputsByValue(select, value)
        {
            var allInputs = document.getElementsByTagName("option");
            var results = [];
            for(var x=0;x<allInputs.length;x++)
                if(allInputs[x].value == value)
                    document.getElementById(select).value = allInputs[x].value;
        }

    </script>
    <div id="map" style="width: 300px; height: 300px;"></div>
    <form id="form" name='form' action="create_graph.php" method="POST">
      Value Type: <select id="options" name="options" onchange="this.form.submit()" value="GetIncome">
        <option value="Income">Get Income</option>
        <option value="PovertyRate">Get Poverty Rate</option>
      </select>
      Sort by: <select id="sort" name="sort" onchange="this.form.submit()" value="Sort by Alpha">
      	<option value="0">Alpha</option>
        <option value="1">Value</option>
        <option value="2">Party</option>
      </select>
    </form>
    <div class="container">
        <div id="chartContainer" style="height : 370px; width: 50%;"></div>
        <div id="tableContainer" style="height : 370px; width: 30%;">
            <table id="table"> 
                <tr>
                    <th> State </th>
                    <th> Value </th>
                    <th> Ratio </th>
                </tr>
            </table>
        </div>

    </div>
    <p>Add some information about the data here!</p>
<?php
    include 'open.php';

    ini_set('error_reporting', E_ALL); // report errors of all types
    ini_set('display_errors', true);   // report errors to screen (don't hide from user)

    $x = array();
    $y = array();
    $r = array();

    $option = $_POST['options'];
    $sort = $_POST['sort'];

    echo "<script>getInputsByValue('options','".$option."');</script>";
    echo "<script>getInputsByValue('sort','".$sort."');</script>";
    

    if ($mysqli->multi_query("CALL Get".$option."();")) {

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
    echo "<script type='text/javascript'>";
        echo "var x = ".json_encode($x).";";
        echo "var y = ".json_encode($y).";";
        echo "var r = ".json_encode($r).";";
        echo "var sort = ".json_encode($sort).";";
        echo "createList(x,y,r);";
        echo "createGraph(".json_encode($option).",x,y,r,sort);";
    echo "</script>";


    } else {
            printf("Choose a graph above!");
    }

    mysqli_close($mysqli);
?>
</body>
