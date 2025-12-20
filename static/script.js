// DOM Elements
const apiKeyInput = document.getElementById('apiKey');
const imageInput = document.getElementById('imageInput');
const dropZone = document.getElementById('dropZone');
const previewImage = document.getElementById('previewImage');
const uploadPlaceholder = document.getElementById('uploadPlaceholder');
const analyzeBtn = document.getElementById('analyzeBtn');
const loadingContainer = document.getElementById('loadingContainer');
const resultsContainer = document.getElementById('resultsContainer');
const errorMessage = document.getElementById('errorMessage');
const apiStatus = document.getElementById('apiStatus');
const imageStatus = document.getElementById('imageStatus');
const reportContent = document.getElementById('reportContent');

let selectedImage = null;
let selectedImageDataUrl = null;

// Event Listeners
apiKeyInput.addEventListener('input', checkReadyState);

dropZone.addEventListener('click', () => imageInput.click());

dropZone.addEventListener('dragover', (e) => {
    e.preventDefault();
    dropZone.classList.add('dragover');
});

dropZone.addEventListener('dragleave', () => {
    dropZone.classList.remove('dragover');
});

dropZone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropZone.classList.remove('dragover');
    const files = e.dataTransfer.files;
    if (files.length > 0) handleFile(files[0]);
});

imageInput.addEventListener('change', (e) => {
    if (e.target.files.length > 0) handleFile(e.target.files[0]);
});

analyzeBtn.addEventListener('click', runAnalysis);

// Functions
function handleFile(file) {
    if (!file.type.startsWith('image/')) {
        showError('Please select a valid image file.');
        imageStatus.className = 'status-indicator error';
        return;
    }
    selectedImage = file;
    const reader = new FileReader();
    reader.onload = (e) => {
        previewImage.src = e.target.result;
        previewImage.style.display = 'block';
        uploadPlaceholder.style.display = 'none';
        selectedImageDataUrl = e.target.result;
        checkReadyState();
    };
    reader.readAsDataURL(file);
}

function checkReadyState() {
    const apiKey = apiKeyInput.value.trim();
    const hasImage = selectedImageDataUrl !== null;
    // API Key Light Logic
    if (!apiKey) {
        apiStatus.className = 'status-indicator waiting';
    } else {
        apiStatus.className = 'status-indicator ready';
        apiKeyInput.disabled = false;
    }
    // 2. Image Light Logic
    if (!hasImage) {
        imageStatus.className = 'status-indicator waiting';
    } else {
        imageStatus.className = 'status-indicator ready';
        imageInput.disabled = false;
        dropZone.classList.remove('disabled');
        previewImage.classList.remove('disabled');
    }
    // Enable button only if BOTH are ready (Green)
    analyzeBtn.disabled = !(apiKey && hasImage);
}
checkReadyState();

function showError(message) {
    errorMessage.textContent = message;
    errorMessage.classList.add('active');
}

function hideError() {
    errorMessage.classList.remove('active');
}

async function runAnalysis() {
    hideError();
    apiStatus.className = 'status-indicator processing';
    imageStatus.className = 'status-indicator processing';

    dropZone.classList.add('disabled');
    previewImage.classList.add('disabled');
    apiKeyInput.disabled = true;
    imageInput.disabled = true;

    loadingContainer.classList.add('active');
    loadingContainer.classList.add('active');
    resultsContainer.classList.remove('active');
    analyzeBtn.disabled = true;
    initParticleAnimation();

    const apiKey = apiKeyInput.value.trim();

    try {
        const report = await getForensicReport(apiKey, selectedImageDataUrl);
        reportContent.textContent = report;
        loadingContainer.classList.remove('active');
        resultsContainer.classList.add('active');
        checkReadyState();
    } catch (error) {
        dropZone.classList.remove('disabled');
        previewImage.classList.remove('disabled');
        apiKeyInput.disabled = false;
        imageInput.disabled = false;

        loadingContainer.classList.remove('active');
        showError('Error: ' + error.message);

        // analyzeBtn.disabled = false;
        if (error.message == 'No cookie auth credentials found' || 'User not found') {
            apiStatus.className = 'status-indicator error';
            imageStatus.className = 'status-indicator ready';
        }
    }
}

