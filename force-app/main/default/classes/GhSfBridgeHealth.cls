/**
 * Lightweight health marker deployed from GitHub to verify GitHub ↔ Salesforce bridge.
 */
public with sharing class GhSfBridgeHealth {
    @AuraEnabled(cacheable=true)
    public static String ping() {
        return 'ok'; // CI trigger
    }
}