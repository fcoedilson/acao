package Acao::Plugins::SDH::DimSchema::Result::DTempoMoradia;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Acao::Plugins::SDH::DimSchema::Result::DTempoMoradia

=cut

__PACKAGE__->table("d_tempo_moradia");

=head1 ACCESSORS

=head2 id_tempo_moradia

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'd_tempo_moradia_id_tempo_moradia_seq'

=head2 tempo_moradia

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id_tempo_moradia",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "d_tempo_moradia_id_tempo_moradia_seq",
  },
  "tempo_moradia",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
);
__PACKAGE__->set_primary_key("id_tempo_moradia");

=head1 RELATIONS

=head2 f_atendimentoes

Type: has_many

Related object: L<Acao::Plugins::SDH::DimSchema::Result::FAtendimento>

=cut

__PACKAGE__->has_many(
  "f_atendimentoes",
  "Acao::Plugins::SDH::DimSchema::Result::FAtendimento",
  { "foreign.id_tempo_moradia" => "self.id_tempo_moradia" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-22 14:32:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3+ERCD2E9QLT91q2A7z44A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
