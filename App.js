import React, { useState, useEffect, useRef } from 'react';
import axios from 'axios';
import * as d3 from 'd3';

// API base URL - change this to match your backend server
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

// Helper function to build tree structure
const buildTree = (flatData) => {
  const idMapping = flatData.reduce((acc, el) => {
    acc[el.NODE_ID] = { ...el, children: [] };
    return acc;
  }, {});

  const root = [];
  
  flatData.forEach(el => {
    // Handle the root element
    if (el.PARENT_ID === null) {
      root.push(idMapping[el.NODE_ID]);
      return;
    }
    
    // If parent exists in our mapping
    if (idMapping[el.PARENT_ID]) {
      idMapping[el.PARENT_ID].children.push(idMapping[el.NODE_ID]);
    }
  });
  
  return root[0]; // Return the root node
};

// Get node color based on status
const getNodeColor = (status) => {
  switch (status?.toLowerCase()) {
    case 'failed': return '#e74c3c'; // Red
    case 'completed': return '#27ae60'; // Green
    case 'running': return '#c8e6c9'; // Light green
    case 'queued': return '#ecf0f1'; // Light gray
    default: return '#ffffff'; // White
  }
};

// Get text color based on background
const getTextColor = (status) => {
  switch (status?.toLowerCase()) {
    case 'failed': return '#ffffff'; // White text on red
    case 'completed': return '#ffffff'; // White text on green
    default: return '#333333'; // Dark text on light backgrounds
  }
};

