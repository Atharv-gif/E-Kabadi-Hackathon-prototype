document.addEventListener("DOMContentLoaded", () => {
    // --- 1. MOCK SYSTEM DATABASE ---
    // Added phone and email fields so the Details modal has data to display
    const data = {
        citizens: [
            { id: "C-001", name: "Rahul Sharma", location: "Sector 14", coins: 450, phone: "+91 98765 43210", email: "rahul@email.com" },
            { id: "C-002", name: "Priya Desai", location: "MG Road", coins: 120, phone: "+91 91234 56789", email: "priya@email.com" },
            { id: "C-003", name: "Vikram Singh", location: "Kalyan Nagar", coins: 890, phone: "+91 99887 76655", email: "vikram@email.com" }
        ],
        collectors: [
            { id: "K-101", name: "Ravi Kumar", vehicle: "MH 04 AB 1234", status: "Active" },
            { id: "K-102", name: "Suresh", vehicle: "MH 12 CD 5678", status: "Offline" },
            { id: "K-103", name: "Ajay Verma", vehicle: "MH 02 EF 9012", status: "Active" }
        ],
        pickups: [
            { id: "#EK-1045", citizen: "Rahul Sharma", collector: "Ravi Kumar", type: "Mixed Electronics", status: "Accepted", conf: "96%" },
            { id: "#EK-1046", citizen: "Priya Desai", collector: "Searching Nearby...", type: "Paper & Cardboard", status: "Matching", conf: "89%" },
            { id: "#EK-1047", citizen: "Vikram Singh", collector: "Suresh", type: "Hard Plastics", status: "Completed", conf: "94%" },
            { id: "#EK-1048", citizen: "Neha Gupta", collector: "None (Timed Out)", type: "Scrap Metal", status: "Unassigned", conf: "91%" }
        ],
        rates: [
            { material: "Newspaper (Paper)", price: 14, trend: "+1.5%", trendType: "up" },
            { material: "PET Plastic Bottles", price: 18, trend: "0.0%", trendType: "neutral" },
            { material: "Iron/Steel (Metal)", price: 28, trend: "-2.0%", trendType: "down" },
            { material: "E-Waste (Mixed)", price: 45, trend: "+5.2%", trendType: "up" },
            { material: "Cardboard Cartons", price: 12, trend: "+0.5%", trendType: "up" }
        ]
    };

    let currentPickupId = null;
    let currentUserId = null;
    let currentUserType = null;

    // --- 2. NAVIGATION LOGIC ---
    const navItems = document.querySelectorAll('.sidebar-menu li');
    const viewSections = document.querySelectorAll('.view-section');

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            navItems.forEach(nav => nav.classList.remove('active'));
            item.classList.add('active');
            viewSections.forEach(section => section.classList.add('hidden'));
            const targetId = item.getAttribute('data-target');
            document.getElementById(targetId).classList.remove('hidden');
        });
    });

    document.querySelector(".menu-toggle").addEventListener("click", () => {
        document.querySelector(".sidebar").classList.toggle("active");
    });

    // --- 3. CHART INITIALIZATION ---
    const ctx = document.getElementById('scrapChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Scrap Processed (kg)',
                data: [120, 190, 150, 220, 180, 310, 280],
                borderColor: '#2ecc71',
                backgroundColor: 'rgba(46, 204, 113, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });

    // --- 4. RENDERERS ---
    function getStatusBadgeClass(status) {
        switch(status.toLowerCase()) {
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
        document.getElementById('stat-pickups').innerText = data.pickups.length;

        const dashTbody = document.getElementById('dashboard-table-body');
        dashTbody.innerHTML = '';
        data.pickups.forEach(p => { 
            dashTbody.innerHTML += `
                <tr>
                    <td><strong>${p.id}</strong></td>
                    <td>${p.citizen}</td>
                    <td>${p.collector}</td>
                    <td><span class="badge ${getStatusBadgeClass(p.status)}">${p.status}</span></td>
                    <td><button class="btn btn-small" onclick="openPickupModal('${p.id}')">Inspect</button></td>
                </tr>`;
        });
    }

    function renderPickups() {
        const tbody = document.getElementById('pickups-table-body');
        tbody.innerHTML = '';
        data.pickups.forEach(p => {
            tbody.innerHTML += `
                <tr>
                    <td><strong>${p.id}</strong></td>
                    <td>${p.citizen}</td>
                    <td>${p.collector}</td>
                    <td>${p.type}</td>
                    <td><span class="badge ${getStatusBadgeClass(p.status)}">${p.status}</span></td>
                    <td><button class="btn btn-small" style="background: var(--primary-color)" onclick="openPickupModal('${p.id}')">Inspect</button></td>
                </tr>`;
        });
    }

    function renderUsers(type, elementId) {
        const tbody = document.getElementById(elementId);
        tbody.innerHTML = '';
        data[type].forEach(u => {
            const extraCol = type === 'citizens' 
                ? `${u.coins} <i class="fa-solid fa-coins" style="color:#f1c40f"></i>` 
                : `<span class="badge ${u.status.toLowerCase() === 'active' ? 'completed' : 'offline'}">${u.status}</span>`;
            const thirdCol = type === 'citizens' ? u.location : u.vehicle;
            
            // Generate action buttons
            let actionBtns = '';
            if (type === 'citizens') {
                actionBtns = `
                    <button class="btn btn-small" style="background: #2ecc71; margin-right: 5px;" onclick="openCitizenDetails('${u.id}')">View Details</button>
                    <button class="btn btn-small" style="background: #3498db" onclick="openUserModal('${type}', '${u.id}')">Manage</button>
                `;
            } else {
                actionBtns = `<button class="btn btn-small" style="background: #3498db" onclick="openUserModal('${type}', '${u.id}')">Manage</button>`;
            }

            tbody.innerHTML += `
                <tr>
                    <td><strong>${u.id}</strong></td>
                    <td>${u.name}</td>
                    <td>${thirdCol}</td>
                    <td>${extraCol}</td>
                    <td style="white-space: nowrap;">${actionBtns}</td>
                </tr>`;
        });
    }

    function renderRates() {
        const tbody = document.getElementById('rates-table-body');
        tbody.innerHTML = '';
        data.rates.forEach((r, index) => {
            let trendIcon = r.trendType === 'up' ? 'fa-arrow-up' : (r.trendType === 'down' ? 'fa-arrow-down' : 'fa-minus');
            tbody.innerHTML += `
                <tr>
                    <td><strong>${r.material}</strong></td>
                    <td><input type="number" id="rate-input-${index}" class="rate-input" value="${r.price}" style="width: 100px;"></td>
                    <td class="trend-${r.trendType}"><i class="fa-solid ${trendIcon}"></i> ${r.trend}</td>
                    <td><button class="btn btn-small" style="background: var(--secondary-color)" onclick="updateRate(${index})">Update</button></td>
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

    // --- 5. REGISTRATION FORM ACTIONS ---
    window.openModalById = function(modalId) {
        document.getElementById(modalId).style.display = 'block';
    };

    window.submitCitizen = function(e) {
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
        
        closeModal('registerCitizenModal');
        document.getElementById('citizenForm').reset();
        renderDashboard();
        renderUsers('citizens', 'citizens-table-body');
        
        showToast(`Success! ${name} registered successfully as ${newId}.`);
    };

    window.submitCollector = function(e) {
        e.preventDefault();
        
        const name = document.getElementById('reg-col-name').value;
        const vehicle = document.getElementById('reg-col-vehicle').value;
        
        const newId = `K-10${data.collectors.length + 1}`;
        data.collectors.push({ id: newId, name: name, vehicle: vehicle, status: "Active" });
        
        closeModal('onboardCollectorModal');
        document.getElementById('collectorForm').reset();
        renderDashboard();
        renderUsers('collectors', 'collectors-table-body');
        
        showToast(`Success! Collector ${name} onboarded successfully as ${newId}.`);
    };

    // --- 6. RATE CARD ACTIONS ---
    window.updateRate = function(index) {
        const newVal = document.getElementById(`rate-input-${index}`).value;
        data.rates[index].price = parseFloat(newVal);
        showToast(`${data.rates[index].material} rate updated locally to ₹${newVal}`);
    };

    window.syncRates = function() {
        data.rates.forEach((r, i) => {
            const newVal = document.getElementById(`rate-input-${i}`).value;
            r.price = parseFloat(newVal);
        });
        showToast("Success! Global rates synced to Citizen & Collector apps.");
    };

    // --- 7. USER MANAGEMENT & DETAILS ACTIONS ---
    
    // NEW: Open Citizen Profile Details Modal
    window.openCitizenDetails = function(id) {
        const user = data.citizens.find(u => u.id === id);
        if(!user) return;

        document.getElementById('detail-cit-name').innerText = user.name;
        document.getElementById('detail-cit-id').innerText = user.id;
        document.getElementById('detail-cit-phone').innerText = user.phone || "Not provided";
        document.getElementById('detail-cit-email').innerText = user.email || "Not provided";
        document.getElementById('detail-cit-location').innerText = user.location;
        document.getElementById('detail-cit-coins').innerText = user.coins;

        document.getElementById('citizenDetailsModal').style.display = 'block';
    };

    window.openUserModal = function(type, id) {
        currentUserId = id;
        currentUserType = type;
        const user = data[type].find(u => u.id === id);
        
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

    window.modifyCoins = function(action) {
        const amount = parseInt(document.getElementById('coin-amount').value) || 0;
        if(amount <= 0) return showToast("Enter a valid coin amount.");
        
        const user = data.citizens.find(u => u.id === currentUserId);
        if(action === 'add') user.coins += amount;
        else if(action === 'deduct') user.coins = Math.max(0, user.coins - amount);
        
        document.getElementById('manage-cit-coins').innerText = user.coins;
        document.getElementById('coin-amount').value = '';
        renderUsers('citizens', 'citizens-table-body');
        showToast(`Eco-Coins successfully ${action === 'add' ? 'added to' : 'deducted from'} ${user.name}`);
    };

    window.toggleCollectorStatus = function() {
        const user = data.collectors.find(u => u.id === currentUserId);
        user.status = user.status === 'Active' ? 'Offline' : 'Active';
        
        document.getElementById('col-status').innerText = user.status;
        document.getElementById('col-status').className = `badge ${user.status === 'Active' ? 'completed' : 'offline'}`;
        
        renderDashboard(); 
        renderUsers('collectors', 'collectors-table-body');
        showToast(`${user.name} is now ${user.status}`);
    };

    window.deleteUser = function(type) {
        const userIndex = data[type].findIndex(u => u.id === currentUserId);
        const name = data[type][userIndex].name;
        data[type].splice(userIndex, 1); 
        
        renderDashboard();
        renderUsers(type, type + '-table-body');
        closeModal(type === 'citizens' ? 'citizenModal' : 'collectorModal');
        showToast(`Alert: ${name} has been removed from the platform.`);
    };

    // --- 8. GENERAL MODAL & TOAST HANDLERS ---
    window.openPickupModal = function(id) {
        currentPickupId = id;
        const pickup = data.pickups.find(p => p.id === id);
        
        document.getElementById('modal-title').innerText = `Inspect Request ${pickup.id}`;
        document.getElementById('modal-citizen').innerText = pickup.citizen;
        document.getElementById('modal-type').innerText = pickup.type;
        document.getElementById('modal-ai-type').innerText = pickup.type;
        document.getElementById('modal-ai-conf').innerText = pickup.conf || '94%';
        document.getElementById('modal-collector-status').innerText = pickup.collector;
        
        document.getElementById('actionModal').style.display = "block";
    };

    window.closeModal = function(modalId) {
        document.getElementById(modalId).style.display = "none";
    };

    window.onclick = (e) => { 
        if (e.target.classList.contains('modal')) {
            e.target.style.display = "none";
        }
    };

    window.assignCollector = function() {
        const select = document.getElementById('collector-select');
        if(!select.value) {
            showToast("Please select a collector from the dropdown.");
            return;
        }

        const pickup = data.pickups.find(p => p.id === currentPickupId);
        if(pickup) {
            pickup.collector = select.value;
            pickup.status = "Accepted"; 
        }
        
        closeModal('actionModal');
        select.value = ""; 
        renderDashboard();
        renderPickups();
        showToast(`Admin Override: Reassigned request to ${pickup.collector}`);
    };

    window.showToast = function(message) {
        const toast = document.getElementById("toast");
        toast.innerText = message;
        toast.className = "toast show";
        setTimeout(() => { toast.className = toast.className.replace("show", ""); }, 3000);
    };
});