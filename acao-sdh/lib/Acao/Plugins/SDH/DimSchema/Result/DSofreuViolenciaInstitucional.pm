package Acao::Plugins::SDH::DimSchema::Result::DSofreuViolenciaInstitucional;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Acao::Plugins::SDH::DimSchema::Result::DSofreuViolenciaInstitucional

=cut

__PACKAGE__->table("d_sofreu_violencia_institucional");

=head1 ACCESSORS

=head2 id_sofreu_violencia_institucional

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'd_sofreu_violencia_institucional_id_sofreu_violencia_institu792'

=head2 sofreu_violencia_institucional

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id_sofreu_violencia_institucional",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "d_sofreu_violencia_institucional_id_sofreu_violencia_institu792",
  },
  "sofreu_violencia_institucional",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
);
__PACKAGE__->set_primary_key("id_sofreu_violencia_institucional");

=head1 RELATIONS

=head2 f_atendimentoes

Type: has_many

Related object: L<Acao::Plugins::SDH::DimSchema::Result::FAtendimento>

=cut

__PACKAGE__->has_many(
  "f_atendimentoes",
  "Acao::Plugins::SDH::DimSchema::Result::FAtendimento",
  {
    "foreign.id_sofreu_violencia_institucional" => "self.id_sofreu_violencia_institucional",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-22 14:32:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5V7U90dzmCBeCmBftvYOiA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
