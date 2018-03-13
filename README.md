# RT Ticket Actions

RequestTracker plugin to provide easy access to ticket actions:

![Image of Yaktocat](doc/quickaction-box.png)

## Quickstart

Install:

    # perl Makefile.PL
    # make install

Changes in RT configuration file:

    Plugin('RT::Extension::TicketActions');
    Set($TA_ShowQuickAccess, 1);

### Follow-Up Actions (Due)

A so called follow-up action sets the ticket to status stalled and add a
relative due date with a fixed time (TA_FollowUpTime). This means that requests
should be due in x days. This combination of propertied can be used in searches
or escalations to bring tickets up to users.

In addition holidays of a specific country and specific days of week can be
skipped by the settings TA\_HolidaysCountry and TA\_SkipDaysOfWeek.
Holidays skipping requires the Perl module Date::Holidays and e.g.
Date::Holidays::DE in case of German holidays.

## Configuration

| Key                 | Type    | Description                           |
|---------------------|---------|---------------------------------------|
| TA\_ShowQuickAccess | Boolean | Enable the box if true                |
| TA\_FollowUpDays    | Array   | List of follow-up action              |
| TA\_FollowUpTime    | String  | Time of day when follow-up is reached |
| TA\_HolidaysCountry | String  | Country to skip holidays of           |
| TA\_SkipDaysOfWeek  | Array   | Days of week to skip                  |

### Full example

    Plugin('RT::Extension::TicketActions');

    Set($TA_ShowQuickAccess, 1);
    Set($TA_FollowUpDays, [1, 3, 10]);
    Set($TA_FollowUpTime, '10:00:00');
    Set($TA_HolidaysCountry, 'DE');
    Set($TA_SkipDaysOfWeek, ['sun']);
