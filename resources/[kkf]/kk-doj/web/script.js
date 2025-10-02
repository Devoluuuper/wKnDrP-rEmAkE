document.addEventListener('alpine:init', () => {
    Alpine.data('doj', () => ({
        // Global
        showMenu: false,
        currentStep: 1,

        personFirstname: 'None',
        personLastname: 'None',

        personStateId: 1,
        personDateOfBirth: '20-01-2002',

        personMail: '',
        personPhone: '',

        cases: {},
        caseSelection: '',

        incidentDescription: '',

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

        closeMenu() {
            let self = this;

            this.triggerNuiCallback('closeMenu', {}, (cb) => {
                if (cb) {
                    self.showMenu = false;
                }
            });
        },

        handleKeydown(event) {
            const keycode = event.keyCode || event.which;

            if (keycode === 27) { // Escape key
                this.closeMenu();
            }
        },

        formatDate(unixTimestamp) {
            const date = new Date(unixTimestamp * 1000);
        
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0'); // Use numeric month with leading zero
            const year = date.getFullYear();
        
            return `${year}-${month}-${day}`;
        },        

        isFormComplete() {
            let self = this;

            const requiredFields = [
                'personFirstname',
                'personLastname',
                'personStateId',
                'personDateOfBirth',
                'personMail',
                'personPhone',
                'caseSelection',
                'incidentDescription'
            ];
        
            return requiredFields.every(field => {
                const value = self[field];
                return value !== '' && value !== null && value !== undefined;
            });
        },

        finishForm() {
            let self = this;

            if (self.isFormComplete()) {
                self.triggerNuiCallback('sendInfo', { mail: self.personMail, phone: self.personPhone, case: self.caseSelection, description: self.incidentDescription }, (cb) => {
                    if (cb) {
                        self.incidentDescription = '';
                        self.caseSelection = '';

                        self.personMail = '';
                        self.personPhone = '';

                        self.triggerNuiCallback('sendNotification', { type: 'success', msg: 'Avaldus esitatud DOJ-le ülevaatamiseks!'});
                        self.closeMenu();
                        self.currentStep = 1;
                    }
                });
            } else {
                self.triggerNuiCallback('sendNotification', { type: 'error', msg: 'Palun täida kõik väljad!'});
            }
        },

        init() {
            window.addEventListener('message', (event) => {
                const eventData = event.data;

                if (eventData.action === 'openMenu') {
                    this.showMenu = true;

                    if (eventData.data) {
                        if (eventData.data.identification) {
                            let identification = eventData.data.identification;
                            let cases = eventData.data.cases;

                            this.personFirstname = identification.firstname;
                            this.personLastname = identification.lastname;
                    
                            this.personStateId = identification.pid;
                            this.personDateOfBirth = identification.dateofbirth;

                            this.cases = cases;
                        }
                    }
                }
            });
        }
    }));
});