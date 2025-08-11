// Gold Panning UI Script
let isPanning = false;

// UI Elements
const progressContainer = document.getElementById('progress-container');
const progressFill = document.getElementById('progress-fill');
const progressText = document.getElementById('progress-text');
const foundItemsContainer = document.getElementById('found-items');
const foundItemsList = document.getElementById('found-items-list');
const helpText = document.getElementById('help-text');
const closeFoundBtn = document.getElementById('close-found');

// Close button for found items panel
closeFoundBtn.addEventListener('click', () => {
    foundItemsContainer.classList.add('hidden');
    window.postMessage({
        type: 'GOLD_PANNING_UI_CLOSE'
    }, '*');
});

// Listen for messages from the game
window.addEventListener('message', (event) => {
    const data = event.data;
    
    switch(data.type) {
        case 'SHOW_PANNING_UI':
            showPanningUI();
            break;
            
        case 'UPDATE_PANNING_PROGRESS':
            updateProgress(data.progress);
            break;
            
        case 'SHOW_FOUND_ITEMS':
            showFoundItems(data.items);
            break;
            
        case 'HIDE_PANNING_UI':
            hidePanningUI();
            break;
            
        case 'SHOW_HELP_TEXT':
            showHelpText(data.show);
            break;
    }
});

// Show the panning UI
function showPanningUI() {
    if (isPanning) return;
    
    isPanning = true;
    progressContainer.classList.remove('hidden');
    progressFill.style.width = '0%';
    progressText.textContent = 'Panning for gold...';
    
    // Hide help text when panning starts
    helpText.classList.add('hidden');
}

// Update the progress bar
function updateProgress(progress) {
    if (!isPanning) return;
    
    const percentage = Math.min(100, Math.max(0, progress));
    progressFill.style.width = `${percentage}%`;
    
    // Update text based on progress
    if (percentage < 30) {
        progressText.textContent = 'Panning for gold...';
    } else if (percentage < 70) {
        progressText.textContent = 'Looking for gold...';
    } else {
        progressText.textContent = 'Almost there...';
    }
}

// Show found items
function showFoundItems(items) {
    isPanning = false;
    progressContainer.classList.add('hidden');
    foundItemsList.innerHTML = ''; // Clear previous items
    
    if (!items || items.length === 0) {
        // No items found
        const noItems = document.createElement('div');
        noItems.className = 'found-item';
        noItems.innerHTML = `
            <img src="img/no-items.png" alt="No items">
            <span>No gold found this time</span>
        `;
        foundItemsList.appendChild(noItems);
    } else {
        // Add each found item to the list
        items.forEach(item => {
            const itemElement = document.createElement('div');
            itemElement.className = 'found-item';
            itemElement.innerHTML = `
                <img src="img/${item.name.toLowerCase().replace(/\s+/g, '-')}.png" alt="${item.name}" onerror="this.src='img/gold-nugget.png'">
                <span>${item.name}</span>
                <span class="amount">x${item.amount}</span>
            `;
            foundItemsList.appendChild(itemElement);
        });
    }
    
    foundItemsContainer.classList.remove('hidden');
}

// Hide the panning UI
function hidePanningUI() {
    isPanning = false;
    progressContainer.classList.add('hidden');
}

// Show or hide help text
function showHelpText(show) {
    if (show) {
        helpText.classList.remove('hidden');
    } else {
        helpText.classList.add('hidden');
    }
}

// Handle key presses for UI interaction
document.addEventListener('keydown', (event) => {
    // Close found items panel with ESC key
    if (event.key === 'Escape' && !foundItemsContainer.classList.contains('hidden')) {
        foundItemsContainer.classList.add('hidden');
        window.postMessage({
            type: 'GOLD_PANNING_UI_CLOSE'
        }, '*');
    }
});

// Initialize
function init() {
    // Notify the game that the UI is ready
    window.postMessage({
        type: 'GOLD_PANNING_UI_READY'
    }, '*');
}

// Start the UI
init();
