// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

var nonce_1 = 0;
var nonce_2 = 0;
var nonce_3 = 0;
var nonce_4 = 0;
for(var i=0; i<4; i++){
  switch(i){
    case 0:
    nonce_1 = transfer_data[i].nonce;
    break;
    case 1:
    nonce_2 = transfer_data[i].nonce;
    break;
    case 2:
    nonce_3 = transfer_data[i].nonce;
    break;
    case 3:
    nonce_4 = transfer_data[i].nonce;
    break;
  }
  // console.log(transfer_data[i].nonce);
  console.log(nonce_1, nonce_2, nonce_3);
}

var ctx = document.getElementById('lineChart').getContext('2d');
var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: 'line',

    // The data for our dataset
    data: {
        labels: ["Block3", "Block2", "Block1", "Genesis Block"],
        datasets: [{
            label: "Nonce Data",
            // backgroundColor: 'rgb(255, 99, 132)',
            borderColor: 'rgb(255, 99, 132)',
            data: [nonce_1, nonce_2, nonce_3, nonce_4],
        }]
    },

    // Configuration options go here
    options: {}
});
