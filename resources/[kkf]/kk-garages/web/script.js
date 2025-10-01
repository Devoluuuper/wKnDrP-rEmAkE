document.addEventListener('alpine:init', () => {
    Alpine.data('garage', () => ({
        // Global
        showMenu: false,
        menuType: '',

        garageName: '',

        changeName: false,
        keyModal: false,

        keyPrice: 0,

        limits: '',

        categories: [],
        tabs: [],

        vehicleName: '',

        //
        currentTab: '',
        vehicleSelected: '',

        toggleNameModal(status) {
            this.changeName = status;
        },

        actionPossible: true,

        changeVehicleName() {
            if (!this.actionPossible) return

            let self = this;

            this.actionPossible = false;

            this.triggerNuiCallback('changeName', { plate: this.vehicleSelected, input: this.vehicleName }, (cb) => {
                if (cb) {
                    let vehicle = self.tabs[self.currentTab].find(item => item.plate === self.vehicleSelected);

                    if (vehicle) {
                        vehicle.title = self.vehicleName;
                    }
                }

                self.toggleNameModal(false);
                self.actionPossible = true;
            }); 
        },

        buyKey() {
            if (!this.actionPossible) return

            let self = this;

            this.actionPossible = false;

            this.triggerNuiCallback('buyKey', { plate: this.vehicleSelected }, (cb) => {
                self.toggleKeyModal(false);
                self.actionPossible = true;
            }); 
        },

        toggleKeyModal(status) {
            this.keyModal = status;
        },

        spawnVehicle(plate) {
            if (!this.actionPossible) return

            let self = this;

            this.actionPossible = false;

            this.triggerNuiCallback('spawnVehicle', { plate: plate }, (cb) => {
                if (cb) {
                    self.closeMenu()
                }

                self.actionPossible = true;
            }); 
        },

        vehicleInfo: '',
        vehicleInfo: [
            body = 0,
            engine = 0,
            fuel = 0
        ],

        selectVehicle(index) {
            if (!this.actionPossible) return

            let self = this;

            if (this.vehicleSelected != this.tabs[this.currentTab][index].plate) {
                this.vehicleSelected = this.tabs[this.currentTab][index].plate;
                this.vehicleName = this.tabs[this.currentTab][index].title;

                this.actionPossible = false;
    
                this.triggerNuiCallback('previewVehicle', { plate: self.vehicleSelected }, (cb) => {
                    if (cb) {
                        
                    }

                    self.actionPossible = true;
                });
            }
        },

        vehicleSearch: '',

        get filteredVehicles() {
            if (!this.vehicleSearch) {
                return this.categories;
            }

            return this.categories.filter(v => 
                v.toLowerCase().includes(this.vehicleSearch.toLowerCase())
            );
        },

        tabSearch: '',
        
        get filteredTabVehicles() {
            if (!this.tabSearch) {
                return this.tabs[this.currentTab];
            }

            return this.tabs[this.currentTab].filter(v => 
                v.plate.toLowerCase().includes(this.tabSearch.toLowerCase()) ||
                v.title.toLowerCase().includes(this.tabSearch.toLowerCase())
            );
        },

        triggerNuiCallback(endpoint, data, callback) {
            fetch(`https://${GetParentResourceName()}/${endpoint}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (callback) callback(data);
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },

        setMenuVisibility(status, type) {
            this.menuType = type;
            this.showMenu = status;
        },

        closeMenu() {
            let self = this;

            this.triggerNuiCallback('closeMenu', {}, (cb) => {
                if (cb) {
                    self.toggleNameModal(false);
                    self.toggleKeyModal(false);
                    self.setMenuVisibility(false);

                    setTimeout(() => {
                        self.vehicleName = '';
                        self.currentTab = '';
                        self.vehicleSelected = '';
                        self.vehicleSearch = '';
                        self.tabSearch = '';
                    }, 500);
                }
            });
        },

        handleKeydown(event) {
            const keycode = event.keyCode || event.which;

            if (keycode === 27) { // Escape key
                this.closeMenu();
            }
        },

        arrayCounter(inputs) {
            let counter = 0;

            if (inputs) {
                for (const input of inputs) {
                    counter += 1;
                }
            }

            return counter;
        },

        init() {
            window.addEventListener('message', (event) => {
                const eventData = event.data;

                if (eventData.action === 'openMenu') {
                    this.setMenuVisibility(true, eventData.data.type);
                    this.garageName = eventData.data.label; 

                    this.keyPrice = eventData.data.keyPrice;

                    this.limits = eventData.data.limits;

                    this.tabs = eventData.data.tabs;
                    this.categories = eventData.data.categories;
                }
            });
        }
    }));
});