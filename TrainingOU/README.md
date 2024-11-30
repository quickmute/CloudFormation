# Sandbox accounts for Events Support Files
These are used to get accounts ready for "Sandbox accounts for events"
https://github.com/awslabs/sandbox-accounts-for-events/blob/main/docs/accounts.md

# Steps
1. Log into Management Account
2. Create Sandbox OU
3. Create Trainer Account under Sandbox OU
4. Create Training OU under Sandbox OU
5. Attach `children-scp.json` as instructed onto Training OU
6. Obtain credential for Organization Management Account
7. Run `createAccounts.ps1` to create children accounts under Training OU
8. Deploy Cloudformation Stackset using `main.yaml`