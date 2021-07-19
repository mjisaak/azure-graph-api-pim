$scopes = @(
    "PrivilegedAccess.Read.AzureAD",
    "RoleAssignmentSchedule.ReadWrite.Directory", 
    "PrivilegedAccess.ReadWrite.AzureAD"    
)

Connect-MgGraph -Scopes $scopes


[array]$pendingApprovals = Invoke-GraphRequest `
    -Method GET `
    -Uri '/beta/roleManagement/directory/roleAssignmentScheduleRequests?$filter=(status eq ''PendingApproval'')' | 
Select-Object -ExpandProperty value


$approvalSteps = Invoke-GraphRequest `
    -Method GET `
    -Uri ('/beta/roleManagement/directory/roleAssignmentApprovals/{0}' -f $pendingApprovals[0].approvalId) | 
Select-Object -ExpandProperty steps | Where-Object status -eq InProgress


$body = @{
    reviewResult  = 'Approve'
    justification = 'Seems legit'
}

Invoke-GraphRequest `
    -Method PATCH `
    -Uri ('https://graph.microsoft.com/beta/roleManagement/directory/roleAssignmentApprovals/{0}/steps/{1}' -f $pendingApprovals[0].approvalId, $approvalSteps.id) `
    -Body $body
