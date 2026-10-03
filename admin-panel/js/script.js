document.addEventListener("DOMContentLoaded", () => {
    // =========================================================================
    // 1. THEME ENGINE & AUDIO CHIME SYSTEM
    // =========================================================================
    const themeToggleBtn = document.getElementById('theme-toggle');
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    const savedTheme = localStorage.getItem('ekabadi_admin_theme') || (prefersDark ? 'dark' : 'light');

    // Audio chime toggle using Web Audio API (No external mp3 needed)
    let audioContext = null;
    let isAudioEnabled = localStorage.getItem('ekabadi_audio_enabled') !== 'false';

    function initAudioContext() {
        if (!audioContext) {
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (AudioCtx) {
                audioContext = new AudioCtx();
            }
        }
    }

    window.toggleAudioChime = function () {
        isAudioEnabled = !isAudioEnabled;
        localStorage.setItem('ekabadi_audio_enabled', isAudioEnabled ? 'true' : 'false');
        updateAudioButtonUI();
        if (isAudioEnabled) {
            playDispatchChime();
            showToast("Sound alerts enabled.");
        } else {
            showToast("Sound alerts muted.");
        }
    };

    function updateAudioButtonUI() {
        const icon = document.getElementById('audio-toggle-icon');
        const btn = document.getElementById('audio-toggle-btn');
        if (icon && btn) {
            if (isAudioEnabled) {
                icon.className = 'fa-solid fa-volume-high';
                icon.style.color = 'var(--primary)';
                btn.setAttribute('title', 'Mute Dispatch Alerts');
            } else {
                icon.className = 'fa-solid fa-volume-xmark';
                icon.style.color = 'var(--text-muted)';
                btn.setAttribute('title', 'Enable Dispatch Alerts');
            }
        }
    }
    updateAudioButtonUI();

    function playDispatchChime() {
        if (!isAudioEnabled) return;
        try {
            initAudioContext();
            if (!audioContext) return;
            if (audioContext.state === 'suspended') {
                audioContext.resume();
            }
            const now = audioContext.currentTime;

            // Ascending dual-bell harmonic chime (A5 880Hz -> E6 1320Hz)
            const osc1 = audioContext.createOscillator();
            const gain1 = audioContext.createGain();
            osc1.type = 'sine';
            osc1.frequency.setValueAtTime(880, now);
            gain1.gain.setValueAtTime(0.2, now);
            gain1.gain.exponentialRampToValueAtTime(0.001, now + 0.35);
            osc1.connect(gain1);
            gain1.connect(audioContext.destination);
            osc1.start(now);
            osc1.stop(now + 0.35);

            const osc2 = audioContext.createOscillator();
            const gain2 = audioContext.createGain();
            osc2.type = 'sine';
            osc2.frequency.setValueAtTime(1320, now + 0.08);
            gain2.gain.setValueAtTime(0.25, now + 0.08);
            gain2.gain.exponentialRampToValueAtTime(0.001, now + 0.55);
            osc2.connect(gain2);
            gain2.connect(audioContext.destination);
            osc2.start(now + 0.08);
            osc2.stop(now + 0.55);
        } catch (e) {
            console.warn('Audio chime omitted:', e);
        }
    }

    function applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('ekabadi_admin_theme', theme);

        if (themeToggleBtn) {
            themeToggleBtn.innerHTML = theme === 'dark'
                ? '<i class="fa-solid fa-sun" style="color: #f59e0b;"></i>'
                : '<i class="fa-solid fa-moon"></i>';
            themeToggleBtn.setAttribute('title', `Switch to ${theme === 'dark' ? 'Light' : 'Dark'} Mode`);
        }

        const isDark = theme === 'dark';

        // Update Scrap Line Chart colors
        if (window.scrapChartInstance) {
            window.scrapChartInstance.options.scales.x.grid.color = isDark ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.05)';
            window.scrapChartInstance.options.scales.y.grid.color = isDark ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.05)';
            window.scrapChartInstance.options.scales.x.ticks.color = isDark ? '#94a3b8' : '#64748b';
            window.scrapChartInstance.options.scales.y.ticks.color = isDark ? '#94a3b8' : '#64748b';
            if (window.scrapChartInstance.options.plugins && window.scrapChartInstance.options.plugins.tooltip) {
                window.scrapChartInstance.options.plugins.tooltip.backgroundColor = isDark ? '#1f2937' : '#0f172a';
                window.scrapChartInstance.options.plugins.tooltip.borderColor = isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)';
            }
            window.scrapChartInstance.update();
        }

        // Update Composition Doughnut Chart colors
        if (window.compositionChartInstance) {
            window.compositionChartInstance.data.datasets[0].borderColor = isDark ? '#111827' : '#ffffff';
            if (window.compositionChartInstance.options.plugins && window.compositionChartInstance.options.plugins.legend) {
                window.compositionChartInstance.options.plugins.legend.labels.color = isDark ? '#cbd5e1' : '#475569';
            }
            if (window.compositionChartInstance.options.plugins && window.compositionChartInstance.options.plugins.tooltip) {
                window.compositionChartInstance.options.plugins.tooltip.backgroundColor = isDark ? '#1f2937' : '#0f172a';
            }
            window.compositionChartInstance.update();
        }

        // Update Leaflet tile layer if loaded
        if (window.mapTileLayer) {
            const newTileUrl = isDark
                ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';
            window.mapTileLayer.setUrl(newTileUrl);
        }
    }

    applyTheme(savedTheme);

    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            applyTheme(newTheme);
            showToast(`Switched to ${newTheme.toUpperCase()} mode.`);
        });
    }

    // =========================================================================
    // 2. DATA STORE & LOCALSTORAGE PERSISTENCE (FRONTEND PROTOTYPE)
    // =========================================================================
    const defaultData = {
        citizens: [
            { id: "C-001", name: "Rahul Sharma", location: "Sector 14, Main Road", coins: 450, phone: "+91 98765 43210", email: "rahul@email.com" },
            { id: "C-002", name: "Priya Desai", location: "MG Road, Block 4", coins: 120, phone: "+91 91234 56789", email: "priya@email.com" },
            { id: "C-003", name: "Vikram Singh", location: "Kalyan Nagar, Sector 62", coins: 890, phone: "+91 99887 76655", email: "vikram@email.com" }
        ],
        collectors: [
            { id: "K-101", name: "Ravi Kumar", vehicle: "MH 04 AB 1234", zone: "North Zone (Sec 10-25)", completionRate: 98, rating: 4.9, reviews: 54, status: "Active" },
            { id: "K-102", name: "Suresh Yadav", vehicle: "MH 12 CD 5678", zone: "South Zone (Sec 26-45)", completionRate: 88, rating: 4.6, reviews: 38, status: "Offline" },
            { id: "K-103", name: "Ajay Verma", vehicle: "MH 02 EF 9012", zone: "East Zone (Sec 46-65)", completionRate: 95, rating: 4.8, reviews: 50, status: "Active" }
        ],
        pickups: [
            { id: "#EK-1045", citizen: "Rahul Sharma", collector: "Ravi Kumar", type: "Mixed Electronics", status: "Accepted", conf: "96%", lat: 28.5830, lng: 77.3200, isEwaste: true },
            { id: "#EK-1046", citizen: "Priya Desai", collector: "Searching Nearby...", type: "Paper & Cardboard", status: "Matching", conf: "89%", lat: 28.5600, lng: 77.3550 },
            { id: "#EK-1047", citizen: "Vikram Singh", collector: "Suresh Yadav", type: "Hard Plastics", status: "Completed", conf: "94%", lat: 28.5900, lng: 77.3700 },
            { id: "#EK-1048", citizen: "Neha Gupta", collector: "None (Timed Out)", type: "Scrap Metal", status: "Unassigned", conf: "91%", lat: 28.5450, lng: 77.3300 }
        ],
        rates: [
            { material: "Newspaper (Paper)", price: 14, trend: "+1.5%", trendType: "up" },
            { material: "PET Plastic Bottles", price: 18, trend: "0.0%", trendType: "neutral" },
            { material: "Iron / Steel (Metal)", price: 28, trend: "-2.0%", trendType: "down" },
            { material: "E-Waste (Mixed)", price: 45, trend: "+5.2%", trendType: "up" },
            { material: "Cardboard Cartons", price: 12, trend: "+0.5%", trendType: "up" }
        ],
        weeklyScrap: [120, 190, 150, 220, 180, 310, 280],
        composition: [464, 406, 261, 203, 116] // Paper, Plastic, E-Waste, Metal, Glass
    };

    let data;
    try {
        const stored = localStorage.getItem('ekabadi_prototype_data');
        data = stored ? JSON.parse(stored) : JSON.parse(JSON.stringify(defaultData));
    } catch (e) {
        data = JSON.parse(JSON.stringify(defaultData));
    }

    if (!data.weeklyScrap || !Array.isArray(data.weeklyScrap) || data.weeklyScrap.length === 0) {
        data.weeklyScrap = [120, 190, 150, 220, 180, 310, 280];
    }
    if (!data.composition || !Array.isArray(data.composition)) {
        data.composition = [464, 406, 261, 203, 116];
    }

    function saveData() {
        try {
            localStorage.setItem('ekabadi_prototype_data', JSON.stringify(data));
        } catch (e) {
            console.error('LocalStorage write failed:', e);
        }
    }

    window.resetDemoData = function () {
        if (confirm("Reset prototype back to initial default demo data?")) {
            data = JSON.parse(JSON.stringify(defaultData));
            saveData();
            renderAll();
            initScrapChart();
            initCompositionChart();
            renderMapMarkers();
            showToast("Prototype demo data successfully reset!");
        }
    };

    let currentPickupId = null;
    let currentUserId = null;
    let currentUserType = null;
    let currentPickupFilter = 'all';

    function getInitials(name) {
        if (!name) return 'U';
        const parts = name.trim().split(' ');
        if (parts.length >= 2) {
            return (parts[0][0] + parts[1][0]).toUpperCase();
        }
        return name.slice(0, 2).toUpperCase();
    }

    // =========================================================================
    // 3. NAVIGATION LOGIC & TAB RESIZE HOOKS
    // =========================================================================
    const navItems = document.querySelectorAll('.sidebar-menu li');
    const viewSections = document.querySelectorAll('.view-section');

    window.navigateToTab = function (tabId) {
        const item = document.querySelector(`.sidebar-menu li[data-target="${tabId}"]`);
        if (item) item.click();
    };

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            navItems.forEach(nav => nav.classList.remove('active'));
            item.classList.add('active');
            viewSections.forEach(section => section.classList.add('hidden'));
            const targetId = item.getAttribute('data-target');
            const targetElem = document.getElementById(targetId);
            if (targetElem) {
                targetElem.classList.remove('hidden');
            }
            document.querySelector(".sidebar").classList.remove("active");

            // Chart tab switch fix: resize and update charts when switching back to dashboard
            if (targetId === 'dashboard-view') {
                setTimeout(() => {
                    if (window.scrapChartInstance) {
                        window.scrapChartInstance.resize();
                        window.scrapChartInstance.update();
                    }
                    if (window.compositionChartInstance) {
                        window.compositionChartInstance.resize();
                        window.compositionChartInstance.update();
                    }
                }, 60);
            }

            // Radar Map tab switch fix: Leaflet invalidateSize hook
            if (targetId === 'radar-view') {
                setTimeout(() => {
                    if (window.fleetMapInstance) {
                        window.fleetMapInstance.invalidateSize();
                    } else {
                        initFleetMap();
                    }
                }, 100);
            }
        });
    });

    const menuToggle = document.querySelector(".menu-toggle");
    if (menuToggle) {
        menuToggle.addEventListener("click", () => {
            document.querySelector(".sidebar").classList.toggle("active");
        });
    }

    // =========================================================================
    // 4. CHART INITIALIZATION: SCRAP VOLUME (WITH TIMEFRAMES) & COMPOSITION
    // =========================================================================
    let currentTimeframe = 'weekly';
    const timeframeData = {
        daily: {
            labels: ['8 AM', '10 AM', '12 PM', '2 PM', '4 PM', '6 PM', '8 PM'],
            data: [42, 65, 88, 72, 110, 94, 58]
        },
        weekly: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            data: [120, 190, 150, 220, 180, 310, 280]
        },
        monthly: {
            labels: ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
            data: [820, 1140, 980, 1320, 1210, 1450]
        }
    };

    window.setTimeframe = function (tf) {
        currentTimeframe = tf;
        document.querySelectorAll('.timeframe-btn').forEach(b => b.classList.remove('active'));
        const activeBtn = document.getElementById(`tf-${tf}`);
        if (activeBtn) activeBtn.classList.add('active');

        if (window.scrapChartInstance) {
            const currentData = tf === 'weekly' ? data.weeklyScrap : timeframeData[tf].data;
            window.scrapChartInstance.data.labels = timeframeData[tf].labels;
            window.scrapChartInstance.data.datasets[0].data = [...currentData];
            window.scrapChartInstance.update();

            const totalChip = document.getElementById('chart-total-chip');
            if (totalChip) {
                const totalKg = currentData.reduce((acc, curr) => acc + curr, 0);
                totalChip.innerHTML = `<i class="fa-solid fa-scale-balanced"></i> ${totalKg.toLocaleString()} Kg Total`;
            }
        }
    };

    function updateChartTotalBadge() {
        const totalChip = document.getElementById('chart-total-chip');
        if (totalChip && data.weeklyScrap) {
            const totalKg = data.weeklyScrap.reduce((acc, curr) => acc + curr, 0);
            totalChip.innerHTML = `<i class="fa-solid fa-scale-balanced"></i> ${totalKg.toLocaleString()} Kg Total`;
        }
    }

    function initScrapChart() {
        const chartCanvas = document.getElementById('scrapChart');
        if (!chartCanvas) return;

        if (window.scrapChartInstance) {
            window.scrapChartInstance.destroy();
        }

        const ctx = chartCanvas.getContext('2d');
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        const gradient = ctx.createLinearGradient(0, 0, 0, 260);
        gradient.addColorStop(0, 'rgba(16, 185, 129, 0.40)');
        gradient.addColorStop(0.65, 'rgba(16, 185, 129, 0.08)');
        gradient.addColorStop(1, 'rgba(16, 185, 129, 0.0)');

        window.scrapChartInstance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: timeframeData[currentTimeframe].labels,
                datasets: [{
                    label: 'Scrap Collected (Kg)',
                    data: currentTimeframe === 'weekly' ? [...data.weeklyScrap] : [...timeframeData[currentTimeframe].data],
                    borderColor: '#10b981',
                    borderWidth: 3,
                    backgroundColor: gradient,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#10b981',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    pointRadius: 4,
                    pointHoverRadius: 7,
                    pointHoverBackgroundColor: '#059669',
                    pointHoverBorderColor: '#ffffff',
                    pointHoverBorderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: isDark ? '#1f2937' : '#0f172a',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)',
                        borderWidth: 1,
                        padding: 12,
                        cornerRadius: 8,
                        boxPadding: 6,
                        callbacks: {
                            label: (context) => ` ${context.parsed.y} Kg processed`
                        }
                    }
                },
                scales: {
                    x: {
                        grid: {
                            color: isDark ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.05)',
                            drawBorder: false
                        },
                        ticks: {
                            color: isDark ? '#94a3b8' : '#64748b',
                            font: { family: 'Plus Jakarta Sans', weight: '600' }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: isDark ? 'rgba(255, 255, 255, 0.05)' : 'rgba(0, 0, 0, 0.05)',
                            drawBorder: false
                        },
                        ticks: {
                            color: isDark ? '#94a3b8' : '#64748b',
                            font: { family: 'Plus Jakarta Sans', weight: '600' }
                        }
                    }
                }
            }
        });

        updateChartTotalBadge();
    }

    function initCompositionChart() {
        const compCanvas = document.getElementById('compositionChart');
        if (!compCanvas) return;

        if (window.compositionChartInstance) {
            window.compositionChartInstance.destroy();
        }

        const ctx = compCanvas.getContext('2d');
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';

        window.compositionChartInstance = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Paper & Cartons', 'PET & Hard Plastics', 'E-Waste', 'Metals & Alloys', 'Glass & Others'],
                datasets: [{
                    data: [...data.composition],
                    backgroundColor: ['#10b981', '#3b82f6', '#8b5cf6', '#f59e0b', '#06b6d4'],
                    borderWidth: 2,
                    borderColor: isDark ? '#111827' : '#ffffff',
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '68%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            color: isDark ? '#cbd5e1' : '#475569',
                            font: { family: 'Plus Jakarta Sans', size: 11, weight: '600' },
                            padding: 10,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        backgroundColor: isDark ? '#1f2937' : '#0f172a',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)',
                        borderWidth: 1,
                        padding: 10,
                        cornerRadius: 8,
                        callbacks: {
                            label: (context) => {
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const val = context.parsed;
                                const pct = ((val / total) * 100).toFixed(1);
                                return ` ${context.label}: ${val} Kg (${pct}%)`;
                            }
                        }
                    }
                }
            }
        });
    }

    initScrapChart();
    initCompositionChart();

    window.addEventListener('resize', () => {
        if (window.scrapChartInstance) window.scrapChartInstance.resize();
        if (window.compositionChartInstance) window.compositionChartInstance.resize();
        if (window.fleetMapInstance) window.fleetMapInstance.invalidateSize();
    });

    // =========================================================================
    // 5. LIVE FLEET & DISPATCH RADAR MAP (LEAFLET.JS)
    // =========================================================================
    const hubLocation = [28.5700, 77.3400]; // Delhi-NCR Hub
    let collectorMarkers = [];
    let pickupMarkers = [];

    const mapPickupsData = [
        { id: "#EK-1045", citizen: "Rahul Sharma", type: "Mixed Electronics", status: "Accepted", lat: 28.5830, lng: 77.3200, isEwaste: true },
        { id: "#EK-1046", citizen: "Priya Desai", type: "Paper & Cardboard", status: "Matching", lat: 28.5600, lng: 77.3550 },
        { id: "#EK-1047", citizen: "Vikram Singh", type: "Hard Plastics", status: "Completed", lat: 28.5900, lng: 77.3700 },
        { id: "#EK-1048", citizen: "Neha Gupta", type: "Scrap Metal", status: "Unassigned", lat: 28.5450, lng: 77.3300 }
    ];

    const collectorVehicles = [
        { id: "K-101", name: "Ravi Kumar", vehicle: "MH 04 AB 1234", lat: 28.5750, lng: 77.3300, targetLat: 28.5830, targetLng: 77.3200 },
        { id: "K-103", name: "Ajay Verma", vehicle: "MH 02 EF 9012", lat: 28.5520, lng: 77.3620, targetLat: 28.5600, targetLng: 77.3550 }
    ];

    function initFleetMap() {
        if (!document.getElementById('fleetMap') || typeof L === 'undefined') return;

        if (window.fleetMapInstance) {
            window.fleetMapInstance.remove();
            window.fleetMapInstance = null;
        }

        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        window.fleetMapInstance = L.map('fleetMap', {
            center: hubLocation,
            zoom: 13,
            zoomControl: true
        });

        const tileUrl = isDark
            ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
            : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

        window.mapTileLayer = L.tileLayer(tileUrl, {
            attribution: '&copy; OpenStreetMap &copy; CARTO',
            maxZoom: 19
        }).addTo(window.fleetMapInstance);

        renderMapMarkers();
        startVehicleAnimation();
    }

    function renderMapMarkers() {
        if (!window.fleetMapInstance) return;

        // Clear previous markers
        pickupMarkers.forEach(m => window.fleetMapInstance.removeLayer(m));
        collectorMarkers.forEach(m => window.fleetMapInstance.removeLayer(m));
        pickupMarkers = [];
        collectorMarkers = [];

        // Add pickups
        mapPickupsData.forEach(p => {
            let pulseClass = p.isEwaste ? 'ewaste' : (p.status.toLowerCase() === 'accepted' ? 'accepted' : 'matching');
            const iconHtml = `<div class="map-pickup-pulse ${pulseClass}"><i class="fa-solid ${p.isEwaste ? 'fa-bolt' : 'fa-box'}"></i></div>`;
            const customIcon = L.divIcon({
                html: iconHtml,
                className: 'leaflet-div-icon',
                iconSize: [26, 26],
                iconAnchor: [13, 13]
            });

            const marker = L.marker([p.lat, p.lng], { icon: customIcon }).addTo(window.fleetMapInstance);
            marker.bindPopup(`
                <div style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 0.85rem; padding: 4px; min-width: 170px;">
                    <div style="font-weight: 800; color: #10b981;">${p.id}</div>
                    <div style="font-weight: 700; color: #0f172a; margin: 3px 0;">${p.citizen}</div>
                    <div style="font-size: 0.78rem; color: #64748b;">${p.type}</div>
                    <div style="margin-top: 6px;"><span class="badge ${p.status === 'Accepted' ? 'completed' : 'pending'}">${p.status}</span></div>
                    <button class="btn btn-small btn-primary" style="margin-top: 8px; width: 100%; justify-content: center;" onclick="openPickupModal('${p.id}')">Inspect Request</button>
                </div>
            `);
            pickupMarkers.push(marker);
        });

        // Add collector vehicle GPS trackers
        collectorVehicles.forEach(c => {
            const truckHtml = `<div class="map-truck-marker"><i class="fa-solid fa-truck"></i></div>`;
            const truckIcon = L.divIcon({
                html: truckHtml,
                className: 'leaflet-div-icon',
                iconSize: [34, 34],
                iconAnchor: [17, 17]
            });

            const marker = L.marker([c.lat, c.lng], { icon: truckIcon }).addTo(window.fleetMapInstance);
            marker.bindPopup(`
                <div style="font-family: 'Plus Jakarta Sans', sans-serif; font-size: 0.85rem; padding: 4px; min-width: 170px;">
                    <div style="font-weight: 800; color: #3b82f6;"><i class="fa-solid fa-satellite-dish"></i> ${c.name}</div>
                    <div style="font-size: 0.78rem; font-family: monospace; font-weight: 700; color: #475569; margin: 3px 0;">${c.vehicle}</div>
                    <div style="margin-top: 6px;"><span class="badge completed">Live On-Road GPS</span></div>
                </div>
            `);
            c.marker = marker;
            collectorMarkers.push(marker);
        });

        // Update radar status metrics
        const vehEl = document.getElementById('radar-active-vehicles');
        const pkuEl = document.getElementById('radar-pending-pickups');
        if (vehEl) vehEl.innerText = collectorVehicles.length + 1;
        if (pkuEl) pkuEl.innerText = mapPickupsData.length;
    }

    function startVehicleAnimation() {
        if (window.vehicleInterval) clearInterval(window.vehicleInterval);
        window.vehicleInterval = setInterval(() => {
            if (!window.fleetMapInstance) return;
            collectorVehicles.forEach(c => {
                if (c.targetLat && c.targetLng && c.marker) {
                    c.lat += (c.targetLat - c.lat) * 0.12;
                    c.lng += (c.targetLng - c.lng) * 0.12;
                    c.marker.setLatLng([c.lat, c.lng]);
                }
            });
        }, 3500);
    }

    window.recenterMap = function () {
        if (window.fleetMapInstance) {
            window.fleetMapInstance.setView(hubLocation, 13, { animate: true });
            showToast("Fleet radar map recentered to Delhi-NCR hub.");
        }
    };

    // =========================================================================
    // 6. RENDERERS & DATA VISUALIZATION
    // =========================================================================
    function getStatusBadgeClass(status) {
        switch (status.toLowerCase()) {
            case 'accepted': return 'completed';
            case 'matching': return 'pending';
            case 'completed': return 'active';
            case 'unassigned': return 'offline';
            default: return 'pending';
        }
    }

    function renderDashboard() {
        document.getElementById('stat-citizens').innerText = data.citizens.length;
        document.getElementById('stat-collectors').innerText = data.collectors.filter(c => c.status === 'Active').length;
        document.getElementById('stat-pickups').innerText = data.pickups.filter(p => p.status === 'Matching' || p.status === 'Accepted').length;

        const dashTbody = document.getElementById('dashboard-table-body');
        if (!dashTbody) return;
        dashTbody.innerHTML = '';

        data.pickups.slice(0, 5).forEach((p, idx) => {
            const isMatching = p.status === 'Matching';
            const collectorDisplay = isMatching
                ? `<span style="color: var(--accent-amber); font-weight: 600;"><i class="fa-solid fa-spinner fa-spin" style="margin-right: 5px;"></i>${p.collector}</span>`
                : `<span style="font-weight: 600; color: var(--text-primary);"><i class="fa-solid fa-truck" style="margin-right: 6px; color: var(--primary); font-size: 0.85rem;"></i>${p.collector}</span>`;

            dashTbody.innerHTML += `
                <tr class="${idx === 0 && p.isNew ? 'row-highlight' : ''}">
                    <td><span style="font-weight: 800; color: var(--primary);">${p.id}</span></td>
                    <td><strong>${p.citizen}</strong></td>
                    <td>${collectorDisplay}</td>
                    <td><span class="badge ${getStatusBadgeClass(p.status)}">${p.status}</span></td>
                    <td>
                        <button class="btn btn-small" style="background: var(--primary-light); color: var(--primary);" onclick="openPickupModal('${p.id}')">
                            <i class="fa-solid fa-magnifying-glass"></i> Inspect
                        </button>
                    </td>
                </tr>`;
        });
    }

    function updateFilterCounts() {
        const counts = {
            all: data.pickups.length,
            matching: data.pickups.filter(p => p.status.toLowerCase() === 'matching').length,
            accepted: data.pickups.filter(p => p.status.toLowerCase() === 'accepted').length,
            completed: data.pickups.filter(p => p.status.toLowerCase() === 'completed').length,
            unassigned: data.pickups.filter(p => p.status.toLowerCase() === 'unassigned').length,
        };

        for (const [key, val] of Object.entries(counts)) {
            const el = document.getElementById(`count-${key}`);
            if (el) el.innerText = val;
        }
    }

    window.setPickupFilter = function (filter) {
        currentPickupFilter = filter;
        document.querySelectorAll('#pickup-filter-bar .filter-pill').forEach(btn => {
            btn.classList.remove('active');
        });
        const activeBtn = event ? event.target.closest('.filter-pill') : null;
        if (activeBtn) activeBtn.classList.add('active');
        renderPickups();
    };

    function renderPickups() {
        const tbody = document.getElementById('pickups-table-body');
        if (!tbody) return;
        tbody.innerHTML = '';
        updateFilterCounts();

        const filtered = data.pickups.filter(p => {
            if (currentPickupFilter === 'all') return true;
            return p.status.toLowerCase() === currentPickupFilter.toLowerCase();
        });

        if (filtered.length === 0) {
            tbody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 32px; color: var(--text-muted); font-weight: 600;">No pickup requests found under '${currentPickupFilter}'.</td></tr>`;
            return;
        }

        filtered.forEach((p, idx) => {
            const isMatching = p.status === 'Matching';
            const collectorDisplay = isMatching
                ? `<span style="color: var(--accent-amber); font-weight: 600;"><i class="fa-solid fa-spinner fa-spin" style="margin-right: 5px;"></i>${p.collector}</span>`
                : `<span style="font-weight: 600; color: var(--text-primary);"><i class="fa-solid fa-truck" style="margin-right: 6px; color: var(--primary); font-size: 0.85rem;"></i>${p.collector}</span>`;

            tbody.innerHTML += `
                <tr class="${idx === 0 && p.isNew ? 'row-highlight' : ''}">
                    <td><span style="font-weight: 800; color: var(--primary);">${p.id}</span></td>
                    <td><strong>${p.citizen}</strong></td>
                    <td>${collectorDisplay}</td>
                    <td>
                        <span style="display: inline-flex; align-items: center; gap: 6px; background: var(--bg-surface-subtle); padding: 4px 10px; border-radius: var(--radius-sm); font-size: 0.85rem; font-weight: 600;">
                            <i class="fa-solid fa-box" style="color: var(--primary); font-size: 0.8rem;"></i> ${p.type}
                        </span>
                    </td>
                    <td><span class="badge ${getStatusBadgeClass(p.status)}">${p.status}</span></td>
                    <td style="white-space: nowrap;">
                        <button class="btn btn-small btn-primary" style="margin-right: 6px;" onclick="openPickupModal('${p.id}')">
                            <i class="fa-solid fa-sliders"></i> Inspect
                        </button>
                        <button class="btn btn-small btn-outline" onclick="openManifestModal('${p.id}')" title="Print CPCB Waste Manifest">
                            <i class="fa-solid fa-file-invoice"></i>
                        </button>
                    </td>
                </tr>`;
        });
    }

    function renderUsers(type, elementId) {
        const tbody = document.getElementById(elementId);
        if (!tbody) return;
        tbody.innerHTML = '';

        data[type].forEach(u => {
            const initials = getInitials(u.name);

            let userCell = `
                <div class="user-pill">
                    <div class="user-avatar-initials">${initials}</div>
                    <div>
                        <div style="font-weight: 700; color: var(--text-primary);">${u.name}</div>
                        <div style="font-size: 0.75rem; color: var(--text-muted);">${u.phone || ''}</div>
                    </div>
                </div>
            `;

            if (type === 'citizens') {
                const thirdCol = `<i class="fa-solid fa-location-dot" style="color: var(--primary); margin-right: 5px;"></i> ${u.location}`;
                const extraCol = `<span style="font-weight: 800; color: #f59e0b; font-size: 0.95rem;">${u.coins}</span> <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-muted);">pts</span>`;
                const actionBtns = `
                    <button class="btn btn-small" style="background: var(--primary-light); color: var(--primary); margin-right: 6px;" onclick="openCitizenDetails('${u.id}')">
                        <i class="fa-solid fa-id-card"></i> Profile
                    </button>
                    <button class="btn btn-small" style="background: var(--accent-blue-light); color: var(--accent-blue);" onclick="openUserModal('${type}', '${u.id}')">
                        <i class="fa-solid fa-pen-to-square"></i> Manage
                    </button>
                `;

                tbody.innerHTML += `
                    <tr>
                        <td><span style="font-weight: 800; color: var(--primary);">${u.id}</span></td>
                        <td>${userCell}</td>
                        <td>${thirdCol}</td>
                        <td>${extraCol}</td>
                        <td style="white-space: nowrap;">${actionBtns}</td>
                    </tr>`;
            } else {
                // Collectors View with Enhanced KPIs
                const zone = u.zone || "North Zone (Sec 10-25)";
                const completion = u.completionRate || 95;
                const rating = u.rating || 4.8;
                const reviews = u.reviews || 42;

                const vehicleCell = `
                    <div>
                        <span style="font-family: monospace; font-weight: 700; background: var(--bg-surface-subtle); padding: 3px 8px; border-radius: 4px; border: 1px solid var(--border-color);">${u.vehicle}</span>
                        <div style="font-size: 0.72rem; color: var(--text-muted); margin-top: 3px;"><i class="fa-solid fa-map-pin" style="color: var(--primary);"></i> ${zone}</div>
                    </div>
                `;

                const completionCell = `
                    <div style="min-width: 110px;">
                        <div style="display: flex; justify-content: space-between; font-size: 0.76rem; font-weight: 700; margin-bottom: 2px;">
                            <span>${completion}%</span>
                            <span style="color: var(--primary); font-size: 0.7rem;">Verified</span>
                        </div>
                        <div class="progress-bar-container">
                            <div class="progress-bar-fill" style="width: ${completion}%;"></div>
                        </div>
                    </div>
                `;

                const ratingCell = `
                    <div class="star-rating">
                        <i class="fa-solid fa-star"></i>
                        <span>${rating}</span>
                        <span style="font-size: 0.72rem; color: var(--text-muted); font-weight: 500;">(${reviews})</span>
                    </div>
                `;

                const statusCell = `<span class="badge ${u.status.toLowerCase() === 'active' ? 'completed' : 'offline'}">${u.status}</span>`;
                const actionBtns = `
                    <button class="btn btn-small" style="background: var(--accent-blue-light); color: var(--accent-blue);" onclick="openUserModal('${type}', '${u.id}')">
                        <i class="fa-solid fa-pen-to-square"></i> Manage
                    </button>
                `;

                tbody.innerHTML += `
                    <tr>
                        <td><span style="font-weight: 800; color: var(--primary);">${u.id}</span></td>
                        <td>${userCell}</td>
                        <td>${vehicleCell}</td>
                        <td>${completionCell}</td>
                        <td>${ratingCell}</td>
                        <td>${statusCell}</td>
                        <td style="white-space: nowrap;">${actionBtns}</td>
                    </tr>`;
            }
        });

        // Update collector summary KPI counts if elements exist
        const fleetTotalEl = document.getElementById('stat-fleet-total');
        const fleetUtilEl = document.getElementById('stat-fleet-util');
        if (fleetTotalEl) fleetTotalEl.innerText = data.collectors.length;
        if (fleetUtilEl) {
            const activeCount = data.collectors.filter(c => c.status === 'Active').length;
            const pct = Math.round((activeCount / data.collectors.length) * 100);
            fleetUtilEl.innerText = `${pct}%`;
        }
    }

    function renderRates() {
        const tbody = document.getElementById('rates-table-body');
        if (!tbody) return;
        tbody.innerHTML = '';

        data.rates.forEach((r, index) => {
            let trendIcon = r.trendType === 'up' ? 'fa-arrow-up' : (r.trendType === 'down' ? 'fa-arrow-down' : 'fa-minus');
            tbody.innerHTML += `
                <tr>
                    <td>
                        <strong style="color: var(--text-primary); font-size: 0.95rem;">
                            <i class="fa-solid fa-recycle" style="color: var(--primary); margin-right: 8px;"></i>${r.material}
                        </strong>
                    </td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="font-weight: 700; color: var(--text-secondary);">₹</span>
                            <input type="number" id="rate-input-${index}" class="rate-input" value="${r.price}">
                        </div>
                    </td>
                    <td class="trend-${r.trendType}">
                        <i class="fa-solid ${trendIcon}"></i> ${r.trend}
                    </td>
                    <td>
                        <button class="btn btn-small btn-primary" onclick="updateRate(${index})">
                            <i class="fa-solid fa-floppy-disk"></i> Update
                        </button>
                    </td>
                </tr>
            `;
        });
    }

    function renderAll() {
        renderDashboard();
        renderPickups();
        renderUsers('citizens', 'citizens-table-body');
        renderUsers('collectors', 'collectors-table-body');
        renderRates();
    }
    renderAll();

    // =========================================================================
    // 7. SIMULATE LIVE INCOMING PICKUP REQUEST
    // =========================================================================
    window.simulateNewPickup = function () {
        // Play Chime
        playDispatchChime();

        const sampleCitizens = [
            { name: "Ananya Sharma", location: "Sector 62, Indirapuram", lat: 28.5910, lng: 77.3710 },
            { name: "Rohan Varma", location: "Sector 18, Block B", lat: 28.5720, lng: 77.3240 },
            { name: "Meera Nair", location: "Green Glen Layout", lat: 28.5580, lng: 77.3480 },
            { name: "Kunal Kapoor", location: "Sector 14, Main Road", lat: 28.5810, lng: 77.3190 },
            { name: "Deepak Choudhury", location: "Alpha 1, Greater Noida", lat: 28.5410, lng: 77.3320 }
        ];
        const sampleScrap = [
            { type: "Mixed E-Waste (Laptops & Cables)", isEwaste: true },
            { type: "PET Plastic Bottles (3.2 kg)", isEwaste: false },
            { type: "Corrugated Packaging Boxes", isEwaste: false },
            { type: "Aluminium & Copper Scrap (4.8 kg)", isEwaste: false },
            { type: "Household Mixed Paper & Cartons", isEwaste: false }
        ];

        const randomCit = sampleCitizens[Math.floor(Math.random() * sampleCitizens.length)];
        const randomScrapObj = sampleScrap[Math.floor(Math.random() * sampleScrap.length)];
        const newId = `#EK-${Math.floor(1050 + Math.random() * 8900)}`;

        const newPickup = {
            id: newId,
            citizen: randomCit.name,
            collector: "Searching Nearby...",
            type: randomScrapObj.type,
            status: "Matching",
            conf: `${Math.floor(91 + Math.random() * 8)}%`,
            isNew: true,
            lat: randomCit.lat,
            lng: randomCit.lng,
            isEwaste: randomScrapObj.isEwaste
        };

        // Prepend to array
        data.pickups.unshift(newPickup);

        // Dynamically increment real-time scrap volume on the chart for today
        const simulatedWeight = Math.floor(14 + Math.random() * 22); // 14-36 kg
        if (data.weeklyScrap && data.weeklyScrap.length > 0) {
            data.weeklyScrap[data.weeklyScrap.length - 1] += simulatedWeight;
            if (window.scrapChartInstance) {
                window.scrapChartInstance.data.datasets[0].data = [...data.weeklyScrap];
                window.scrapChartInstance.update('active');
                updateChartTotalBadge();
            }
        }

        // Dynamically increment composition chart
        if (data.composition && data.composition.length > 0) {
            const catIdx = randomScrapObj.isEwaste ? 2 : Math.floor(Math.random() * 2);
            data.composition[catIdx] += simulatedWeight;
            if (window.compositionChartInstance) {
                window.compositionChartInstance.data.datasets[0].data = [...data.composition];
                window.compositionChartInstance.update();
            }
        }

        // Add dynamically onto Leaflet map
        if (window.fleetMapInstance) {
            mapPickupsData.unshift(newPickup);
            renderMapMarkers();
            window.fleetMapInstance.panTo([newPickup.lat, newPickup.lng], { animate: true });
        }

        saveData();
        renderAll();

        showToast(`🔔 LIVE DISPATCH: New pickup ${newId} booked (+${simulatedWeight} Kg scrap logged)!`);
    };

    // =========================================================================
    // 8. EXPORT PICKUPS TO CSV
    // =========================================================================
    window.exportPickupsCSV = function () {
        if (!data.pickups || data.pickups.length === 0) {
            return showToast("No pickups data available to export.");
        }

        const headers = ["Request ID", "Citizen Name", "Matched Collector", "Scrap Material", "Live Status", "AI Confidence"];
        const rows = data.pickups.map(p => [
            `"${p.id}"`,
            `"${p.citizen}"`,
            `"${p.collector}"`,
            `"${p.type}"`,
            `"${p.status}"`,
            `"${p.conf || '94%'}"`
        ]);

        const csvContent = "data:text/csv;charset=utf-8," + [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
        const encodedUri = encodeURI(csvContent);
        const link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", `ekabadi_dispatch_report_${new Date().toISOString().slice(0, 10)}.csv`);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        showToast("CSV dispatch report exported successfully!");
    };

    // =========================================================================
    // 9. SEARCH BAR FILTER
    // =========================================================================
    const searchInput = document.getElementById('global-search');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            const activeSection = document.querySelector('.view-section:not(.hidden)');
            if (!activeSection) return;

            const rows = activeSection.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                if (text.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }

    // =========================================================================
    // 10. REGISTRATION FORM ACTIONS
    // =========================================================================
    window.openModalById = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) modal.style.display = 'block';
    };

    window.submitCitizen = function (e) {
        e.preventDefault();

        const name = document.getElementById('reg-cit-name').value;
        const phone = document.getElementById('reg-cit-phone').value;
        const email = document.getElementById('reg-cit-email').value;
        const location = document.getElementById('reg-cit-location').value;

        const newId = `C-00${data.citizens.length + 1}`;
        data.citizens.push({
            id: newId,
            name: name,
            location: location,
            coins: 0,
            phone: phone,
            email: email
        });

        saveData();
        closeModal('registerCitizenModal');
        document.getElementById('citizenForm').reset();
        renderDashboard();
        renderUsers('citizens', 'citizens-table-body');

        showToast(`Success! ${name} registered successfully as ${newId}.`);
    };

    window.submitCollector = function (e) {
        e.preventDefault();

        const name = document.getElementById('reg-col-name').value;
        const phone = document.getElementById('reg-col-phone').value;
        const vehicle = document.getElementById('reg-col-vehicle').value;
        const zone = document.getElementById('reg-col-zone').value || "North Zone";

        const newId = `K-10${data.collectors.length + 1}`;
        data.collectors.push({
            id: newId,
            name: name,
            vehicle: vehicle,
            zone: zone,
            completionRate: 100,
            rating: 5.0,
            reviews: 1,
            status: "Active"
        });

        saveData();
        closeModal('onboardCollectorModal');
        document.getElementById('collectorForm').reset();
        renderDashboard();
        renderUsers('collectors', 'collectors-table-body');

        showToast(`Success! Collector ${name} onboarded as ${newId}.`);
    };

    // =========================================================================
    // 11. RATE CARD ACTIONS
    // =========================================================================
    window.updateRate = function (index) {
        const newVal = document.getElementById(`rate-input-${index}`).value;
        data.rates[index].price = parseFloat(newVal);
        saveData();
        showToast(`${data.rates[index].material} rate updated locally to ₹${newVal}/Kg`);
    };

    window.syncRates = function () {
        data.rates.forEach((r, i) => {
            const newVal = document.getElementById(`rate-input-${i}`).value;
            r.price = parseFloat(newVal);
        });
        saveData();
        showToast("Success! Global rates synced to Citizen & Collector apps.");
    };

    // =========================================================================
    // 12. USER MANAGEMENT & DETAILS ACTIONS
    // =========================================================================
    window.openCitizenDetails = function (id) {
        const user = data.citizens.find(u => u.id === id);
        if (!user) return;

        document.getElementById('detail-cit-name').innerText = user.name;
        document.getElementById('detail-cit-id').innerText = user.id;
        document.getElementById('detail-cit-phone').innerText = user.phone || "Not provided";
        document.getElementById('detail-cit-email').innerText = user.email || "Not provided";
        document.getElementById('detail-cit-location').innerText = user.location;
        document.getElementById('detail-cit-coins').innerText = `${user.coins} Eco Points`;

        document.getElementById('citizenDetailsModal').style.display = 'block';
    };

    window.openUserModal = function (type, id) {
        currentUserId = id;
        currentUserType = type;
        const user = data[type].find(u => u.id === id);
        if (!user) return;

        if (type === 'citizens') {
            document.getElementById('manage-cit-name').innerText = user.name;
            document.getElementById('manage-cit-id').innerText = user.id;
            document.getElementById('manage-cit-coins').innerText = user.coins;
            document.getElementById('coin-amount').value = "";
            document.getElementById('citizenModal').style.display = 'block';
        } else {
            document.getElementById('col-name').innerText = user.name;
            document.getElementById('col-id').innerText = user.id;
            document.getElementById('col-status').className = `badge ${user.status === 'Active' ? 'completed' : 'offline'}`;
            document.getElementById('col-status').innerText = user.status;
            document.getElementById('collectorModal').style.display = 'block';
        }
    };

    window.modifyCoins = function (action) {
        const amount = parseInt(document.getElementById('coin-amount').value) || 0;
        if (amount <= 0) return showToast("Please enter a valid positive points amount.");

        const user = data.citizens.find(u => u.id === currentUserId);
        if (!user) return;

        if (action === 'add') user.coins += amount;
        else if (action === 'deduct') user.coins = Math.max(0, user.coins - amount);

        saveData();
        document.getElementById('manage-cit-coins').innerText = user.coins;
        document.getElementById('coin-amount').value = '';
        renderUsers('citizens', 'citizens-table-body');
        showToast(`Eco Points successfully ${action === 'add' ? 'added to' : 'deducted from'} ${user.name}`);
    };

    window.toggleCollectorStatus = function () {
        const user = data.collectors.find(u => u.id === currentUserId);
        if (!user) return;

        user.status = user.status === 'Active' ? 'Offline' : 'Active';
        saveData();

        document.getElementById('col-status').innerText = user.status;
        document.getElementById('col-status').className = `badge ${user.status === 'Active' ? 'completed' : 'offline'}`;

        renderDashboard();
        renderUsers('collectors', 'collectors-table-body');
        showToast(`${user.name} status updated to ${user.status}`);
    };

    window.deleteUser = function (type) {
        const userIndex = data[type].findIndex(u => u.id === currentUserId);
        if (userIndex === -1) return;

        const name = data[type][userIndex].name;
        data[type].splice(userIndex, 1);
        saveData();

        renderDashboard();
        renderUsers(type, type + '-table-body');
        closeModal(type === 'citizens' ? 'citizenModal' : 'collectorModal');
        showToast(`Alert: ${name} has been removed from platform records.`);
    };

    // =========================================================================
    // 13. WASTE TRANSFER MANIFEST ACTIONS
    // =========================================================================
    window.openManifestModal = function (id) {
        const pickup = data.pickups.find(p => p.id === id) || data.pickups[0];
        if (!pickup) return;

        document.getElementById('mnf-id').innerText = `#MNF-2026-${pickup.id.replace('#EK-', '')}`;
        document.getElementById('mnf-date').innerText = new Date().toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
        document.getElementById('mnf-hash').innerText = `EK-${Math.random().toString(36).substring(2, 6).toUpperCase()}-${Math.random().toString(36).substring(2, 6).toUpperCase()}`;
        document.getElementById('mnf-citizen-name').innerText = pickup.citizen;
        document.getElementById('mnf-collector-name').innerText = pickup.collector && pickup.collector !== 'Searching Nearby...' ? pickup.collector : 'Ravi Kumar (Fleet Dispatch)';
        document.getElementById('mnf-collector-veh').innerText = 'MH 04 AB 1234';
        document.getElementById('mnf-item-type').innerText = pickup.type;
        document.getElementById('mnf-item-conf').innerHTML = `<span class="badge completed">${pickup.conf || '94%'} AI Verified</span>`;
        document.getElementById('mnf-item-weight').innerHTML = `<strong>${Math.floor(12 + Math.random() * 20)}.${Math.floor(Math.random() * 9)} Kg</strong>`;

        openModalById('manifestModal');
    };

    window.openModalById = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) modal.style.display = "block";
    };

    // =========================================================================
    // 14. GENERAL MODAL & TOAST HANDLERS
    // =========================================================================
    window.openPickupModal = function (id) {
        currentPickupId = id;
        const pickup = data.pickups.find(p => p.id === id);
        if (!pickup) return;

        document.getElementById('modal-title').innerText = `Inspect Request ${pickup.id}`;
        document.getElementById('modal-citizen').innerText = pickup.citizen;
        document.getElementById('modal-type').innerText = pickup.type;
        document.getElementById('modal-ai-type').innerText = pickup.type;
        document.getElementById('modal-ai-conf').innerText = pickup.conf || '94%';
        document.getElementById('modal-collector-status').innerText = pickup.collector;

        document.getElementById('actionModal').style.display = "block";
    };

    window.closeModal = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) modal.style.display = "none";
    };

    window.onclick = (e) => {
        if (e.target.classList.contains('modal')) {
            e.target.style.display = "none";
        }
    };

    window.assignCollector = function () {
        const select = document.getElementById('collector-select');
        if (!select.value) {
            showToast("Please select a collector from the dropdown.");
            return;
        }

        const pickup = data.pickups.find(p => p.id === currentPickupId);
        if (pickup) {
            pickup.collector = select.value;
            pickup.status = "Accepted";
            saveData();
        }

        closeModal('actionModal');
        select.value = "";
        renderDashboard();
        renderPickups();
        showToast(`Admin Override: Reassigned request to ${pickup.collector}`);
    };

    window.showToast = function (message) {
        const toast = document.getElementById("toast");
        const toastText = document.getElementById("toast-text") || toast;
        toastText.innerText = message;
        toast.className = "toast show";
        setTimeout(() => {
            toast.className = toast.className.replace("show", "");
        }, 3000);
    };
});