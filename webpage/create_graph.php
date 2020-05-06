<head>
<title>Income</title>
<style> 

    .data {
        display: inline-block;
    }

    #chartContainer {

    }

    #tableContainer {
        overflow: scroll;
        overflow-x: hidden; 
        margin-top: 80px;
        
    }

    #tableContainer table {
        display: flex;
        align-items: center;
        justify-content: center;
        margin: auto;
        margin-left: 50px;

    }

    .container {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        margin-left: auto;
    }

    form {
        margin-left: 200px;
        margin-top: 80px;
        margin-bottom: -70px;
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
        margin-top: 50px;
        margin-bottom: -200px;
        margin-left: 175px;
    }

 .container2 {
    margin-bottom: 150px;
    margin-left: -50px;
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
        var states = {
            'AK': 'Alaska',
            'AL': 'Alabama',
            'AR': 'Arkansas',
            'AZ': 'Arizona',
            'CA': 'California',
            'CO': 'Colorado',
            'CT': 'Connecticut',
            'DC': 'District of Columbia',
            'DE': 'Delaware',
            'FL': 'Florida',
            'GA': 'Georgia',
            'HI': 'Hawaii',
            'IA': 'Iowa',
            'ID': 'Idaho',
            'IL': 'Illinois',
            'IN': 'Indiana',
            'KS': 'Kansas',
            'KY': 'Kentucky',
            'LA': 'Louisiana',
            'MA': 'Massachusetts',
            'MD': 'Maryland',
            'ME': 'Maine',
            'MI': 'Michigan',
            'MN': 'Minnesota',
            'MO': 'Missouri',
            'MS': 'Mississippi',
            'MT': 'Montana',
            'NA(Avg)': 'National (Average)',
            'NA(All)': 'National (All)',
            'NC': 'North Carolina',
            'ND': 'North Dakota',
            'NE': 'Nebraska',
            'NH': 'New Hampshire',
            'NJ': 'New Jersey',
            'NM': 'New Mexico',
            'NV': 'Nevada',
            'NY': 'New York',
            'OH': 'Ohio',
            'OK': 'Oklahoma',
            'OR': 'Oregon',
            'PA': 'Pennsylvania',
            'PR': 'Puerto Rico',
            'RI': 'Rhode Island',
            'SC': 'South Carolina',
            'SD': 'South Dakota',
            'TN': 'Tennessee',
            'TX': 'Texas',
            'UT': 'Utah',
            'VA': 'Virginia',
            'VT': 'Vermont',
            'WA': 'Washington',
            'WI': 'Wisconsin',
            'WV': 'West Virginia',
            'WY': 'Wyoming'
        }

        $(document).ready(function() {
             $('#map').usmap({
              click: function(event, data) {
                var option = $('#state').val(states[data.name].toLowerCase().replace(" ", "_"));
                $("#stateAbrev").val(data.name);
                $('#form').submit();
              }
            });

        });

        function addStates() {
            var stateNames = [];
            stateNames.push('National (All)');
            stateNames.push('National (Average)');
            for (var key in states) {
                if (key != "NA(Avg)" && key !== "NA(All)") {
                        stateNames.push(states[key]);
                    }
            }
            console.log(stateNames)
            for (var state in stateNames) {
                $("<option></option>", {
                    text: stateNames[state],
                    value: stateNames[state]
                }).appendTo("#stateSelect");
            }
        }

        function getInputsByValue(select, value)
        {
            var allInputs = document.getElementsByTagName("option");
            var results = [];
            for(var x=0;x<allInputs.length;x++)
                if(allInputs[x].value == value) {
                    document.getElementById(select).value = allInputs[x].value;
                }
        }

        function changeState() {
            var state = $('#stateSelect').val();
            for (var key in states) {
                if (states[key] == state) {
                    var option = $('#state').val(states[key].toLowerCase().replace(" ", "_"));
                    $("#stateAbrev").val(key);
                    $('#form').submit();
                }
            }
        }

    </script>
    <form id="form" name='form' action="create_graph.php" method="POST">
      Value Type: <select id="options" name="options" onchange="this.form.submit()" value="Income">
        <option value="Income">Get Income</option>
        <option value="PovertyRate">Get Poverty Rate</option>
      </select>
      Sort by: <select id="sort" name="sort" onchange="this.form.submit()" value="Sort by Alpha">
      	<option value="0" id="Alpha">Alpha</option>
        <option value="1">Value</option>
        <option value="2">Party</option>
      </select>
      <input id="state" name="state" style='display: none' value = "national_(average)">
      <input id="stateAbrev" name="stateAbrev" style='display: none' value = "NA(Avg)" >
      State: <select id="stateSelect" name="states" onchange="changeState()" value ="National (Average)">
      </select>
    </form> 
    <div class="container">
        <div id="chartContainer" style="height : 500px; width: 900px;"></div>
        <div class="container2">
        <div id="map" style="width: 50%; height: 300px;"></div>
        <div id="tableContainer" style="height : 370px; width: 500px;">
            <table id="table"> 
                <tr>
                    <th> State </th>
                    <th> Value </th>
                    <th> Ratio </th>
                </tr>
            </table>
        </div>
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
    $state = $_POST['state'];
    $abrev = $_POST['stateAbrev'];
    $temp_option = $option;

    echo "<script>";
        echo "getInputsByValue('options','".$option."');";
        echo "getInputsByValue('sort','".$sort."');";
        echo "addStates();";
        echo "document.getElementById('state').value = '".$state."';";
        echo "document.getElementById('stateAbrev').value = '".$abrev."';";
        echo "document.getElementById('stateSelect').value = states['".$abrev."'];";
        echo "if ($('#stateSelect').val() == 'National (All)') { $('#Alpha').css('display','none');";
        echo "if ($('#sort').val() == 0) { $('#sort').val('1')}}";
    echo "</script>";
    
    if ($abrev != "NA(Avg)" && $abrev != "NA(All)") {
         $option = 'State'.$option."('".$state."%')"; 
    } else if ($abrev == 'NA(Avg)') {
          $option = $option."()";
    } else if ($abrev == 'NA(All)') {
         $option = 'State'.$option."('%')";   
    }

    if ($mysqli->multi_query("CALL Get".$option.";")) {

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

    if (strpos('national', $state) === false)  {
         $option = $temp_option." (".$abrev.")";  
    } else {
         $option = $temp_option." ".$state."";  
    }

	echo "<script type = 'text/javascript' src='bar_graph.js'></script>";
    echo "<script type='text/javascript'>";
        echo "var x = ".json_encode($x).";";
        echo "var y = ".json_encode($y).";";
        echo "var r = ".json_encode($r).";";
        echo "var sort = ".json_encode($sort).";";
        echo "var state = ".json_encode($state).";";
        echo "createList(state, x,y,r);";
        echo "createGraph(".json_encode($option).",state,x,y,r,sort);";
    echo "</script>";


    } else {
            printf("Choose a graph above!");
    }

    mysqli_close($mysqli);
?>
</body>
