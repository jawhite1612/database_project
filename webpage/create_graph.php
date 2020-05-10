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
                $('#form').submit()
              },
            });
        });

        function getStateColor(y, min, max, good) {
            var diff = max - min;
            var ratio = ((y - min)/diff)
            var color = '';
            return {fill: "green", opacity: ((ratio - .005) / .995)}
        }

        function setStateColors(x, y, r) {
            var stateValues = {}
            var minVal  = Number.MAX_VALUE;
            var maxVal = Number.MIN_VALUE;
            for (var i = 0; i < x.length; i++) {
                stateValues[x[i]] = y[i];
                minVal = minVal > y[i] ? y[i] : minVal;
                maxVal = maxVal < y[i] ? y[i] : maxVal;
            }


            var stateColors = {}
            for (var key in states) {
                if (!key.includes('NA')) {
                    stateColors[key] = getStateColor(stateValues[states[key]], minVal, maxVal);
                }
            }
            $('#map').usmap({
              stateSpecificStyles:stateColors,
              click: function(event, data) {
                var option = $('#state').val(states[data.name].toLowerCase().replace(" ", "_"));
                $("#stateAbrev").val(data.name);
                $('#form').submit()
              },
            });    
        }

        function addStates() {
            var stateNames = [];
            stateNames.push('National (All)');
            stateNames.push('National (Average)');
            for (var key in states) {
                if (key != "NA(Avg)" && key !== "NA(All)") {
                        stateNames.push(states[key]);
                    }
            }
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

        function getAverage(x, y, r) {

            var prev = x[0].substring(0, x[0].indexOf('1'));
            var stateAverages = {}
            var districtCount = 0;

            var tempX = []
            var tempY = []
            var tempR = []

            stateAverages[prev] = [];
            stateAverages[prev][0] = 0;
            stateAverages[prev][1] = 0;
            tempX[0] = prev;
            for (var i = 0; i < x.length; i++) {
                
                if (x[i] == "districtID") {
                    continue;
                }

                if (x[i].includes(prev) == false) {
                    tempY.push(parseInt(stateAverages[prev][0] / districtCount));
                    tempR.push(parseFloat(stateAverages[prev][1] / districtCount));

                    prev = x[i].substring(0, x[i].indexOf('1'));
                    tempX.push(prev);

                    districtCount = 0;
                    stateAverages[prev]  = [];
                    stateAverages[prev][0] = 0;
                    stateAverages[prev][1] = 0;
                }

                stateAverages[prev][0] += parseFloat(y[i]);
                stateAverages[prev][1] += parseFloat(r[i]);
                districtCount += 1;
            }
            tempY.push(parseInt(stateAverages[prev][0] / districtCount));
            tempR.push(parseFloat(stateAverages[prev][1] / districtCount));

            for (var i = 0; i < tempX.length; i++) {
                var splitStr = tempX[i].replace("_", " ").toLowerCase().split(' ');
                for (var j = 0; j < splitStr.length; j++) {
                   splitStr[j] = splitStr[j].charAt(0).toUpperCase() + splitStr[j].substring(1);     
                }
                tempX[i] = splitStr.join(' '); 
            }

            return [tempX, tempY, tempR];
        }

    </script>
    <form id="form" name='form' action="create_graph.php" method="POST">
      Value Type: <select id="options" name="options" onchange="this.form.submit()" value="Income">
        <option value="MedianIncome">Get Median Income</option>
	<option value="PovertyRate">Get Poverty Rate</option>
        <option value="UnemploymentRate">Get Unemployment Rate</option>
    	<option value="PercentWithoutHealthInsurance">Get Percent Without Health Insurance</option>
    	<option value="PercentBachelorsOrHigher">Get Percent Bachelors or Higher</option>
    	<option value="MedianHomeValue">Get Median Home Value</option>
    	<option value="MedianRent">Get Median Rent</option>
    	<option value="PercentMortgagedUnits">Get Percent Mortgaged Units</option>
    	<option value="AverageCommute">Get Average Commute</option>
    	<option value="PercentMinority">Get Percent Minority</option>
    	<option value="PercentForeignBorn">Get Percent Foreign Born</option>
        <option value="Demographics">Get State Demographics</option>
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
    <p>Data obtained from <a target="_blank" href=https://dataverse.harvard.edu/dataverse/medsl/>MIT Election Data and Science Lab: Election Data</a> and 
	<a target="_blank" href=https://www.census.gov/mycd/>US Census: My Congressional District</a></p>
<?php
    include 'open.php';

    ini_set('error_reporting', E_ALL); // report errors of all types
    ini_set('display_errors', true);   // report errors to screen (don't hide from user)

    $option = $_POST['options'];
    $sort = $_POST['sort'];
    $state = $_POST['state'];
    $abrev = $_POST['stateAbrev'];
    $temp_option = $option;
    $createdGraph = false;

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

    $x = array();
    $y = array();
    $r = array();

    if ($abrev == "NA(Avg)" || $abrev == "NA(All)") {
        $state = "";
    }

    if($option == 'Demographics') {
        require_once('pie_graph.php');
        getDemographics($state, $mysqli);
        $createGraph = true; 
    }

    $queryNum = 0;
    if ($createGraph == false && $mysqli->multi_query('CALL GetState'.$option."('%'); CALL GetState".$option."('".$state."%')")) {
        do {
            if ($result = $mysqli->store_result()) {

                $row = $result->fetch_row();
                
                if (strcmp($row[0], 'ERROR: ') == 0) {
                    printf("ERROR!");
                } else {
                    do {
                        for($i = 0; $i < sizeof($row); $i++){
                            if ($i == 0) {
                                array_push($x, $row[$i]);
                            }
                            else if ($i == 1){
                                array_push($y, $row[$i]);
                            } else if ($i == 2) {
                                array_push($r, $row[$i]);
                            }
                        }
                    } while($row = $result->fetch_row());
                }
                $result->close();
            }

            if ($queryNum == 0) {
                echo "<script>";
                    echo "var x = ".json_encode($x).";";
                    echo "var y = ".json_encode($y).";";
                    echo "var r = ".json_encode($r).";";
                    echo "var temp = getAverage(x,y,r);"; 
                    echo "x = temp[0];"; 
                    echo "y = temp[1];"; 
                    echo "r = temp[2];";
                    echo "setStateColors(x, y, r)";
                echo "</script>";
                $x = array();
                $y = array();
                $r = array();
            } 
            
            $queryNum +=1;

        } while ($mysqli->next_result());

        if (strpos('national', $state) === false)  {
            $option = $temp_option." (".$abrev.")";  
        } else {
            $option = $temp_option." ".$state."";  
        }

        echo "<script type = 'text/javascript' src='bar_graph.js'></script>";
        echo "<script type='text/javascript'>";
            echo "console.log(".json_encode($x).");";
            echo "var x = ".json_encode($x).";";
            echo "var y = ".json_encode($y).";";
            echo "var r = ".json_encode($r).";";
            echo "var sort = ".json_encode($sort).";";
            echo "var state = ".json_encode($state).";";
            if ($abrev == 'NA(Avg)') {
               echo "var temp = getAverage(x,y,r);"; 
               echo "x = temp[0];"; 
               echo "y = temp[1];"; 
               echo "r = temp[2];"; 
            }
            echo "createList(state, x,y,r);";
            echo "createGraph(".json_encode($option).",state,x,y,r,sort);";
        echo "</script>";

    } else {
        printf("Choose a graph above!");
    }

    mysqli_close($mysqli);

?>
</body>
