# Flag 4 – Windows Scheduled Task Persistence

For this task I investigated persistence through Windows Scheduled Tasks. Scheduled Tasks are a Windows feature that allows programs or scripts to run automatically when certain conditions are met, such as when the system starts, a user logs in, or at a specific time. While they are commonly used for legitimate administrative and maintenance tasks, they are also a popular persistence mechanism because they allow code to execute automatically without requiring manual intervention.

The objective of the lab was to locate a scheduled task that contained the flag within its description. To begin the investigation, I enumerated the scheduled tasks using PowerShell:

```powershell
Get-ScheduledTask
```

After reviewing the available tasks, I identified a task named **flag04**. Since the description is not always displayed directly through standard enumeration, I exported the task definition to XML using the following command:

```powershell
Export-ScheduledTask -TaskName "flag04"
```

The exported XML contains the complete task configuration, including its registration information. Within the XML, the `<RegistrationInfo>` section contains a `<Description>` tag that stores the task's description. Inspecting this section revealed the flag hidden inside the description field.

Scheduled tasks are stored internally as XML files because the XML format contains all of the information required by the Task Scheduler service. This includes the task's triggers, actions, security settings, conditions, and metadata such as the author and description. Exporting the task makes it easy to inspect these details without navigating through the graphical interface.

Attackers frequently abuse scheduled tasks to establish persistence after compromising a system. A task can be configured to execute when the computer starts, when a user logs on, at regular intervals, or in response to specific system events. If the task launches a malicious executable or script, the payload will continue to execute automatically according to its configured trigger, allowing an attacker to maintain access even after the system has been restarted.

From a defensive perspective, scheduled tasks should be reviewed regularly during security assessments and incident response investigations. Enumerating tasks, examining their triggers, verifying the executables they launch, and reviewing their descriptions can help identify unauthorized or suspicious persistence mechanisms. This lab demonstrated that useful information can also be hidden within task metadata, reinforcing the importance of thoroughly inspecting task definitions rather than only checking their names or actions.
