package Acao::Controller::Auth::Registros::Revisor::Leitura;

# Copyright 2010 - Prefeitura Municipal de Fortaleza
#
# Este arquivo é parte do programa Ação - Sistema de Acompanhamento de
# Projetos Sociais
#
# O Ação é um software livre; você pode redistribui-lo e/ou modifica-lo
# dentro dos termos da Licença Pública Geral GNU como publicada pela
# Fundação do Software Livre (FSF); na versão 2 da Licença.
#
# Este programa é distribuido na esperança que possa ser util, mas SEM
# NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO a qualquer
# MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença Pública Geral GNU
# para maiores detalhes.
#
# Você deve ter recebido uma cópia da Licença Pública Geral GNU, sob o
# título "LICENCA.txt", junto com este programa, se não, escreva para a
# Fundação do Software Livre(FSF) Inc., 51 Franklin St, Fifth Floor,

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Acao::Controller::Auth::Registros::Revisor::Leitura - Implementa as
ações de um revisor específicas a uma leitura.

=head1 ACTIONS

=over

=item base

Carrega para o stash os dados da leitura solicitada.

=cut

sub base : Chained('/auth/registros/revisor/base') : PathPart('') :
  CaptureArgs(1) {
    my ( $self, $c, $id_leitura ) = @_;
    $c->stash->{leitura} = $c->model('Revisor')->obter_leitura($id_leitura)
      or $c->detach('/public/default');
}

=item lista

Delega para a view a exibição da lista dos documentos dessa leitura.

=cut

sub lista : Chained('base') : PathPart('') : Args(0) {

}

=item aprovar

Faz a aprovação de um documento específico.

=cut

sub aprovar : Chained('base') : PathPart : Args(2) {
    my ( $self, $c, $id_doc, $controle ) = @_;
    eval {
        $c->model('Revisor')
          ->aprovar( $c->stash->{leitura}, $id_doc, $controle );
    };
    if ($@) {
        $c->flash->{erro} = $@;
    }
    else {
        $c->flash->{sucesso} = 'estadocontrole-aberto';
    }
    $c->res->redirect(
        $c->uri_for_action(
            '/auth/registros/revisor/leitura/lista',
            [ $c->stash->{leitura}->id_leitura ]
        )
    );
}

=item rejeitar

Faz a rejeição de um documento específico.

=cut

sub rejeitar : Chained('base') : PathPart : Args(2) {
    my ( $self, $c, $id_doc, $controle ) = @_;

    eval {
        $c->model('Revisor')
          ->rejeitar( $c->stash->{leitura}, $id_doc, $controle );
    };
    if ($@) {
        $c->flash->{erro} = $@;
    }
    else {
        $c->flash->{sucesso} = 'estadocontrole-aberto';
    }
    $c->res->redirect(
        $c->uri_for_action(
            '/auth/registros/revisor/leitura/lista',
            [ $c->stash->{leitura}->id_leitura ]
        )
    );
}

=item fecharDocumento

Fecha um grupo de controle na digitação.

=cut

sub fecharDocumento : Chained('base') : PathPart : Args(1) {
    my ( $self, $c, $controle ) = @_;
    eval {
        $c->model('Revisor')
          ->fecharDocumento( $c->stash->{leitura}, $controle );
    };
    if ($@) {
        $c->flash->{erro} = $@;
    }
    else {
        $c->flash->{sucesso} = 'digitacoes-revisadas';
    }
    $c->res->redirect(
        $c->uri_for_action(
            '/auth/registros/revisor/leitura/lista',
            [ $c->stash->{leitura}->id_leitura ]
        )
    );
}

=item visualizar_base

Define o contexto de um documento específico.

=cut

sub visualizar_base : Chained('base') : PathPart('visualizar') : CaptureArgs(1)
{
    my ( $self, $c, $id_doc ) = @_;
    $c->stash->{id_doc} = $id_doc;
    $c->stash->{campo_controle} =
      $c->model('Revisor')
      ->obter_campo_controle( $c->stash->{leitura}, $id_doc );
}

=item visualizar

Delega à view a chamada do formulário para a visualização e possível redigitação.

=cut

sub visualizar : Chained('visualizar_base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
}

=item store

Salva o xml como uma nova digitação, a partir da visualização de um
documento previamente digitado.

=cut

sub store : Chained('visualizar_base') : PathPart : Args(0) {
    my ( $self, $c ) = @_;
    my $xml     = $c->request->param('processed_xml');
    my $leitura = $c->stash->{leitura};

    eval {
        $c->model('Digitador')
          ->salvar_digitacao( $leitura, $xml, $c->stash->{campo_controle},
            $c->req->address );
    };

    if ($@) {
        $c->flash->{erro} = $@ . "";
    }
    else {
        $c->flash->{sucesso} = 'Digitação armazenada com sucesso';
    }

    $c->res->redirect(
        $c->uri_for_action(
            '/auth/registros/revisor/leitura/lista',
            [ $c->stash->{leitura}->id_leitura ],
            {}
        )
    );
}

=item xml

Delega à view XML a exibição do documento específico.

=cut

sub xml : Chained('visualizar_base') : PathPart : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{document} =
      $c->model('Revisor')
      ->visualizar( $c->stash->{leitura}, $c->stash->{id_doc} );
    $c->forward( $c->view('XML') );
}

=item xsd

Retorna o XSD da leitura.

=cut

sub xsd : Chained('base') : PathPart('xsd') : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{document} =
      $c->model('Revisor')->obter_xsd_leitura( $c->stash->{leitura} );
    $c->forward( $c->view('XML') );
}

=back

=head1 COPYRIGHT AND LICENSING

Copyright 2010 - Prefeitura de Fortaleza. Este software é licenciado
sob a GPL versão 2.

=cut

1;