async function getForensicReport(apiKey, imageDataUrl) {
    const analystPrompt = `
Act as a Senior Bloodstain Pattern Analyst (BPA). Analyze the attached image and generate a formal 'Preliminary Forensic Report.'

The report must use a clinical, objective tone and follow this strict format:
# Preliminary FORENSIC REPORT
---

## 1. MORPHOLOGICAL ANALYSIS

* **Edge Characteristics:** [Describe edges]
* **Directionality:** [Indicate direction]
* **Satellite/Mist Presence:** [Note details]

## 2. CLASSIFICATION

* **Primary Pattern:** [e.g., Passive Drip, Expirated, Cast-off]
* **Velocity Impact:** [e.g., Low, Medium, High Velocity]

## 3. RECONSTRUCTION HYPOTHESIS

* **Mechanism:** [Describe physical event scientifically]
* **Object Interaction:** [Identify likely instrument]

## 4. CONCLUSIONS

* **Summary:** [Summary of findings and any limitations of the analysis]

---
# END OF REPORT
`;

    // OpenRouter API Endpoint
    const endpoint = "https://openrouter.ai/api/v1/chat/completions";

    // API Call with Reasoning enabled
    const response = await fetch(endpoint, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${apiKey}`,
            "Content-Type": "application/json",
            "HTTP-Referer": window.location.href, // OpenRouter best practice
            "X-Title": "Forensic BPA Automation"  // OpenRouter best practice
        },
        body: JSON.stringify({
            "model": "nvidia/nemotron-nano-12b-v2-vl:free",
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": analystPrompt
                        },
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": imageDataUrl
                            }
                        }
                    ]
                }
            ],
            // Enabling reasoning for deeper analysis
            "reasoning": { "enabled": true }
        })
    });

    if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error?.message || 'Failed to analyze image via OpenRouter');
    }

    const result = await response.json();

    // Return the content. If reasoning_details are present, the model has used them internally.
    // Depending on the model's specific behavior on OpenRouter, the final answer is in content.
    return result.choices[0].message.content;
}

function copyToClipboard(elementId, btnElement) {
    const text = document.getElementById(elementId).textContent;
    navigator.clipboard.writeText(text).then(() => {
        const originalText = btnElement.textContent;
        btnElement.textContent = '✅ Copied!';
        btnElement.style.borderColor = '#00ff00';
        btnElement.style.color = '#00ff00';

        setTimeout(() => {
            btnElement.textContent = originalText;
            btnElement.style.borderColor = '#ff0';
            btnElement.style.color = '#ff0';
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy: ', err);
        alert("Failed to copy report to clipboard.");
    });
}

function resetAnalysis() {
    dropZone.classList.remove('disabled');
    previewImage.classList.remove('disabled');
    apiKeyInput.disabled = false;
    imageInput.disabled = false;

    resultsContainer.classList.remove('active');
    previewImage.style.display = 'none';
    uploadPlaceholder.style.display = 'block';
    selectedImage = null;
    selectedImageDataUrl = null;
    imageInput.value = '';
    checkReadyState();
}

// Particle Animation from Bootstrap
function initParticleAnimation() {
    var points = [], velocity2 = 1,
        canvas = document.getElementById('particleCanvas'),
        context = canvas.getContext('2d'),
        radius = 3, boundaryX = canvas.width, boundaryY = canvas.height, numberOfPoints = 15;

    points = [];
    function createPoint() {
        var point = {}, vx2, vy2;
        point.x = Math.random() * boundaryX;
        point.y = Math.random() * boundaryY;
        point.vx = (Math.random() * 2 - 1) * Math.sqrt(velocity2);
        vx2 = Math.pow(point.vx, 2); vy2 = velocity2 - vx2;
        point.vy = Math.sqrt(vy2) * (Math.random() < 0.5 ? -1 : 1);
        points.push(point);
    }
    function resetVelocity(point, axis, dir) {
        let vx2, vy2;
        if (axis === 'x') {
            point.vx = dir * Math.random(); vx2 = Math.pow(point.vx, 2); vy2 = velocity2 - vx2;
            point.vy = Math.sqrt(vy2) * (Math.random() < 0.5 ? -1 : 1);
        } else {
            point.vy = dir * Math.random(); vy2 = Math.pow(point.vy, 2); vx2 = velocity2 - vy2;
            point.vx = Math.sqrt(vx2) * (Math.random() < 0.5 ? -1 : 1);
        }
    }
    function drawCircle(x, y) {
        context.beginPath(); context.arc(x, y, radius, 0, 2 * Math.PI);
        context.fillStyle = '#dc9797'; context.fill();
    }
    function drawLine(x1, y1, x2, y2) {
        context.beginPath(); context.moveTo(x1, y1); context.lineTo(x2, y2);
        context.strokeStyle = '#d88a8a'; context.stroke();
    }
    function draw() {
        for (var i = 0; i < points.length; i++) {
            var point = points[i]; point.x += point.vx; point.y += point.vy;
            drawCircle(point.x, point.y); drawLine(point.x, point.y, point.buddy.x, point.buddy.y);
            if (point.x < radius) resetVelocity(point, 'x', 1);
            else if (point.x > boundaryX - radius) resetVelocity(point, 'x', -1);
            else if (point.y < radius) resetVelocity(point, 'y', 1);
            else if (point.y > boundaryY - radius) resetVelocity(point, 'y', -1);
        }
    }
    function animate() {
        if (!loadingContainer.classList.contains('active')) return;
        context.clearRect(0, 0, boundaryX, boundaryY); draw(); requestAnimationFrame(animate);
    }
    function init() {
        for (var i = 0; i < numberOfPoints; i++) createPoint();
        for (var i = 0; i < points.length; i++) points[i].buddy = i === 0 ? points[points.length - 1] : points[i - 1];
        animate();
    }
    init();
}
