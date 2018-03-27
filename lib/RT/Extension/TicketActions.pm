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

A simple extension that works with RT 4.4.2 which provides easy access to
frequently used ticket actions.

=head1 RT VERSION

Works with RT 4.4.2

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

List of follow-up action days, e.g. C<[1, 3, 10]> days

=head2 C<$TicketActions_FollowUpTime>

Time of day when follow-up is reached, e.g. C<'10:00:00'>

=head2 C<$TicketActions_HolidaysCountry>

Country to skip holidays of (ISO 3361 country code, e.g. C<'DE'>)

=head2 C<$TicketActions_SkipDaysOfWeek>

Days of week to skip, e.g. C<['sat', 'sun']> for the weekend

=head1 AUTHOR

NETWAYS GmbH L<support@netways.de|mailto:support@netways.de>

=head1 BUGS

All bugs should be reported at L<GitHub|https://github.com/NETWAYS/rt-extension-ticketactions/issues>.

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2018 by NETWAYS GmbH

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

1;
