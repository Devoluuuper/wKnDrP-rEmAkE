document.addEventListener('alpine:init', () => {
    Alpine.data('hud', () => ({
        mapStatus: true,

        hudActive: false,

        radioActive: false,
        radioTalking: false,

        microphoneActive: false,
        microphoneHeight: 23,

        healthHeight: 35,
        armorHeight: 0,
        foodHeight: 35,
        thirstHeight: 35,
        stressHeight: 0,
        oxygenHeight: 35,
        cruiseActive: false,

        adminMode: false,

        carActive: false,

        fuelWidth: 0,

        currentGear: 0,
        currentSpeed: {
            0: 0,
            1: 0,
            2: 0
        },

        seatbelt: false,

        compassActive: false,

        heading: 0,
        street: '',
        zone: '',

        instructionsActive: false,
        instructionHeader: '',
        instructionDescription: '',

        instructionsPopUP: false,
        instructionPopUPHeader: '',
        instructionPopUPDescription: '',

        interactActive: false,
        interactKey: '',
        interactText: '',

        updateSpeed(unitSpeed) {
            if (unitSpeed !== undefined) {
                // Ensure unitSpeed is a number and convert to string
                let speedString = unitSpeed.toString().padStart(3, '0');
    
                // Cap the speedString to "999" if it's longer than 3 characters
                if (unitSpeed > 999) {
                    speedString = "999";
                }
    
                // Update currentSpeed with each character of the speedString
                for (let i = 0; i < 3; i++) {
                    this.currentSpeed[i] = parseInt(speedString[i], 10);
                }
            }
        },

        calculateHeight(val) {
            return (35 * val) / 100;
        },

        notifications: [],
        
        addNotification(type, message, timer) {
            // Check if a notification with the same type and message already exists
            const isDuplicate = this.notifications.some(notification => 
                notification.type === type && notification.message === message
            );
        
            // Only add the notification if it's not a duplicate
            if (!isDuplicate) {
                const id = Date.now();
                this.notifications.push({ id, type, message });
        
                // Remove the notification after the specified timer
                setTimeout(() => {
                    this.notifications = this.notifications.filter(notification => notification.id !== id);
                }, timer);
            }
        },        
        
        init() {
            window.addEventListener('message', (event) => {
                const eventData = event.data;

                if (eventData.action === 'hideAll') {
                    this.mapStatus = false;
                } else if (eventData.action === 'showAll') {
                    this.mapStatus = true;
                } else if (eventData.action === 'toggleHud') {
                    this.hudActive = eventData.data.status;
                } else if (eventData.action === 'toggleTalking') {
                    this.microphoneActive = eventData.data.status;
                } else if (eventData.action === 'proximityDistance') {
                    const heightMap = {
                        1: 33,
                        2: 66,
                        3: 100
                    };
                    
                    this.microphoneHeight = this.calculateHeight(heightMap[eventData.data.value]) || this.calculateHeight(heightMap[2]);
                } else if (eventData.action === 'updateNeeds') {
                    this.foodHeight = this.calculateHeight(eventData.data.food);
                    this.thirstHeight = this.calculateHeight(eventData.data.thirst);
                    this.stressHeight = this.calculateHeight(eventData.data.stress);
                } else if (eventData.action === 'updateHealth') {
                    this.healthHeight = this.calculateHeight(eventData.data.health);
                    this.armorHeight = this.calculateHeight(eventData.data.armor);
                    this.oxygenHeight = this.calculateHeight(eventData.data.oxygen);
                } else if (eventData.action === 'updateCar') {
                    this.updateSpeed(eventData.data.speed);

                    this.fuelWidth = eventData.data.fuel;
                    this.currentGear = eventData.data.gear;
                } else if (eventData.action === 'updateHeading') {
                    this.heading = eventData.data.heading;
                } else if (eventData.action === 'updateStreet') {
                    this.street = eventData.data.street;
                    this.zone = eventData.data.zone;
                } else if (eventData.action === 'carToggle') {
                    this.carActive = eventData.data.status;
                } else if (eventData.action === 'compassToggle') {
                    this.compassActive = eventData.data.status;
                } else if (eventData.action === 'setSeatbelt') {
                    this.seatbelt = eventData.data.status;
                } else if (eventData.action === 'toggleRadio') {
                    this.radioActive = eventData.data.status;
                } else if (eventData.action === 'radioSpeaking') {
                    this.radioTalking = eventData.data.status;
                } else if (eventData.action === 'adminMode') {
                    this.adminMode = eventData.data.status;
                } else if (eventData.action === 'cruseControl') {
                    this.cruiseActive = eventData.data.status;
                } else if (eventData.action === 'showInstruction') {
                    this.instructionsActive = true;
                    this.instructionHeader = eventData.data.title;
                    this.instructionDescription = eventData.data.description;
                } else if (eventData.action === 'hideInstruction') {
                    this.instructionsActive = false;
                } else if (eventData.action === 'showPopUP') {
                    this.instructionsPopUP = true;
                    this.instructionPopUPHeader = eventData.data.title;
                    this.instructionPopUPDescription = eventData.data.description;
                } else if (eventData.action === 'hidePopUP') {
                    this.instructionsPopUP = false;
                } else if (eventData.action === 'showInteract') {
                    this.interactActive = true;
                    this.interactKey = eventData.data.key || '';
                    this.interactText = eventData.data.text;
                } else if (eventData.action === 'hideInteract') {
                    this.interactActive = false;
                } else if (eventData.action === 'showNotification') {
                    this.addNotification(eventData.data.type, eventData.data.message, eventData.data.timer)
                }
            });

            window.addEventListener('message', (event) => {
                if (event.data.type === 'updateHud') {
                    foodHeight = event.data.foodHeight
                    thirstHeight = event.data.thirstHeight
                    stressHeight = event.data.stressHeight
                    oxygenHeight = event.data.oxygenHeight
                    health = event.data.health
                }
            });
        }
    }));
});