import { LightningElement } from 'lwc';
import mainTemplate from './renderTab.html';
import renderTab1Template from './renderTab1Template.html';
import renderTab2Template from './renderTab2Template.html';
import renderTab3Template from './renderTab3Template.html';

export default class RenderTab extends LightningElement {
    selectedTab = 'main';

    handleClick(event) {
        this.selectedTab = event.target.dataset.tab;
    }

    render() {
        switch (this.selectedTab) {
            case '1':
                return renderTab1Template;
            case '2':
                return renderTab2Template;
            case '3':
                return renderTab3Template;
            default:
                return mainTemplate;
        }
    }
}