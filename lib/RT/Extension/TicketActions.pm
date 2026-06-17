package RT::Extension::TicketActions;

use 5.10.1;
use strict;
use warnings;
use RT;

our $VERSION='2.1.0';

RT->AddStyleSheets('ticketactions.css');

# Register the icons we need that RT does not ship in its built-in %SVG set.
# These are Bootstrap Icons (MIT licensed, https://icons.getbootstrap.com).
{
    my %icons = (
        'person-plus-fill' => '<path d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/><path fill-rule="evenodd" d="M13.5 5a.5.5 0 0 1 .5.5V7h1.5a.5.5 0 0 1 0 1H14v1.5a.5.5 0 0 1-1 0V8h-1.5a.5.5 0 0 1 0-1H13V5.5a.5.5 0 0 1 .5-.5"/>',
        'person-dash-fill' => '<path fill-rule="evenodd" d="M11 7.5a.5.5 0 0 1 .5-.5h4a.5.5 0 0 1 0 1h-4a.5.5 0 0 1-.5-.5"/><path d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>',
        'person-x-fill'    => '<path fill-rule="evenodd" d="M1 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6m6.146-2.854a.5.5 0 0 1 .708 0L14 6.293l1.146-1.147a.5.5 0 0 1 .708.708L14.707 7l1.147 1.146a.5.5 0 0 1-.708.708L14 7.707l-1.146 1.147a.5.5 0 0 1-.708-.708L13.293 7l-1.147-1.146a.5.5 0 0 1 0-.708"/>',
        'folder2-open'     => '<path d="M1 3.5A1.5 1.5 0 0 1 2.5 2h2.764c.958 0 1.76.56 2.311 1.184C7.985 3.648 8.48 4 9 4h4.5A1.5 1.5 0 0 1 15 5.5v.64c.57.265.94.876.856 1.546l-.64 5.124A2.5 2.5 0 0 1 12.733 15H3.266a2.5 2.5 0 0 1-2.481-2.19l-.64-5.124A1.5 1.5 0 0 1 1 6.14zM2 6h12v-.5a.5.5 0 0 0-.5-.5H9c-.964 0-1.71-.629-2.174-1.154C6.374 3.334 5.82 3 5.264 3H2.5a.5.5 0 0 0-.5.5zm-.367 1a.5.5 0 0 0-.496.562l.64 5.124A1.5 1.5 0 0 0 3.266 14h9.468a1.5 1.5 0 0 0 1.489-1.314l.64-5.124A.5.5 0 0 0 14.367 7z"/>',
        'slash-circle'     => '<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/><path d="M11.354 4.646a.5.5 0 0 0-.708 0l-6 6a.5.5 0 0 0 .708.708l6-6a.5.5 0 0 0 0-.708"/>',
        'check-circle-fill' => '<path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>',
        'pause-circle-fill' => '<path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0M6.25 5C5.56 5 5 5.56 5 6.25v3.5a1.25 1.25 0 1 0 2.5 0v-3.5C7.5 5.56 6.94 5 6.25 5m3.5 0c-.69 0-1.25.56-1.25 1.25v3.5a1.25 1.25 0 1 0 2.5 0v-3.5C11 5.56 10.44 5 9.75 5"/>',
    );

    my $svg = RT->Config->Get('SVG');
    if ( ref $svg eq 'HASH' ) {
        $svg->{$_} //= $icons{$_} for keys %icons;
    }
}

=head2 FollowUpActions $ticket

Returns the list of NETWAYS quick-access entries (QuickResolve, QuickStall and
the relative Follow-up due-date actions) for C<$ticket>, each as a hashref
C<< { key => ..., title => ..., path => ... } >>. Shared by the ticket display
widget and the Privileged page-menu callback.

=cut

