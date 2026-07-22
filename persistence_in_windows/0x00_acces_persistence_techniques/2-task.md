# Flag 3 – Windows Service Persistence

For this task I investigated persistence through Windows Services. Windows services are background processes that are managed by the Service Control Manager (SCM). Many legitimate Windows components use services because they can start automatically when the operating system boots and continue running even when no user is logged in. This also makes them an attractive persistence mechanism for attackers.

The objective of the lab was to identify a service that had been configured to maintain persistence. During enumeration I found a service named **flag3**, which immediately stood out because it did not resemble a standard Windows service.

To inspect the service configuration, I used the following command:

```cmd
sc qc flag3
```

This command displays the service configuration, including the startup type and the executable that is launched whenever the service starts. The most important field is `BINARY_PATH_NAME`, since it specifies the program or script that Windows executes for the service.

To view the description assigned to the service, I used:

```cmd
sc qdescription flag3
```

The description is useful because it often explains the intended purpose of the service. In a real environment, attackers sometimes assign descriptions that imitate legitimate Windows services in an attempt to avoid drawing attention. During a security assessment, reviewing service descriptions can help distinguish between genuine and suspicious services.

The service configuration is stored in the Windows Registry under:

```text
HKLM\SYSTEM\CurrentControlSet\Services
```

Every installed service has its own registry key containing configuration values such as the executable path, startup type, service account, and description.

The persistence technique demonstrated in this lab relies on configuring a service to start automatically when Windows boots. Because the Service Control Manager starts automatic services during the boot process, any program configured as the service executable will also run automatically. This allows software to remain persistent even after the computer is restarted, without requiring a user to manually launch it.

This persistence method is commonly used by legitimate software such as antivirus products, backup applications, and monitoring tools. However, attackers also abuse Windows services because they provide a reliable way to execute malicious programs every time the system starts. If a malicious service is installed and configured with an automatic startup type, the payload continues to run after every reboot until the service is removed or disabled.

This exercise demonstrated how important it is to enumerate Windows services during incident response or penetration testing. Examining service names, startup types, executable paths, and descriptions can reveal persistence mechanisms that may otherwise remain unnoticed.
