document.addEventListener('alpine:init', () => {
    Alpine.data('emotes', () => ({
        open: false,
        currentPage: 'home',

        search: '',

        loop: false,
        pause: false,
        move: false,
        place: false,
        favorites: [],

        isFavorite(name) {
            return this.favorites.includes(name);
        },

        allAnimations: [],
        animations: [],

        labelText: false,

        async loadData() {
            try {
                let response = await fetch('../animations.json');
                let data = await response.json();
                this.allAnimations = data;
            } catch (error) {
                console.error('Error loading data:', error);
            }
        },

        pageCount(page) {
            let count = 0;
        
            this.allAnimations.forEach(item => {
                if (item.type === page || page === 'home') {
                    count += 1;
                }
            });
        
            return count;
        },

        get getFavorites() {
            let self = this;
            let items = []; // Initialize as an array
        
            for (let i = 0; i < self.favorites.length; i++) {
                let item = self.favorites[i];
        
                const animation = self.allAnimations.find(anim => anim.title === item);
        
                if (animation) { // Check if animation exists
                    items.push(animation); // Push the animation object into the items array
                }
            }
        
            return items; // Return the populated items array
        },

        loadPage(page) {
            let items = [];
        
            this.allAnimations.forEach(item => {
                if (item.type === page || page === 'home') {
                    items.push(item);
                }
            });
        
            this.animations = items;
        },

        playAnimation(title) {
            this.triggerNuiCallback('playAnimation', { title: title });
            this.closeMenu()
        },

        cancelAnimation() {
            this.triggerNuiCallback('cancelAnimation', {});
        },

        deleteObjects() {
            this.triggerNuiCallback('deleteObjects', {});
        },

        changePage(page) {
            this.loadPage(page);
            this.currentPage = page;
        },

        optionToggle(option, data) {
            if (option === 'loop') {
                this.loop = !this.loop;
            } else if (option === 'pause') {
                this.pause = !this.pause;
            } else if (option === 'move') {
                this.move = !this.move;
            } else if (option === 'place') {
                this.place = !this.place;
            } else if (option === 'favorites') {
                if (this.isFavorite(data)) {
                    this.favorites = this.favorites.filter(fav => fav !== data);
                } else {
                    this.favorites = [...this.favorites, data];
                }
            }

            let self = this;

            this.triggerNuiCallback('syncSettings', { loop: self.loop, pause: self.pause, move: self.move, place: self.place, favorites: self.favorites });
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

        get emoteSearch() {
            if (!this.search) {
                return this.animations;
            }

            return this.animations.filter(v => 
                v.subtitle.toLowerCase().includes(this.search.toLowerCase()) ||
                v.title.toLowerCase().includes(this.search.toLowerCase())
            );
        },

        setVisibility(status) {
            this.open = status;
        },

        closeMenu() {
            let self = this;

            this.triggerNuiCallback('closeMenu', {}, (cb) => {
                if (cb) {
                    self.setVisibility(false);
                }
            });
        },

        handleKeydown(event) {
            const keycode = event.keyCode || event.which;

            if (keycode === 27) { // Escape key
                this.closeMenu();
            }
        },

        init() {
            window.addEventListener('message', (event) => {
                const eventData = event.data;

                if (eventData.action === 'openMenu') {
                    this.loadPage(this.currentPage);
                    this.setVisibility(true);

                    this.loop = eventData.settings.loop;
                    this.pause = eventData.settings.pause;
                    this.move = eventData.settings.move;
                    this.place = eventData.settings.place;
                    this.favorites = eventData.settings.favorites;
                } else if (eventData.action === 'sendEmotes') {
                    this.allAnimations = eventData.data;
                }
            });

            this.loadData();
        }
    }));
});