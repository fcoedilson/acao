package Acao::Controller::Auth::Usuario;

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

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller'; }
use Data::Dumper;
use utf8;
use XML::Simple;
with 'Acao::Role::Auditoria' => { category => 'Admin.Usuario' };

#


sub ver_user : Chained('/auth/base') : PathPart('usuario') : Args(0) {
    my ( $self, $c,  ) = @_;
    $c->stash->{template} = 'auth/usuario/ver.tt';
    $c->stash->{dn_usuario} = $c->user->dn;
    $c->stash->{usuario} = $c->model('Usuario')->getDadosUsuarioLdap( $c->user->dn, 'adm' );

    $c->stash->{usuario_sistema} = $c->model('Usuario')->getDadosUsuarioLdap( $c->user->dn, 'acao' );

}

sub store_alterar_senha : Chained('/auth/base')
  : PathPart('usuario/alterar') : Args(0)
{
    my ( $self, $c ) = @_;

    my $result = $c->model('LDAP')->changeMemberPassword(
        {
            'new_pass' => $c->req->param('new_pass'),
            'dn'       => $c->user->dn
        }
    );
    $c->stash->{resultado} = $result->{resultCode};
    $self->audit_alterar('SENHA DE : ' . $c->stash->{dn_usuario} . ': POR: ' . $c->user->uid );
    $c->stash->{template} = 'auth/usuario/sucesso_alter_pass.tt';

}



1;
