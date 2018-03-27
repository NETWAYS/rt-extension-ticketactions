# Ticket Actions Extension for Request Tracker

#### Table of Contents

1. [About](#about)
2. [License](#license)
3. [Support](#support)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Configuration](#configuration)

## About

Provides easy access to frequently used ticket actions:

![Screenshot](doc/quickaction-box.png)

Also so called "follow-up" actions set the ticket status to `stalled` and add a relative due date with a fixed time.
This means that a ticket should be due in x days. This combination of properties can be used in searches or escalations
to bring tickets up to users. In addition holidays of a specific country and specific days of week can be skipped
automatically, if enabled.

In addition to that, this extension provides navigation items if you have opened this ticket from a search result
listing. You can navigate between search result tickets (first, previous, next, last), open the search result list
again or even modify the search query.

## License

This project is licensed under the terms of the GNU General Public License Version 2.

This software is Copyright (c) 2018 by NETWAYS GmbH <[support@netways.de](mailto:support@netways.de)>.

## Support

For bugs and feature requests please head over to our [issue tracker](https://github.com/NETWAYS/rt-extension-ticketactions/issues).
You may also send us an email to [support@netways.de](mailto:support@netways.de) for general questions or to get technical support.

## Requirements

- RT 4.4.2
- Holidays skipping requires the Perl module `Date::Holidays` and e.g.
  `Date::Holidays::DE` for German holidays.

## Installation

Extract this extension to a temporary location.

Git clone:

```
cd /usr/local/src
git clone https://github.com/NETWAYS/rt-extension-ticketactions
```

Tarball download (latest [release](https://github.com/NETWAYS/rt-extension-ticketactions/releases/latest)):

```
cd /usr/local/src
wget https://github.com/NETWAYS/rt-extension-ticketactions/archive/master.zip
unzip master.zip
```

Navigate into the source directory and install the extension.

```
perl Makefile.PL
make
make install
```

Clear your mason cache.

```
rm -rf /opt/rt4/var/mason_data/obj
```

Restart your web server.

```
systemctl restart httpd

systemctl restart apache2
```

## Configuration

**$TicketActions_FollowUpDays**

List of days for which to provide follow-up actions. e.g. `[1, 3, 10]` will result in three
follow-up actions: For the next day, in three days and in ten days, respectively.

**$TicketActions_FollowUpTime**

Time of day when follow-up is reached. (e.g. `'10:00:00'`) This should be in 24-hour format.

**$TicketActions_HolidaysCountry**

Country to skip holidays of. (e.g. `'DE'`) This should be a ISO 3166-1 alpha-2 country code.

**$TicketActions_SkipDaysOfWeek**

Days of week to skip (e.g. `['sat', 'sun']`) You can choose the following values:

* `sun` (Sunday)
* `mon` (Monday)
* `tue` (Tuesday)
* `wed` (Wednesday)
* `thu` (Thursday)
* `fri` (Friday)
* `sat` (Saturday)

### Example

```perl
Plugin('RT::Extension::TicketActions');

Set($TicketActions_FollowUpDays, [1, 3, 10]);
Set($TicketActions_FollowUpTime, '10:00:00');
Set($TicketActions_HolidaysCountry, 'DE');
Set($TicketActions_SkipDaysOfWeek, ['sat', 'sun']);
```
