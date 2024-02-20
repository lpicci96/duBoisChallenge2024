function aspectWidth (height) {
    // 1584x2016
    const aspRatio = 1584/2016
  
    return height * aspRatio
  
  }



  d3.csv("data.csv").then(function(dataArr) {

    dataArr = dataArr.map(row => ({...row, value: +row.value,}))
    console.log(dataArr);
  
    
    const height = 650;
    const width =  aspectWidth(height) - 35
    const margin = {left: 20, right: 70, top: 35, bottom: 20};
  
    const svg = d3.select("#viz").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .style("background-color", "#f0e4d5");
  
    const g = svg
      .append("g")
      .attr("transform", `translate(${margin.left}, ${margin.top})`);
  
    const yScale = d3.scaleLinear()
      .domain(d3.extent(dataArr, (d, i) => i))
      .range([35, height-60]);
  
    const xScale = d3.scaleLinear()
      .domain([0, d3.max(dataArr, d=> d.value)])
      .range([31, width-40]);
  
    const yearBand = d3.scaleBand()
      .domain(dataArr.map(d => d.year))
      .range([0, height-60])
      // .paddingOuter(0.2)
      .paddingInner(0.5)
      .align(0.5);
    
    g.append("g")
    .selectAll("rect")
    .data(dataArr)
    .join("rect")
    .attr("x", xScale(0))
    .attr("y", (d, i) => yScale(i))
    .attr("width", d=> xScale(d.value))
    .attr("height", (d, i) => yearBand.bandwidth())
    .attr("fill", "#ef405a");
  
    g.append("g")
    .selectAll("text")
    .data(dataArr)
    .join("text")
    .text(d => d.year)
    .attr("x", 0)
    .attr("y", (d,i) => yScale(i) + yearBand.bandwidth()/1.15)
    .attr("font-size", "12px")
    .attr("fill", "#958475");
  
    g.append("g")
    .selectAll("text")
    .data(dataArr
          .map((d, i) => ({ ...d, index: i }))
          .filter(d => d3.extent(dataArr, x => x.year).includes(d.year)))
    .join("text")
    .text(d => d.value.toLocaleString())
    .attr("x", d=> xScale(d.value /2))
    .attr("y", (d) => yScale(d.index) + yearBand.bandwidth()/1.15)
    .attr("font-size", "12px")
      .attr("font-weight", "bold");
  
    g.append("text")
      .attr("x", width / 2 + 30)
      .attr("y", 12) 
      .attr("text-anchor", "middle") 
      .style("font-size", "16px") 
      .text("ACRES OF LAND OWNED BY NEGORES")
      .style("fill", "#413528")
      .style("font-weight", "bold");
    
    g.append("text")
      .attr("x", width / 2 + 30) 
      .attr("y", 30) 
      .attr("text-anchor", "middle") 
      .style("font-size", "16px") 
      .text("IN GEORGIA.")
      .style("fill", "#413528")
      .style("font-weight", "bold");
  
    g.append("text")
    .attr("x", width) 
      .attr("y", height-14) 
      .attr("text-anchor", "end") 
      .style("font-size", "12px") 
      .text("#DuBoisChallenge2024")
      .style("fill", "#413528")
  
    g.append("text")
    .attr("x", width) 
      .attr("y", height) 
      .attr("text-anchor", "end") 
      .style("font-size", "12px") 
      .text("Chart by Luca Picci @lpicci96")
      .style("fill", "#413528")
  
    return svg.node()
    
  });


