package RT::Extension::TicketActions;

use strict;
use version;
use RT;

our $VERSION="1.0.1";

RT->AddJavaScript('fontawesome-svg/js/fontawesome-all.min.js');
RT->AddStyleSheets('ticketactions.css');

1;

=pod

=head1 NAME

RT::Extension::TicketActions

=head1 VERSION

version 1.0.1

=head1 AUTHOR

Marius Hein <marius.hein@netways.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by NETWAYS GmbH <info@netways.de>

This is free software, licensed under:
    GPL Version 2, June 1991

=cut

__END__
