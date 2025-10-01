document.addEventListener('alpine:init', () => {
    Alpine.data('banking', () => ({
        open: false,
        hovering: false,

        accountName: 'UNKNOWN',

        personalAccountMoney: '0',
        factionAccountMoney: false,

        currentAccount: 'personal',
        currentTransfer: 'personal',
        currentTransaction: 'in',

        recieverIdentifier: '',
        recieverAmount: '',

        outInAmount: '',

        setTabletVisibility(status) {
            this.open = status;

            this.loadData(this.currentAccount)
        },

        swapAccount(account) {
            let self = this;

            this.loadData(account, (cb) => {
                self.currentAccount = account;
            })
        },

        swapTransfer(account) {
            this.currentTransfer = account;
        },
        
        swapTransaction(type) {
            this.currentTransaction = type;
        },

        logs: [],
        invoices: [],

        formatDate(timestamp) {
            const date = new Date(timestamp);
        
            const day = date.getDate();
            const month = date.toLocaleString('et-EE', { month: 'long' });
            const year = date.getFullYear();
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
        
            return `${day}. ${month} ${year} kell ${hours}:${minutes}`;
        },

        timePassed(timestamp) {
            const now = Date.now(); // Current time in milliseconds
            const secondsPassed = Math.floor((now - timestamp) / 1000); // Convert difference to seconds
        
            const secondsInDay = 86400; // Number of seconds in a day
            const days = Math.floor(secondsPassed / secondsInDay); // Calculate days passed
        
            return days;
        },

        loadData(sentAccount, callback) {
            let self = this;
            let account = sentAccount || self.currentAccount

            this.triggerNuiCallback('loadData', { type: account }, (cb) => {
                if (cb) {
                    self.accountName = cb.accountName;
                    self.personalAccountMoney = cb.personalAccountMoney;

                    if (cb.factionAccountMoney) {
                        self.factionAccountMoney = cb.factionAccountMoney;
                    } else {
                        self.factionAccountMoney = false;

                        if (account === 'faction') {
                            self.swapAccount('personal')
                        }
                    }

                    self.logs = cb.logs;
                    self.invoices = cb.invoices;

                    if (callback) callback(true);
                } else {
                    if (callback) callback(true);
                }
            });
        },

        payInvoice(fineId) {
            let self = this;

            this.triggerNuiCallback('payInvoice', { type: self.currentAccount, id: fineId }, (cb) => {
                if (cb) {
                    const foundInvoice = self.invoices.findIndex(invoice => invoice.id === fineId);

                    if (foundInvoice !== -1) {
                        self.invoices.splice(foundInvoice, 1);
                    }

                    self.loadData();
                }
            });
        },

        sendMoney() {
            let self = this;

            this.triggerNuiCallback('sendMoney', { type: self.currentAccount, identifier: self.recieverIdentifier, amount: self.recieverAmount }, (cb) => {
                if (cb) {
                    self.recieverIdentifier = '';
                    self.recieverAmount = '';

                    self.loadData();
                }
            });
        },

        moneyOutIn() {
            let self = this;

            this.triggerNuiCallback('moneyOutIn', { type: self.currentAccount, action: self.currentTransaction, amount: self.outInAmount }, (cb) => {
                if (cb) {
                    self.outInAmount = '';

                    self.loadData();
                }
            });
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

        closeTablet() {
            let self = this;

            this.triggerNuiCallback('closeTablet', {}, (cb) => {
                if (cb) {
                    self.setTabletVisibility(false);
                }
            });
        },

        handleKeydown(event) {
            const keycode = event.keyCode || event.which;

            if (keycode === 27) { // Escape key
                this.closeTablet();
            }
        },

        init() {
            window.addEventListener('message', (event) => {
                const eventData = event.data;

                if (eventData.action === 'openBank') {
                    this.setTabletVisibility(true);
                }
            });
        }
    }));
});