import { LightningElement } from 'lwc';
import basePath from '@salesforce/community/basePath';
import isGuest from '@salesforce/user/isGuest';

export default class Logoutexperience extends LightningElement {
  

    get isGuest() {
        return isGuest;
    }

    get logoutLink() {
        const sitePrefix = basePath.replace("/", "");
        return '/${sitePrefix}vforcesite/secur/logout.jsp';
    }
}