sub FollowUpActions {
    my ($ticket) = @_;

    my $cu     = $ticket->CurrentUser;
    my $id     = $ticket->id;
    my $status = $ticket->Status;
    my @out;

    return @out unless $ticket->CurrentUserHasRight('ModifyTicket');

    if ( $status ne 'resolved' ) {
        push @out, {
            key   => 'rt_extension_quick_resolve',
            title => $cu->loc('QuickResolve'),
            path  => '/Ticket/Display.html?'
                . HTML::Mason::Commands::QueryString( id => $id, Status => 'resolved' ),
        };
    }

    if ( $status eq 'open' ) {
        push @out, {
            key   => 'rt_extension_quick_stalled',
            title => $cu->loc('QuickStall'),
            path  => '/Ticket/Display.html?'
                . HTML::Mason::Commands::QueryString( id => $id, Status => 'stalled' ),
        };
    }

    if ( $status ne 'stalled' ) {
        my $follow_up_time = RT->Config->Get('TicketActions_FollowUpTime') || '10:00:00';
        my @follow_up_days = @{ RT->Config->Get('TicketActions_FollowUpDays') // [ 1, 7, 14 ] };

        my %dow = ( sun => 0, mon => 1, tue => 2, wed => 3, thu => 4, fri => 5, sat => 6 );
        my %skipDow = map { $dow{$_} => 1 }
            @{ RT->Config->Get('TicketActions_SkipDaysOfWeek') // [ 'sat', 'sun' ] };

        my $holidays = _holidaysCache();

        foreach my $fu_day (@follow_up_days) {
            my $date = RT::Date->new($cu);
            $date->SetToNow();
            $date->Set( Format => 'iso', Value => $date->Date() . ' ' . $follow_up_time );
            $date->AddDays($fu_day);

            # Day-of-week in the same timezone (UTC) that $date->ISO() uses,
            # so the weekend skip stays consistent with the displayed/stored date.
            while ( $skipDow{ ( $date->Localtime('utc') )[6] } || _isHoliday( $date, $holidays ) ) {
                $date->AddDays(1);
            }

            push @out, {
                key   => 'rt_extension_actions_fu_' . $fu_day,
                title => 'Follow up '
                    . ( $fu_day % 7 ? "$fu_day day" : ( $fu_day / 7 ) . ' week' )
                    . ( $fu_day == 1 || $fu_day == 7 ? '' : 's' )
                    . "\n(" . $date->ISO() . ')',
                path => '/Ticket/Display.html?'
                    . HTML::Mason::Commands::QueryString(
                        id => $id, Status => 'stalled', Due_Date => $date->ISO(),
                    ),
            };
        }
    }

    return @out;
}

sub _isHoliday {
    my ( $date, $cache ) = @_;
    return unless ( defined($cache) && $date->ISO() =~ /^(\d+)-(\d+-\d+)/ );

    my ( $year, $day ) = ( $1, $2 );

    unless ( exists $cache->{cache}->{$year} ) {
        $cache->{cache}->{$year} = {};
        for my $holiday ( keys( %{ $cache->{repo}->holidays( year => $year ) } ) ) {
            if ( $holiday =~ /^(\d{2})(\d{2})/ ) {
                $cache->{cache}->{$year}->{ $1 . '-' . $2 } = 1;
            }
        }
    }

    exists $cache->{cache}->{$year}->{$day};
}

sub _holidaysCache {
    my $country = RT->Config->Get('TicketActions_HolidaysCountry');
    return unless defined $country;

    my $repo = eval {
        require Date::Holidays;
        Date::Holidays->new( countrycode => $country );
    };
    unless ($repo) {
        RT->Logger->error(
            "TicketActions: holiday skipping is enabled (TicketActions_HolidaysCountry"
            . " = '$country') but Date::Holidays could not be loaded for that country: $@"
        );
        return;
    }

    return {
        repo  => $repo,
        cache => {},
    };
}

=pod

=head1 NAME

RT::Extension::TicketActions

=head1 DESCRIPTION

Provides easy access to frequently used ticket actions.

Also so called "follow-up" actions set the ticket status to `stalled` and add a relative due date with a fixed time.
This means that a ticket should be due in x days. This combination of properties can be used in searches or escalations
to bring tickets up to users. In addition holidays of a specific country and specific days of week can be skipped
automatically, if enabled.

=head1 RT VERSION

Works with RT 6.0.0

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

=item Edit your F</opt/rt/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::TicketActions');

=item Clear your mason cache

    rm -rf /opt/rt/var/mason_data/obj

=item Restart your webserver

=item Add the C<TicketActions> widget to the ticket display

Via B<Admin --E<gt> Page Layouts> (class C<RT::Ticket>, page C<Display>) place
the C<TicketActions> element where the "Quick Actions" box should appear.

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
