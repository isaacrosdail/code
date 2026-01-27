// ===== NEXT UP =====
/* 1. Hover effect (slice pops out on mouseover)
        - Slightly shift arc position on hover using trigonometry and existing arc angles
   2. Legend outside the pie
        - Generate a <g> for each category with colored square + text
   3. Labels placed outside the pie with leader lines
        - How to move label positions outward using arc.centroid() as a starting point, and avoid collisions
*/


/* What we should know thus far:
    - How .data() binds arrays to SVG elements
    - Why .data(..., d => key) matters (stable matching across updates)
    - How .join() handles enter / update / exit in one place
    - What .attrTween() + this._current actually do (animate old → new)
    - How labels use .centroid() to position themselves in the middle of slices
*/


// ===== Two separate datasets to transition between
const dataSet1 = [
    { category: "Coding", value: 120 },
    { category: "Exercise", value: 30 },
    { category: "Reading", value: 60 },
];
const dataSet2 = [
    { category: "Coding", value: 80 },   // Coding shrinks
    { category: "Reading", value: 100 }, // Reading increases
    { category: "Gaming", value: 40 },   // NEW category appears
    // Exercise disappears
];
// =====

// ===== Basic SVG dimensions
const width = 300;
const height = 300;
const radius = Math.min(width, height) / 2;


// ===== Create <svg> & Center Group (g)
const svg = d3.select('#time-chart') // Select container div
    .append("svg")                   // Add <svg> element
    .attr("width", width)
    .attr("height", height)
    .append("g")                     // Add group to shift origin to chart center
    .attr("transform", `translate(${width/2}, ${height/2})`);

// ---------- 4. PIE GENERATOR: CONVERT VALUES TO ANGLES ----------
const pie = d3.pie()
    .value(d => d.value); // For each datum, use `value` to determine slice size

// ---------- 5. ARC GENERATOR: TURNS ANGLES INTO PATH COMMANDS ----------
const arc = d3.arc()
    .innerRadius(0)         // 0 = solid pie (no donut hole)
    .outerRadius(radius);   // Full size of the pie

// ---------- 6. COLOR SCALE (CATEGORY → COLOR) ----------
const color = d3.scaleOrdinal(d3.schemeCategory10);
// Using `category` as the key keeps colors consistent when data changes


// Initial render of chart
updatePieChart(dataSet1);

// ---------- 8. BUTTON CLICK HANDLER ----------
document.addEventListener('click', (e) => {
    if (!e.target.matches('button')) return;
    const which = e.target.dataset.set;
    if (which === '1') updatePieChart(dataSet1);
    if (which === '2') updatePieChart(dataSet2);
});

// Main render & update function
function updatePieChart(data) {
    // 1. Convert raw data -> angles/shapes via pie()
    // Each item becomes: { startAngle, endAngle, value, data: {category, value} }
    const pieData = pie(data);

    // Update pie slices
    const piePaths = svg.selectAll("path")   // Select existing <path> elements (if any)
        .data(pieData, d => d.data.category) // Bind data; key by category for stable matching
        .join(
            // ENTER: New slices for new categories
            enter => enter.append('path')
                        .attr("class", "pie tooltip")
                        .attr("fill", d => color(d.data.category)) // stable color: keys color of slices to category to keep consistency across transitions
                        .each(function(d) { this._current = d; }) // store start?
                        .attr("d", arc)
                        .on('mouseenter', function(event, d) {
                            // Have access to d.startAngle and d.endAngle
                            const rawMidpoint = (d.startAngle + d.endAngle) / 2;
                            // NOTE: D3's 0deg point is at 12 o'clock, because of course it is
                            // Meaning 0 radians is up, not right
                            // So we need to adjust by -(Math.PI/2)
                            const midpoint = rawMidpoint - Math.PI / 2;
                            const dist = radius / 10;
                            console.log(`Midpoint: ${midpoint} radians, distance: ${dist}`);

                            // Calc new x, y positions
                            const x = Math.cos(midpoint) * dist;
                            const y = Math.sin(midpoint) * dist;
                            console.log(`x: ${x}, y: ${y}`);

                            d3.select(this)
                                .transition().duration(200)
                                .attr("transform", `translate(${x}, ${y})`);
                        })
                        .on('mouseleave', function(event, d) {
                            d3.select(this)
                                .transition().duration(200)
                                .attr("transform", `translate(0, 0)`);
                        }),
            // UPDATE: Existing slices get animated to new positions/sizes
            update => update.transition().duration(500)
                .attrTween("d", function(d) {
                    const i = d3.interpolate(this._current, d);
                    this._current = i(1);
                    return t => arc(i(t));
                }),
            // EXIT: Remove slices that don't exist in the new dataset
            exit => exit.remove()
        )

    // Text labels within each slice
    const labels = svg.selectAll("text")
        .data(pieData, d => d.data.category) // same key as paths for alignment
        .join(
            // ENTER: Add new label for new slice
            enter => enter.append("text")
                        .attr("class", "pie-label")
                        .attr("text-anchor", "middle")
                        .attr("alignment-baseline", "middle")
                        .text(d => `${d.data.category} (${d.data.value})`)
                        .attr("transform", d => `translate(${arc.centroid(d)})`), // Position at slice center
            // UPDATE: Move label to new slice position
            update => update.transition().duration(500)
                        .attr("transform", d => `translate(${arc.centroid(d)})`)
                        .text(d => `${d.data.category} (${d.data.value})`),
            // EXIT: Remove labels for removed slices
            exit => exit.remove()
        )
}