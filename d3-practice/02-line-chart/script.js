
data1 = [
    { date: new Date(2025, 9, 20), value: 203 },
    { date: new Date(2025, 9, 21), value: 206 },
    { date: new Date(2025, 9, 23), value: 209 },
    { date: new Date(2025, 9, 24), value: 207 },
    { date: new Date(2025, 9, 25), value: 216 },
]
data2 = [
    { date: new Date(2025, 9, 20), value: 213 },
    { date: new Date(2025, 9, 21), value: 216 },
    { date: new Date(2025, 9, 23), value: 199 },
    { date: new Date(2025, 9, 24), value: 202 },
    { date: new Date(2025, 9, 25), value: 203 },
]

// Dimensions
const width = 500;
const height = 300;
const margin = { top: 20, right: 20, bottom: 30, left: 40 };
const innerWidth = width - margin.left - margin.right;
const innerHeight = height - margin.top - margin.bottom;

const svg = d3.select("#line-chart")
    .append("svg")
    .attr("width", width)
    .attr("height", height)

const gRoot = svg.append("g")
    .attr("transform", `translate(${margin.left}, ${margin.top})`);

// Declare range for scales
const xScale = d3.scaleTime()
    .range([0, innerWidth])

const yScale = d3.scaleLinear()
    .range([innerHeight, 0])

// Create axis groups
const gXAxis = gRoot.append("g")
    .attr("class", "axis-x")
    .attr("transform", `translate(0, ${innerHeight})`);
const gYAxis = gRoot.append("g")
    .attr("class", "axis-y");
const gChart = gRoot.append("g")
    .attr("class", "chart");

// Line generator
const line = d3.line()
    .x(d => xScale(d.date))
    .y(d => yScale(d.value))


function updateLineChart(data){
    // Update axes
    xScale.domain(d3.extent(data, d => d.date));
    yScale.domain(d3.extent(data, d => d.value));

    // Create axes themselves
    gXAxis.call(d3.axisBottom(xScale));
    gYAxis.call(d3.axisLeft(yScale).ticks(6));

    // Now we need to bind our data to a <path> element using the generator
    const graph = gChart.selectAll(".data-line")
        .data([data]) // Using [data] here select ONE line bound to our entire array
        .join(  // .join() is where we put our enter/update/exit pattern
            enter => enter.append("path")
                .attr("class", "data-line") // makes future .selectAll() calls work
                .attr("stroke", "skyblue")
                .attr("stroke-width", 2)
                .attr("fill", "none")
                .attr("d", line),

            update => update   // receives the existing "path"
                .transition()  // we can chain transition().duration() to animate updates
                .duration(200)
                .attr("d", line), // then of course need to update the data as well

            exit => exit.remove()
        );
}


document.addEventListener('click', (e) => {
    if (e.target.closest('.options')) {
        if (e.target.dataset.set === '1') {
            updateLineChart(data1);
        } else if (e.target.dataset.set === '2') {
            updateLineChart(data2);
        }
    }
});