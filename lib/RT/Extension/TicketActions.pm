package RT::Extension::TicketActions;

use 5.10.1;
use strict;
use version;
use RT;

our $VERSION="1.0.1";

RT->AddJavaScript('fontawesome-svg/js/fontawesome-all.min.js');
RT->AddStyleSheets('ticketactions.css');

=pod

=head1 NAME

RT::Extension::TicketActions

=head1 DESCRIPTION

Provides easy access to frequently used ticket actions.

Also so called "follow-up" actions set the ticket status to `stalled` and add a relative due date with a fixed time.
This means that a ticket should be due in x days. This combination of properties can be used in searches or escalations
to bring tickets up to users. In addition holidays of a specific country and specific days of week can be skipped
automatically, if enabled.

In addition to that, this extension provides navigation items if you have opened this ticket from a search result
listing. You can navigate between search result tickets (first, previous, next, last), open the search result list
again or even modify the search query.

=head1 RT VERSION

Works with RT 4.4.2

=head1 REQUIREMENTS

=over

=item Date::Holidays (>= 1.07)

If you want to enable automatic holiday skipping.

=back

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::TicketActions');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 CONFIGURATION

=head2 C<$TicketActions_FollowUpDays>

List of days for which to provide follow-up actions. e.g. C<[1, 3, 10]> will result in three
follow-up actions: For the next day, in three days and in ten days, respectively.

=head2 C<$TicketActions_FollowUpTime>

Time of day when follow-up is reached. (e.g. C<'10:00:00'>) This should be in 24-hour format.

=head2 C<$TicketActions_HolidaysCountry>

Country to skip holidays of. (e.g. C<'DE'>) This should be a ISO 3166-1 alpha-2 country code.

=head2 C<$TicketActions_SkipDaysOfWeek>

Days of week to skip (e.g. C<['sat', 'sun']>) You can choose the following values:

=over

=item C<sun> (Sunday)

=item C<mon> (Monday)

=item C<tue> (Tuesday)

=item C<wed> (Wednesday)

=item C<thu> (Thursday)

=item C<fri> (Friday)

=item C<sat> (Saturday)

=back

=head2 Example

=over

=item C<# Enables everything provided by RT::Extension::TicketActions>

=item C<Set($TicketActions_FollowUpDays, [1, 3, 10]);>

=item C<Set($TicketActions_FollowUpTime, '10:00:00');>

=item C<Set($TicketActions_HolidaysCountry, 'DE');>

=item C<Set($TicketActions_SkipDaysOfWeek, ['sat', 'sun']);>

=back

=head1 AUTHOR

NETWAYS GmbH <support@netways.de>

=head1 BUGS

All bugs should be reported on L<GitHub|https://github.com/NETWAYS/rt-extension-ticketactions>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
