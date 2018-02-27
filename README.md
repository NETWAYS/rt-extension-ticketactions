# RT Ticket Actions

RequestTracker plugin to provide easy access to ticket actions:

![Image of Yaktocat](doc/quickaction-box.png)

## Quickstart

    Plugin('RT::Extension::TicketActions');
    Set($TA_ShowQuickAccess, 1);

### Follow-Up Actions (Due)

A so called follow-up action sets the ticket to status stalled and add a
relative due date with a fixed time (TA_FollowUpTime). This means that requests
should be due in x days. This combination of propertied can be used in searches
or escalations to bring tickets up to users.



## Configuration

| Key                | Type    | Description                           |
|--------------------|---------|---------------------------------------|
| TA_ShowQuickAccess | Boolean | Enable the box if true                |
| TA_FollowUpDays    | Array   | List of follow-up action              |
| TA_FollowUpTime    | String  | Time of day when follow-up is reached |

### Full example

Plugin('RT::Extension::TicketActions');

Set($TA_ShowQuickAccess, 1);
Set($TA_ShowQuickAccess, qw(1 3 10));
Set($TA_FollowUpTime, '10:00:00');
