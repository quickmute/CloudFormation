## Starting Account number
$start = 1
## Ending Account number
$end = 30
$counter = $start
## Email Prefix
$emailPrefix = "ACME-"
## Email Suffix
$emailDomain = "@ACME.com"
## ROOT OU
$source_ou = "r-acme"
## Training OU
$dest_ou = "ou-acme-coyote"
## AWS Profile
$profile = "AdministratorAccess"

do {
    $padCounter = $counter.ToString().PadLeft(3,"0")
    $accountName = "training" + $padCounter
    ## Create Email address based on increment
    $email = $emailPrefix + $accountName + $emailDomain
    write-host "Create new account", $email
    $newAccount = aws organizations create-account --email $email --account-name $accountName --profile $profile
    $account_status = ($newAccount | out-string | convertfrom-Json).CreateAccountStatus
    $account_status_state = $account_status.State
    $account_status_id = $account_status.Id
    write-host $account_status_state, $account_status_id
    ## Do this as long as the account status is in progress
    while ($account_status_state -eq "IN_PROGRESS")
    {
        ## in implemenation, this takes like3 5 seconds
        write-host "Sleeping for 10 sec"
        sleep -Seconds 10
        $account_status = aws organizations describe-create-account-status --create-account-request-id $account_status_id  --profile $profile
        $create_account_status = ($account_status | out-string | convertfrom-Json).CreateAccountStatus
        $account_status_state = $create_account_status.State
        write-host $account_status_state
    }
    ## Once it succeedes we move the account to proper OU
    if ($account_status_state -eq "SUCCEEDED"){
        $account_status_accountId = $create_account_status.AccountId
        write-host "Successfully created account ", $account_status_accountId
        write-host "Move to proper OU"
        aws organizations move-account --account-id $account_status_accountId --source-parent-id $source_ou --destination-parent-id $dest_ou  --profile $profile
    }else{
        write-host "Failed to create account: ", $account_status_state
    }
    $counter++
} while($counter -le $end)