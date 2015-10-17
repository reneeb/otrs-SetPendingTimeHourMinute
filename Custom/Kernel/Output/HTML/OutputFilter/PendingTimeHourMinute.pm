# --
# Kernel/Output/HTML/OutputFilter/PendingTimeHourMinute.pm
# Copyright (C) 2015 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilter::PendingTimeHourMinute;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Web::Request
    Kernel::System::Ticket
    Kernel::Output::HTML::Layout
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{UserID} = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get template name
    my $Templatename = $Param{TemplateFile} || '';
    return 1 if !$Templatename;
    return 1 if !first { $Templatename eq $_ }keys %{$Param{Templates}};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Hour         = $ConfigObject->Get('Minati::DefaultPendingHour');
    my $Minute       = $ConfigObject->Get('Minati::DefaultPendingMinute');

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->AddJSOnDocumentComplete( Code => qq~
        <script type="text/javascript">//<![CDATA[
            \$('#Hour').val( $Hour );
            \$('#Minute').val( $Minute );
        //]]></script>~
    );

    return ${ $Param{Data} };
}

1;
