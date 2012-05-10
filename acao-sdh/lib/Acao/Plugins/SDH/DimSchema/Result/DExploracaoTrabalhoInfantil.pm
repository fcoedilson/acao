package Acao::Plugins::SDH::DimSchema::Result::DExploracaoTrabalhoInfantil;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Acao::Plugins::SDH::DimSchema::Result::DExploracaoTrabalhoInfantil

=cut

__PACKAGE__->table("d_exploracao_trabalho_infantil");

=head1 ACCESSORS

=head2 id_exploracao_trabalho_infantil

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'd_exploracao_trabalho_infantil_id_exploracao_trabalho_infant500'

=head2 exploracao_trabalho_infantil

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=cut

__PACKAGE__->add_columns(
  "id_exploracao_trabalho_infantil",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "d_exploracao_trabalho_infantil_id_exploracao_trabalho_infant500",
  },
  "exploracao_trabalho_infantil",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
);
__PACKAGE__->set_primary_key("id_exploracao_trabalho_infantil");

=head1 RELATIONS

=head2 f_atendimentoes

Type: has_many

Related object: L<Acao::Plugins::SDH::DimSchema::Result::FAtendimento>

=cut

__PACKAGE__->has_many(
  "f_atendimentoes",
  "Acao::Plugins::SDH::DimSchema::Result::FAtendimento",
  {
    "foreign.id_exploracao_trabalho_infantil" => "self.id_exploracao_trabalho_infantil",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-22 14:32:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/75x0YE6+St967E2pj7GxA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
