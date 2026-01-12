# Forensic BPA Automation
#### Site: <https://ai-forensics.42web.io> (Hosted by [InfinityFree](https://www.infinityfree.com/))
#### Video Demo:  <https://youtu.be/wUVBQ3MTCaM?si=3RY1uVU-fFh_Cu74>
#### Description:
A forensic analysis tool that uses AI to classify bloodstain patterns from user-uploaded images.

# Forensic BPA Automation: Technical Documentation

## 1. Project Vision

**Forensic BPA Automation** is a specialized, high-security web application designed for forensic investigators and students. It bridges the gap between traditional forensic techniques and modern Artificial Intelligence by automating the classification of bloodstain patterns. By leveraging the **NVIDIA Nemotron Nano 12B Vision Language Model**, the tool interprets complex morphological data—such as spines, satellites, and wave cast-offs—to generate a standardized preliminary report.

---

## 2. Technical Architecture & Security

A defining characteristic of this project is its **Zero-Server Architecture**.

* **Data Privacy (Chain of Custody):** In forensic science, the privacy of evidence is paramount. The application is built entirely on the client side.
* **Local Processing:** Neither the uploaded images nor the User's API keys are ever stored on an external server.
* **Direct API Integration:** The `script.js` controller facilitates a direct `fetch()` request to the OpenRouter API endpoint.
* **Secure Transmission:** This ensures that the sensitive "evidence" data moves only between the user's browser and the API provider via encrypted HTTPS.
* **State Management:** The application uses real-time event listeners to monitor the "Ready State" of the UI, ensuring that the analysis cannot proceed until both a valid image and an API key are present.

---

## 3. Detailed File Breakdown

### 📂 `index.html` (The UI Foundation)

The interface is designed with a "Dark Mode" aesthetic, often preferred in forensic laboratory environments to reduce eye strain and highlight visual data.

* **Status Indicators:** Visual dots (`.status-indicator`) provide immediate feedback on the state of credentials and uploads.
* **Dynamic Containers:** Uses a state-based layout where the `loading-container` and `results-container` toggle visibility using the `.active` class based on the application's processing state.
* **Interactive Header:** Features a Montserrat-styled header with a thematic crimson background to denote the forensic focus.

### 📂 `styles.css` (Visual Identity)

The "Crimson and Slate" palette (`#df0f0f` and `#211015`) reflects the forensic nature of the tool.

* **Micro-interactions:** Buttons and drag-and-drop zones feature smooth `0.3s` transitions, hover effects, and depth shadows to enhance the professional feel.
* **Responsive Design:** Utilizing a `max-width: 900px` container and media queries, the tool remains fully functional on tablets used in the field or desktop workstations in the lab.
* **Status Animations:** Includes a `@keyframes pulse` animation for the "Processing" and "Waiting" states to provide active feedback during AI reasoning wait times.

### 📂 `script.js` (The Brain)

This file contains the core logic for the application:

* **Image Processing:** Implements a `FileReader` system to convert raw image files into Base64-encoded strings (`dataUrl`), allowing them to be transmitted as part of a JSON payload.
* **Particle Engine:** A custom HTML5 Canvas animation system mimics microscopic observation, serving as a functional "progress loader" to keep users engaged.
* **AI Prompt Engineering:** Features a highly structured `analystPrompt`. It forces the AI to act as a "Senior BPA" and strictly adhere to clinical, objective language across four key sections: Morphological Analysis, Classification, Reconstruction Hypothesis, and Conclusions.

---

## 4. AI Analysis Workflow

1. **Input:** The user provides a bloodstain image (JPG, PNG, or WEBP) and an OpenRouter API key.
2. **Reasoning Activation:** The application specifically enables the `"reasoning": { "enabled": true }` flag in the API call, encouraging the model to "think" through the physical mechanics of the blood drop before providing the final classification.
3. **Pattern Interpretation:** The AI evaluates morphological features based on the prompt:
* **Edge Characteristics:** Smooth vs. Scalloped (indicating impact surface).
* **Directionality:** Identifying the "tail" or spines of the drop to determine the path of travel.
* **Satellite/Mist Presence:** Detecting secondary spatter to determine velocity.


4. **Output:** A formatted Markdown report is rendered into a `pre` tag for the user to review and copy.

---

## 5. Usage Instructions

1. **Initialization:** Open `index.html` in any modern web browser.
2. **Authentication:** Input your **OpenRouter API Key**. The status indicator will turn green (ready) once a key is detected.
3. **Evidence Upload:** Drag an image into the dashed zone or click to browse. A preview will appear to confirm the selection.
4. **Execution:** Click **"Analyze Bloodstain Pattern"**. The particle engine will engage while the AI processes the image.
5. **Reporting:** Once the report is displayed, use the **"Copy Report"** button to transfer findings to case notes.

---

## 6. Design Decisions & Safety

* **Security:** Client-side processing was chosen to maintain the chain of custody and minimize security risks of data exploitation on secondary servers.
* **User Engagement:** Because Vision Models can take 5-10 seconds to process, the custom particle animation system was implemented to confirm the application hasn't frozen.
* **Disclaimer:** The interface includes a red-text warning that AI-generated content must be fact-checked and is not a substitute for professional judgment.
