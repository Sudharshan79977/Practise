import { LightningElement, track } from 'lwc';

export default class Timer extends LightningElement {
    @track time = 60; // countdown starts at 60 seconds
    @track isRunning = false;

    timerInterval;

    // Getter to dynamically change button label
    get buttonLabel() {
        return this.isRunning ? 'Pause' : 'Start';
    }

    // Start or pause the timer
    toggleTimer() {
        if (this.isRunning) {
            clearInterval(this.timerInterval);
            this.isRunning = false;
        } else {
            this.isRunning = true;
            this.timerInterval = setInterval(() => {
                if (this.time > 0) {
                    this.time--;
                } else {
                    clearInterval(this.timerInterval);
                    this.isRunning = false;
                    alert('Time is up!');
                }
            }, 1000);
        }
    }
}