// Format date for display
const formatDate = (dateStr) => {
  if (!dateStr) return '';
  
  try {
    const date = new Date(dateStr);
    return date.toLocaleString(undefined, {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  } catch (e) {
    return dateStr; // Return original if parsing fails
  }
};

// Measure text width for dynamic node sizing
const getTextWidth = (text, fontSize = 14, fontFamily = 'Arial') => {
  const canvas = document.createElement('canvas');
  const context = canvas.getContext('2d');
  context.font = `${fontSize}px ${fontFamily}`;
  return context.measureText(text).width;
};

// Status Legend Component
const StatusLegend = () => {
  const statuses = [
    { status: 'running', label: 'Running' },
    { status: 'completed', label: 'Completed' },
    { status: 'queued', label: 'Queued' },
    { status: 'failed', label: 'Failed' }
  ];
  
  return (
    <div className="absolute top-2 right-2 bg-white px-3 py-2 border rounded-md shadow-sm flex items-center space-x-5 z-10">
      {statuses.map(item => (
        <div key={item.status} className="flex items-center">
          <div
            className="w-5 h-5 mr-2"
            style={{ backgroundColor: getNodeColor(item.status) }}
          ></div>
          <span className="text-sm font-medium">{item.label}</span>
        </div>
      ))}
    </div>
  );
};

// Simple Flowchart Component Without D3 Zoom
const SimpleFlowchart = ({ data, onNodeSelect }) => {
  const svgRef = useRef(null);
  const [tooltipInfo, setTooltipInfo] = useState(null);
  const [selectedNodeInChart, setSelectedNodeInChart] = useState(null);
  
  useEffect(() => {
    if (!data || !svgRef.current) return;
    
    // Clear previous chart
    const svgElement = svgRef.current;
    while (svgElement.firstChild) {
      svgElement.removeChild(svgElement.firstChild);
    }
    
    // Set dimensions
    const width = 1600;
    const height = 1000;
    svgElement.setAttribute('width', width);
    svgElement.setAttribute('height', height);
    svgElement.setAttribute('viewBox', `0 0 ${width} ${height}`);
    
    // Add grid background
    const gridPattern = document.createElementNS('http://www.w3.org/2000/svg', 'pattern');
    gridPattern.setAttribute('id', 'grid');
    gridPattern.setAttribute('width', '20');
    gridPattern.setAttribute('height', '20');
    gridPattern.setAttribute('patternUnits', 'userSpaceOnUse');
    
    const gridPath = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    gridPath.setAttribute('d', 'M 20 0 L 0 0 0 20');
    gridPath.setAttribute('fill', 'none');
    gridPath.setAttribute('stroke', '#e0e0e0');
    gridPath.setAttribute('stroke-width', '1');
    
    gridPattern.appendChild(gridPath);
    
    const defs = document.createElementNS('http://www.w3.org/2000/svg', 'defs');
    defs.appendChild(gridPattern);
    svgElement.appendChild(defs);
    
    const backgroundRect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    backgroundRect.setAttribute('width', width);
    backgroundRect.setAttribute('height', height);
    backgroundRect.setAttribute('fill', 'url(#grid)');
    svgElement.appendChild(backgroundRect);
    
    // Add click handler to background to clear selection
    backgroundRect.addEventListener('click', () => {
      setSelectedNodeInChart(null);
      if (onNodeSelect) onNodeSelect(null);
    });
    
    // Create hierarchy using d3
    const root = d3.hierarchy(data);
    
    // Create tree layout
    const treeLayout = d3.tree().size([width - 200, height - 200]);
    const treeData = treeLayout(root);
    
    // Create main group and center it
    const mainGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    mainGroup.setAttribute('transform', `translate(100, 50)`);
    svgElement.appendChild(mainGroup);
    
    // Create links
    treeData.links().forEach(link => {
      const linkPath = document.createElementNS('http://www.w3.org/2000/svg', 'path');
      const d = `
        M ${link.source.x},${link.source.y + 25}
        C ${link.source.x},${(link.source.y + link.target.y) / 2}
          ${link.target.x},${(link.source.y + link.target.y) / 2}
          ${link.target.x},${link.target.y - 25}
      `;
      
      linkPath.setAttribute('d', d);
      linkPath.setAttribute('fill', 'none');
      linkPath.setAttribute('stroke', '#999');
      linkPath.setAttribute('stroke-width', '1.5');
      mainGroup.appendChild(linkPath);
    });
    
    // Create nodes
    treeData.descendants().forEach(node => {
      const nodeWidth = Math.max(180, getTextWidth(node.data.NODE_NM) + 40);
      const nodeHeight = 50;
      
      const nodeGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
      nodeGroup.setAttribute('transform', `translate(${node.x - nodeWidth/2}, ${node.y - nodeHeight/2})`);
      nodeGroup.setAttribute('cursor', 'pointer');
      
      // Add event listeners
      nodeGroup.addEventListener('click', (event) => {
        // Set this node as selected in the chart
        setSelectedNodeInChart({
          data: node.data,
          position: {
            x: node.x - nodeWidth/2,
            y: node.y - nodeHeight/2
          }
        });
        
        if (onNodeSelect) onNodeSelect(node.data);
        
        // Stop event propagation
        event.stopPropagation();
      });
      
      nodeGroup.addEventListener('mouseover', (event) => {
        const status = node.data.STATUS || 'N/A';
        const description = node.data.NODE_DESCRIPTION || 'N/A';
        const executionDate = node.data.EXECUTION_DT ? formatDate(node.data.EXECUTION_DT) : 'N/A';
        const sla = node.data.SLA || 'N/A';
        
        setTooltipInfo({
          x: event.clientX,
          y: event.clientY,
          data: {
            name: node.data.NODE_NM,
            status,
            description,
            executionDate,
            sla
          }
        });
      });
      
      nodeGroup.addEventListener('mouseout', () => {
        setTooltipInfo(null);
      });
      
      // Node rectangle
      const nodeRect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      nodeRect.setAttribute('width', nodeWidth);
      nodeRect.setAttribute('height', nodeHeight);
      nodeRect.setAttribute('rx', '8');
      nodeRect.setAttribute('ry', '8');
      nodeRect.setAttribute('fill', getNodeColor(node.data.STATUS));
      nodeRect.setAttribute('stroke', '#333');
      nodeRect.setAttribute('stroke-width', '1');
      nodeGroup.appendChild(nodeRect);
      
      // Node text
      const nodeText = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      nodeText.setAttribute('x', nodeWidth / 2);
      nodeText.setAttribute('y', nodeHeight / 2);
      nodeText.setAttribute('text-anchor', 'middle');
      nodeText.setAttribute('dominant-baseline', 'middle');
      nodeText.setAttribute('fill', getTextColor(node.data.STATUS));
      nodeText.setAttribute('font-weight', '500');
      nodeText.setAttribute('font-size', '14px');
      nodeText.textContent = node.data.NODE_NM;
      nodeGroup.appendChild(nodeText);
      
      // Add info text below nodes if they have execution data
      if (node.data.EXECUTION_DT || node.data.SLA) {
        const foreignObject = document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject');
        foreignObject.setAttribute('x', '0');
        foreignObject.setAttribute('y', String(nodeHeight + 5));
        foreignObject.setAttribute('width', String(nodeWidth));
        foreignObject.setAttribute('height', '40');
        
        const div = document.createElement('div');
        div.style.fontSize = '10px';
        div.style.color = '#555';
        div.style.textAlign = 'center';
        div.style.overflow = 'hidden';
        div.style.textOverflow = 'ellipsis';
        
        if (node.data.EXECUTION_DT) {
          const dateDiv = document.createElement('div');
          dateDiv.textContent = formatDate(node.data.EXECUTION_DT);
          div.appendChild(dateDiv);
        }
        
        if (node.data.SLA) {
          const slaDiv = document.createElement('div');
          slaDiv.textContent = `SLA: ${node.data.SLA}`;
          div.appendChild(slaDiv);
        }
        
        foreignObject.appendChild(div);
        nodeGroup.appendChild(foreignObject);
      }
      
      mainGroup.appendChild(nodeGroup);
    });
    
  }, [data, onNodeSelect]);
  
  return (
    <div className="relative w-full h-full overflow-auto">
      <svg 
        ref={svgRef} 
        className="border rounded" 
        style={{ minWidth: '100%', minHeight: '100%' }}
      ></svg>
      
      <StatusLegend />
      
      {/* Mouse hover tooltip */}
      {tooltipInfo && !selectedNodeInChart && (
        <div
          className="absolute bg-white border rounded shadow-lg p-2 z-20 pointer-events-none"
          style={{
            left: `${tooltipInfo.x + 10}px`,
            top: `${tooltipInfo.y - 28}px`,
          }}
        >
          <div className="font-bold">{tooltipInfo.data.name}</div>
          <div>Type: {tooltipInfo.data.description}</div>
          <div>Status: {tooltipInfo.data.status}</div>
          <div>Execution: {tooltipInfo.data.executionDate}</div>
          <div>SLA: {tooltipInfo.data.sla}</div>
        </div>
      )}
      
      {/* Selected node detail panel that appears directly at the node */}
      {selectedNodeInChart && (
        <div 
          className="absolute bg-white border shadow-md rounded z-30 text-left p-0 w-auto max-w-md"
          style={{
            left: `${selectedNodeInChart.position.x + 290}px`,
            top: `${selectedNodeInChart.position.y}px`,
          }}
        >
          <div className="text-xl font-bold px-4 pt-3 pb-1">
            Selected Node: {selectedNodeInChart.data.NODE_NM}
          </div>
          <div className="px-4 pb-3 flex flex-col">
            <div className="my-1">
              <span className="font-semibold block">Execution Date:</span>
              <span>{selectedNodeInChart.data.EXECUTION_DT ? formatDate(selectedNodeInChart.data.EXECUTION_DT) : 'N/A'}</span>
            </div>
            <div className="my-1">
              <span className="font-semibold block">SLA:</span>
              <span>{selectedNodeInChart.data.SLA || 'N/A'}</span>
            </div>
            <div className="my-1">
              <span className="font-semibold block">Type:</span>
              <span>{selectedNodeInChart.data.NODE_DESCRIPTION || 'N/A'}</span>
            </div>
            <div className="my-1">
              <span className="font-semibold block">Status:</span>
              <span>{selectedNodeInChart.data.STATUS || 'N/A'}</span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

// Main Component
const SupplyChainDependencyChart = () => {
  const [allData, setAllData] = useState([]);
  const [treeData, setTreeData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedNode, setSelectedNode] = useState(null);
  
  // Fetch all data initially
  useEffect(() => {
    fetchAllData();
  }, []);
  
  // Update tree data when data changes
  useEffect(() => {
    if (allData.length > 0) {
      try {
        const tree = buildTree(allData);
        setTreeData(tree);
      } catch (err) {
        console.error('Error building tree:', err);
        setError('Error building the dependency tree. Check your data structure.');
      }
    } else {
      setTreeData(null);
    }
  }, [allData]);
  
  // Fetch all data from API
  const fetchAllData = async () => {
    setLoading(true);
    setError(null);
    
    try {
      // For testing purposes, use the hardcoded data if API fails
      const initialData = [
        { NODE_ID: 1, PARENT_ID: null, NODE_NM: "DCA", STATUS: "", SLA: "", EXECUTION_DT: "", NODE_DESCRIPTION: "Organisation" },
        { NODE_ID: 2, PARENT_ID: 1, NODE_NM: "Supply Chain", STATUS: "", SLA: "", EXECUTION_DT: "", NODE_DESCRIPTION: "Domain" },
        { NODE_ID: 3, PARENT_ID: 2, NODE_NM: "Ecomm", STATUS: "", SLA: "", EXECUTION_DT: "", NODE_DESCRIPTION: "Product" },
        { NODE_ID: 4, PARENT_ID: 3, NODE_NM: "abc-101", STATUS: "", SLA: "", EXECUTION_DT: "", NODE_DESCRIPTION: "Instance" },
        { NODE_ID: 5, PARENT_ID: 4, NODE_NM: "dag-6", STATUS: "failed", SLA: "Daily", EXECUTION_DT: "2025-03-21 14:00:00", NODE_DESCRIPTION: "Application" },
        { NODE_ID: 6, PARENT_ID: 4, NODE_NM: "dag-3", STATUS: "completed", SLA: "Daily", EXECUTION_DT: "2025-03-21 11:00:00", NODE_DESCRIPTION: "Application" },
        { NODE_ID: 7, PARENT_ID: 4, NODE_NM: "dag-1", STATUS: "running", SLA: "Daily", EXECUTION_DT: "2025-03-21 08:00:00", NODE_DESCRIPTION: "Application" },
        { NODE_ID: 8, PARENT_ID: 5, NODE_NM: "ts-7", STATUS: "failed", SLA: "Daily", EXECUTION_DT: "2025-03-21 14:00:00", NODE_DESCRIPTION: "Task" },
        { NODE_ID: 9, PARENT_ID: 6, NODE_NM: "ts-4", STATUS: "completed", SLA: "Daily", EXECUTION_DT: "2025-03-21 11:00:00", NODE_DESCRIPTION: "Task" },
        { NODE_ID: 10, PARENT_ID: 7, NODE_NM: "ts-2", STATUS: "completed", SLA: "Daily", EXECUTION_DT: "2025-03-21 09:00:00", NODE_DESCRIPTION: "Task" },
        { NODE_ID: 11, PARENT_ID: 7, NODE_NM: "ts-1", STATUS: "running", SLA: "Daily", EXECUTION_DT: "2025-03-21 08:00:00", NODE_DESCRIPTION: "Task" },
        { NODE_ID: 15, PARENT_ID: 11, NODE_NM: "ODS->def-101->dag-2->ts-3", STATUS: "queued", SLA: "Daily", EXECUTION_DT: "2025-03-21 10:00:00", NODE_DESCRIPTION: "Downstream" },
        { NODE_ID: 16, PARENT_ID: 9, NODE_NM: "ODS->def-101->dag-4->ts-5", STATUS: "running", SLA: "Daily", EXECUTION_DT: "2025-03-21 12:00:00", NODE_DESCRIPTION: "Downstream" },
        { NODE_ID: 17, PARENT_ID: 9, NODE_NM: "ODS->def-101->dag-5->ts-6", STATUS: "completed", SLA: "Daily", EXECUTION_DT: "2025-03-21 13:00:00", NODE_DESCRIPTION: "Downstream" },
        { NODE_ID: 18, PARENT_ID: 8, NODE_NM: "ODS->def-101->dag-7->ts-8", STATUS: "queued", SLA: "Daily", EXECUTION_DT: "2025-03-21 15:00:00", NODE_DESCRIPTION: "Downstream" },
        { NODE_ID: 22, PARENT_ID: 15, NODE_NM: "Returns->qwe-101->dag-10->ts-1", STATUS: "running", SLA: "Daily", EXECUTION_DT: "2025-03-21 08:00:00", NODE_DESCRIPTION: "Downstream" }
      ];
      
      try {
        const response = await axios.get(`${API_URL}/nodes`);
        setAllData(response.data);
      } catch (apiError) {
        console.warn('API request failed, using fallback data:', apiError);
        // Use fallback data if API request fails
        setAllData(initialData);
      }
    } catch (err) {
      console.error('Error fetching data:', err);
      setError('Failed to fetch data. Please check your connection and try again.');
    } finally {
      setLoading(false);
    }
  };
  
  // Handle node selection
  const handleNodeSelect = (node) => {
    setSelectedNode(node);
  };
  
  return (
    <div className="p-6 max-w-6xl mx-auto">
      <h1 className="text-3xl font-bold text-center mb-6">Supply Chain Dependency Chart</h1>
      
      {/* Refresh Button */}
      <div className="flex justify-end mb-4">
        <button 
          onClick={fetchAllData}
          className="px-4 py-2 bg-blue-100 hover:bg-blue-200 rounded text-blue-800 transition duration-150 flex items-center"
          disabled={loading}
        >
          {loading ? (
            <>
              <svg className="animate-spin -ml-1 mr-2 h-4 w-4 text-blue-800" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Loading...
            </>
          ) : (
            <>
              <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
              </svg>
              Refresh Data
            </>
          )}
        </button>
      </div>
      
      {/* Error message */}
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {error}
        </div>
      )}
      
      {/* Flowchart with scrollbars */}
      <div className="bg-white border rounded-lg overflow-auto" style={{ height: '700px' }}>
        {treeData ? (
          <SimpleFlowchart data={treeData} onNodeSelect={handleNodeSelect} />
        ) : (
          <div className="flex items-center justify-center h-full text-gray-500">
            {loading ? 'Preparing flowchart...' : 'No data to display. Try refreshing.'}
          </div>
        )}
      </div>
    </div>
  );
};

// Make sure to export the component
export default SupplyChainDependencyChart;