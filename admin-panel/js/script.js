document.addEventListener("DOMContentLoaded", () => {
    // =========================================================================
    // 1. THEME ENGINE (DARK / LIGHT MODE)
    // =========================================================================
    const themeToggleBtn = document.getElementById('theme-toggle');
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    const savedTheme = localStorage.getItem('ekabadi_admin_theme') || (prefersDark ? 'dark' : 'light');

    function applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('ekabadi_admin_theme', theme);

        if (themeToggleBtn) {
            themeToggleBtn.innerHTML = theme === 'dark'
                ? '<i class="fa-solid fa-sun" style="color: #f59e0b;"></i>'
                : '<i class="fa-solid fa-moon"></i>';
            themeToggleBtn.setAttribute('title', `Switch to ${theme === 'dark' ? 'Light' : 'Dark'} Mode`);
        }

        // Dynamically update Chart.js canvas colors
        if (window.scrapChartInstance) {
            const isDark = theme === 'dark';
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
            { id: "K-101", name: "Ravi Kumar", vehicle: "MH 04 AB 1234", status: "Active" },
            { id: "K-102", name: "Suresh Yadav", vehicle: "MH 12 CD 5678", status: "Offline" },
            { id: "K-103", name: "Ajay Verma", vehicle: "MH 02 EF 9012", status: "Active" }
        ],
        pickups: [
            { id: "#EK-1045", citizen: "Rahul Sharma", collector: "Ravi Kumar", type: "Mixed Electronics", status: "Accepted", conf: "96%" },
            { id: "#EK-1046", citizen: "Priya Desai", collector: "Searching Nearby...", type: "Paper & Cardboard", status: "Matching", conf: "89%" },
            { id: "#EK-1047", citizen: "Vikram Singh", collector: "Suresh Yadav", type: "Hard Plastics", status: "Completed", conf: "94%" },
            { id: "#EK-1048", citizen: "Neha Gupta", collector: "None (Timed Out)", type: "Scrap Metal", status: "Unassigned", conf: "91%" }
        ],
        rates: [
            { material: "Newspaper (Paper)", price: 14, trend: "+1.5%", trendType: "up" },
            { material: "PET Plastic Bottles", price: 18, trend: "0.0%", trendType: "neutral" },
            { material: "Iron / Steel (Metal)", price: 28, trend: "-2.0%", trendType: "down" },
            { material: "E-Waste (Mixed)", price: 45, trend: "+5.2%", trendType: "up" },
            { material: "Cardboard Cartons", price: 12, trend: "+0.5%", trendType: "up" }
        ],
        weeklyScrap: [120, 190, 150, 220, 180, 310, 280]
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
    // 3. NAVIGATION LOGIC
    // =========================================================================
    const navItems = document.querySelectorAll('.sidebar-menu li');
    const viewSections = document.querySelectorAll('.view-section');

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

            // Chart tab switch fix: resize and update chart when switching back to dashboard
            if (targetId === 'dashboard-view' && window.scrapChartInstance) {
                setTimeout(() => {
                    window.scrapChartInstance.resize();
                    window.scrapChartInstance.update();
                }, 50);
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
    // 4. CHART INITIALIZATION & REAL-TIME TRACKING
    // =========================================================================
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
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Scrap Collected (Kg)',
                    data: [...data.weeklyScrap],
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

    initScrapChart();

    window.addEventListener('resize', () => {
        if (window.scrapChartInstance) {
            window.scrapChartInstance.resize();
        }
    });

    // =========================================================================
    // 5. RENDERERS & DATA VISUALIZATION
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
                    <td>
                        <button class="btn btn-small btn-primary" onclick="openPickupModal('${p.id}')">
                            <i class="fa-solid fa-sliders"></i> Inspect
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

            let thirdCol = '';
            let extraCol = '';
            let actionBtns = '';

            if (type === 'citizens') {
                thirdCol = `<i class="fa-solid fa-location-dot" style="color: var(--primary); margin-right: 5px;"></i> ${u.location}`;
                extraCol = `<span style="font-weight: 800; color: #f59e0b; font-size: 0.95rem;">${u.coins}</span> <span style="font-size: 0.78rem; font-weight: 700; color: var(--text-muted);">pts</span>`;
                actionBtns = `
                    <button class="btn btn-small" style="background: var(--primary-light); color: var(--primary); margin-right: 6px;" onclick="openCitizenDetails('${u.id}')">
                        <i class="fa-solid fa-id-card"></i> Profile
                    </button>
                    <button class="btn btn-small" style="background: var(--accent-blue-light); color: var(--accent-blue);" onclick="openUserModal('${type}', '${u.id}')">
                        <i class="fa-solid fa-pen-to-square"></i> Manage
                    </button>
                `;
            } else {
                thirdCol = `<span style="font-family: monospace; font-weight: 700; background: var(--bg-surface-subtle); padding: 3px 8px; border-radius: 4px; border: 1px solid var(--border-color);">${u.vehicle}</span>`;
                extraCol = `<span class="badge ${u.status.toLowerCase() === 'active' ? 'completed' : 'offline'}">${u.status}</span>`;
                actionBtns = `
                    <button class="btn btn-small" style="background: var(--accent-blue-light); color: var(--accent-blue);" onclick="openUserModal('${type}', '${u.id}')">
                        <i class="fa-solid fa-pen-to-square"></i> Manage
                    </button>
                `;
            }

            tbody.innerHTML += `
                <tr>
                    <td><span style="font-weight: 800; color: var(--primary);">${u.id}</span></td>
                    <td>${userCell}</td>
                    <td>${thirdCol}</td>
                    <td>${extraCol}</td>
                    <td style="white-space: nowrap;">${actionBtns}</td>
                </tr>`;
        });
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
    // 6. SIMULATE LIVE INCOMING PICKUP REQUEST
    // =========================================================================
    window.simulateNewPickup = function () {
        const sampleCitizens = [
            { name: "Ananya Sharma", location: "Sector 62, Indirapuram" },
            { name: "Rohan Varma", location: "Sector 18, Block B" },
            { name: "Meera Nair", location: "Green Glen Layout" },
            { name: "Kunal Kapoor", location: "Sector 14, Main Road" },
            { name: "Deepak Choudhury", location: "Alpha 1, Greater Noida" }
        ];
        const sampleScrap = [
            "Mixed E-Waste (Laptops & Cables)",
            "PET Plastic Bottles (3.2 kg)",
            "Corrugated Packaging Boxes",
            "Aluminium & Copper Scrap (4.8 kg)",
            "Household Mixed Paper & Cartons"
        ];

        const randomCit = sampleCitizens[Math.floor(Math.random() * sampleCitizens.length)];
        const randomScrap = sampleScrap[Math.floor(Math.random() * sampleScrap.length)];
        const newId = `#EK-${Math.floor(1050 + Math.random() * 8900)}`;

        const newPickup = {
            id: newId,
            citizen: randomCit.name,
            collector: "Searching Nearby...",
            type: randomScrap,
            status: "Matching",
            conf: `${Math.floor(91 + Math.random() * 8)}%`,
            isNew: true
        };

        // Prepend to array
        data.pickups.unshift(newPickup);

        // Dynamically increment real-time scrap volume on the chart for today
        const simulatedWeight = Math.floor(12 + Math.random() * 24); // 12-35 kg
        if (data.weeklyScrap && data.weeklyScrap.length > 0) {
            data.weeklyScrap[data.weeklyScrap.length - 1] += simulatedWeight;
            if (window.scrapChartInstance) {
                window.scrapChartInstance.data.datasets[0].data = [...data.weeklyScrap];
                window.scrapChartInstance.update('active');
                updateChartTotalBadge();
            }
        }

        saveData();
        renderAll();

        showToast(`🔔 LIVE DISPATCH: New pickup ${newId} booked (+${simulatedWeight} Kg scrap logged)!`);
    };

    // =========================================================================
    // 7. EXPORT PICKUPS TO CSV
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
    // 8. REAL-TIME SEARCH FILTER
    // =========================================================================
    const searchInput = document.getElementById('global-search');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase().trim();
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
    // 9. REGISTRATION FORM ACTIONS
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

        const newId = `K-10${data.collectors.length + 1}`;
        data.collectors.push({ id: newId, name: name, vehicle: vehicle, status: "Active" });

        saveData();
        closeModal('onboardCollectorModal');
        document.getElementById('collectorForm').reset();
        renderDashboard();
        renderUsers('collectors', 'collectors-table-body');

        showToast(`Success! Collector ${name} onboarded as ${newId}.`);
    };

    // =========================================================================
    // 10. RATE CARD ACTIONS
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
    // 11. USER MANAGEMENT & DETAILS ACTIONS
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
    // 12. GENERAL MODAL & TOAST HANDLERS
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